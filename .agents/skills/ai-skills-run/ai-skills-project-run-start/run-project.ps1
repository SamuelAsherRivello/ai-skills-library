[CmdletBinding()]
param(
  [Parameter(Mandatory)] [string] $ProjectRoot,
  [Parameter(Mandatory)] [int] $Port,
  [Parameter(Mandatory)] [string] $RoutesJson,
  [switch] $DisableHmr,
  [switch] $ValidateOnly,
  [int] $PortCount = 20,
  [int] $StartupTimeoutSeconds = 20,
  [int] $StableSamples = 3
)

$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath($ProjectRoot).TrimEnd('\')
$routes = @($RoutesJson | ConvertFrom-Json)
if (-not $routes.Count) { throw 'At least one route is required.' }
$configurationPath = Join-Path $root '.agents/project-run-configuration.md'
$defaultRangeMin = 4000
$defaultRangeMax = 10000

function Get-RunConfiguration {
  $rangeMin = $defaultRangeMin
  $rangeMax = $defaultRangeMax
  $declaredPreferred = $null
  $declaredRange = $false
  $declaredPreferredValue = $false

  if (Test-Path -LiteralPath $configurationPath -PathType Leaf) {
    foreach ($line in Get-Content -LiteralPath $configurationPath) {
      if ([string]::IsNullOrWhiteSpace($line) -or $line -match '^\s*#') { continue }
      if ($line -match '^\s*portRange\s*:\s*(\d+)\s*-\s*(\d+)\s*$') {
        $rangeMin = [int]$Matches[1]
        $rangeMax = [int]$Matches[2]
        $declaredRange = $true
        continue
      }
      if ($line -match '^\s*preferredPort\s*:\s*(\d+)\s*$') {
        $declaredPreferred = [int]$Matches[1]
        $declaredPreferredValue = $true
        continue
      }
      if ($line -match '^\s*(portRange|preferredPort)\s*:') {
        throw "Invalid project run configuration at $configurationPath. Expected portRange: MIN-MAX and preferredPort: PORT."
      }
    }
  }

  if ($rangeMin -lt 1 -or $rangeMax -gt 65535 -or $rangeMin -gt $rangeMax) {
    throw "Invalid project port range $rangeMin-$rangeMax in $configurationPath."
  }

  $preferred = if ($declaredPreferredValue) { $declaredPreferred } else { $Port }
  if ($preferred -lt $rangeMin -or $preferred -gt $rangeMax) {
    if ($declaredPreferredValue -or $declaredRange) {
      throw "Preferred port $preferred is outside project port range $rangeMin-$rangeMax in $configurationPath."
    }
    $preferred = $rangeMin
  }

  [pscustomobject]@{
    RangeMin = $rangeMin
    RangeMax = $rangeMax
    PreferredPort = $preferred
    Provenance = if (Test-Path -LiteralPath $configurationPath -PathType Leaf) { 'project-declaration' } else { 'shared-default' }
    DeclarationPath = if (Test-Path -LiteralPath $configurationPath -PathType Leaf) { $configurationPath } else { $null }
  }
}

$runConfiguration = Get-RunConfiguration
if ($ValidateOnly) {
  [pscustomobject]@{
    range = [pscustomobject]@{ min = $runConfiguration.RangeMin; max = $runConfiguration.RangeMax }
    preferredPort = $runConfiguration.PreferredPort
    provenance = $runConfiguration.Provenance
    declarationPath = $runConfiguration.DeclarationPath
  } | ConvertTo-Json -Compress
  exit 0
}

$stateDirectory = Join-Path $root 'output/run-state'
$statePath = Join-Path $stateDirectory 'project-run.json'
$logDirectory = Join-Path $root 'output/logs/project-run-start'
New-Item -ItemType Directory -Path $stateDirectory, $logDirectory -Force | Out-Null

function Get-ProcessInventory {
  try { return @(Get-CimInstance Win32_Process -ErrorAction Stop) }
  catch { return $null }
}

function Get-ListeningPids([int] $port) {
  try { return @(Get-NetTCPConnection -LocalAddress '127.0.0.1' -LocalPort $port -State Listen -ErrorAction Stop | Select-Object -ExpandProperty OwningProcess -Unique) }
  catch {
    return @(netstat.exe -ano -p tcp 2>$null | Select-String ("127\.0\.0\.1:$port\s+.*LISTENING\s+(\d+)$") | ForEach-Object { [int]$_.Matches[0].Groups[1].Value } | Select-Object -Unique)
  }
}

function Test-ProjectCommand($process) {
  if (-not $process.CommandLine) { return $false }
  $command = $process.CommandLine.Replace('/', '\')
  $rootNeedle = $root.Replace('/', '\')
  return $command.IndexOf($rootNeedle, [StringComparison]::OrdinalIgnoreCase) -ge 0 -and
    $command -match '(?i)(npm\s+run\s+dev|dev-all\.mjs|vite|project-run-start)'
}

function Get-OwnedProcesses($inventory) {
  if ($null -eq $inventory) { return $null }
  return @($inventory | Where-Object {
    $_.Name -in @('node.exe','npm.exe','cmd.exe') -and (Test-ProjectCommand $_)
  })
}

function Stop-ProcessTree([int] $pid) {
  if ($pid -gt 0) { & taskkill.exe /PID $pid /T /F 2>$null | Out-Null }
}

function Test-RouteHealth([int] $port) {
  $results = foreach ($route in $routes) {
    $url = "http://127.0.0.1:$port$($route.route)"
    try {
      $response = Invoke-WebRequest $url -UseBasicParsing -TimeoutSec 2
      $title = if ($response.Content -match '<title[^>]*>\s*([^<]+?)\s*</title>') { $Matches[1].Trim() } else { '' }
      [pscustomobject]@{ Label=$route.label; Route=$route.route; Status=[int]$response.StatusCode; Title=$title; Url=$url; Healthy=([int]$response.StatusCode -ge 200 -and [int]$response.StatusCode -lt 400 -and [bool]$title) }
    } catch {
      [pscustomobject]@{ Label=$route.label; Route=$route.route; Status='host-verification-pending'; Title=''; Url=$url; Healthy=$false }
    }
  }
  return @($results)
}

function Test-StableServer([int] $port, [int] $samples) {
  $last = $null
  for ($i = 0; $i -lt $samples; $i++) {
    $listeners = @(Get-ListeningPids $port)
    $health = @(Test-RouteHealth $port)
    if (-not $listeners.Count -or $health.Count -ne $routes.Count -or ($health | Where-Object { -not $_.Healthy })) { return $null }
    $last = $health
    if ($i -lt ($samples - 1)) { Start-Sleep -Milliseconds 300 }
  }
  return $last
}

function Write-State([int] $port, [int] $launcherPid, [int[]] $listenerPids, $health, [string] $logPath) {
  [pscustomobject]@{
    schema = 2; projectRoot = $root; serverMode = 'shared'; port = $port
    portRange = [pscustomobject]@{ min = $runConfiguration.RangeMin; max = $runConfiguration.RangeMax }
    portConfiguration = $runConfiguration.Provenance; declarationPath = $runConfiguration.DeclarationPath
    launcherPid = $launcherPid; listenerPids = @($listenerPids); logPath = $logPath
    startedAt = [DateTime]::UtcNow.ToString('o'); routes = @($health | ForEach-Object { [pscustomobject]@{ label=$_.Label; route=$_.Route; title=$_.Title; url=$_.Url } })
  } | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $statePath -Encoding utf8
}

# Reconcile only confirmed project processes. An unavailable process query is
# uncertainty, never permission to reuse an occupied port.
$inventory = Get-ProcessInventory
$owned = Get-OwnedProcesses $inventory
if ($null -ne $owned) {
  $owned | ForEach-Object { Stop-ProcessTree ([int]$_.ProcessId) }
  $deadline = [DateTime]::UtcNow.AddSeconds(5)
  do {
    Start-Sleep -Milliseconds 100
    $inventory = Get-ProcessInventory
    $owned = Get-OwnedProcesses $inventory
  } while ($null -ne $owned -and $owned.Count -and [DateTime]::UtcNow -lt $deadline)
}

$candidate = $runConfiguration.PreferredPort
$lastFailure = ''
while ($candidate -le $runConfiguration.RangeMax) {
  if (@(Get-ListeningPids $candidate).Count) { $candidate++; continue }
  $faucetCandidate = 5190
  while ($faucetCandidate -eq $candidate -or @(Get-ListeningPids $faucetCandidate).Count) { $faucetCandidate++ }

  $logPath = Join-Path $logDirectory ("codex-vite-$candidate-" + [guid]::NewGuid().ToString('N') + '.log')
  $hmrArgument = if ($DisableHmr) { ' --no-hmr' } else { '' }
  $arguments = "/d /c cd /d `"$root`" && npm run dev -- --host 127.0.0.1 --port $candidate --faucetPort $faucetCandidate --strictPort$hmrArgument > `"$logPath`" 2>&1"
  $launcher = Start-Process cmd.exe -ArgumentList $arguments -WorkingDirectory $root -WindowStyle Hidden -PassThru
  $deadline = [DateTime]::UtcNow.AddSeconds($StartupTimeoutSeconds)
  do {
    if ($launcher.HasExited) { break }
    $health = Test-StableServer $candidate $StableSamples
    if ($health) {
      $inventory = Get-ProcessInventory
      $owned = Get-OwnedProcesses $inventory
      if ($null -eq $owned -or $owned.Count -eq 0) { $lastFailure = 'server listener had no identifiable project process' }
      else {
        $listenerPids = @(Get-ListeningPids $candidate)
        Write-State $candidate ([int]$launcher.Id) ([int[]]$listenerPids) $health $logPath
        $health | ConvertTo-Json -Compress
        exit 0
      }
    }
  } while ([DateTime]::UtcNow -lt $deadline)

  Stop-ProcessTree ([int]$launcher.Id)
  $lastFailure = if (Test-Path -LiteralPath $logPath) { (Get-Content -Raw -LiteralPath $logPath -ErrorAction SilentlyContinue).Trim() } else { 'no launcher diagnostics' }
  if ($lastFailure -match '(?i)(EADDRINUSE|strictPort|in use|address already in use)') { $candidate++; continue }
  $listeners = @(Get-ListeningPids $candidate)
  $inventory = Get-ProcessInventory
  $owned = Get-OwnedProcesses $inventory
  if ($listeners.Count -and $null -ne $owned -and $owned.Count) {
    $pending = @($routes | ForEach-Object { [pscustomobject]@{ Label=$_.label; Route=$_.route; Status='host-verification-pending'; Title=''; Url="http://127.0.0.1:$candidate$($_.route)"; Healthy=$false } })
    Write-State $candidate ([int]$launcher.Id) ([int[]]$listeners) $pending $logPath
    $pending | ConvertTo-Json -Compress
    exit 0
  }
  $candidate++
}

if (Test-Path -LiteralPath $statePath) { Remove-Item -LiteralPath $statePath -Force -ErrorAction SilentlyContinue }
throw "No stable project server found from $($runConfiguration.PreferredPort) through $($runConfiguration.RangeMax). Last diagnostics: $lastFailure"
