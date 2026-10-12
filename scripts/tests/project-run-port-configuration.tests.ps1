$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$helper = Join-Path $repoRoot '.agents\skills\ai-skills-run\ai-skills-project-run-start\run-project.ps1'
$reference = Join-Path $repoRoot '.agents\skills\ai-skills-run\references\run-configuration.md'
$startSkill = Join-Path $repoRoot '.agents\skills\ai-skills-run\ai-skills-project-run-start\SKILL.md'
$statusSkill = Join-Path $repoRoot '.agents\skills\ai-skills-run\ai-skills-project-run-status\SKILL.md'
$stopSkill = Join-Path $repoRoot '.agents\skills\ai-skills-run\ai-skills-project-run-stop\SKILL.md'
$compatibilitySkill = Join-Path $repoRoot '.agents\skills\ai-skills-library\ai-skills-project-run-start\SKILL.md'
$tempRoot = Join-Path ([IO.Path]::GetTempPath()) ('project-run-port-' + [Guid]::NewGuid().ToString('N'))

function Assert([bool] $Condition, [string] $Message) {
    if (-not $Condition) { throw $Message }
}

New-Item -ItemType Directory -Path (Join-Path $tempRoot '.agents') -Force | Out-Null
try {
    $referenceText = Get-Content -LiteralPath $reference -Raw
    Assert ($referenceText.Contains('4000-10000')) 'Reference is missing the shared default range.'
    Assert ($referenceText.Contains('.agents/project-run-configuration.md')) 'Reference is missing the project declaration path.'
    Assert ((Get-Content -LiteralPath $startSkill -Raw).Contains('effective declaration')) 'Start skill does not reference the effective declaration.'
    Assert ((Get-Content -LiteralPath $statusSkill -Raw).Contains('reconciliation plan')) 'Status skill does not describe bounded reconciliation.'
    Assert ((Get-Content -LiteralPath $stopSkill -Raw).Contains('references/run-configuration.md')) 'Stop skill does not reference the shared policy.'
    Assert ((Get-Content -LiteralPath $compatibilitySkill -Raw).Contains('../ai-skills-run/references/run-configuration.md')) 'Project-specific Start skill does not delegate to the reusable policy.'

    $projectFixtures = @(
        [pscustomobject]@{ Root = 'game-a'; Min = 7000; Max = 7099; Active = 7000; Declared = $true },
        [pscustomobject]@{ Root = 'game-b'; Min = 7050; Max = 7149; Active = 7050; Declared = $true },
        [pscustomobject]@{ Root = 'game-c'; Min = 4000; Max = 10000; Active = $null; Declared = $false }
    )
    $overlap = @($projectFixtures[0], $projectFixtures[1]) | Where-Object { $_.Min -le $projectFixtures[0].Max -and $_.Max -ge $projectFixtures[0].Min }
    Assert ($overlap.Count -eq 2) 'Overlapping project fixture was not detected.'
    Assert (-not $projectFixtures[2].Declared) 'Undeclared project fixture was not preserved.'
    Assert ((Get-Content -LiteralPath $statusSkill -Raw).Contains('active port collisions')) 'Status skill does not distinguish active collisions from declaration overlap.'

    $configPath = Join-Path $tempRoot '.agents\project-run-configuration.md'
    @'
# Project Run Configuration
preferredPort: 7000
portRange: 7000-7099
'@ | Set-Content -LiteralPath $configPath -Encoding utf8
    $valid = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $helper -ProjectRoot $tempRoot -Port 5174 -RoutesJson '[]' -ValidateOnly 2>&1
    Assert ($LASTEXITCODE -eq 0) "Valid configuration was rejected: $valid"
    $validJson = $valid | ConvertFrom-Json
    Assert ($validJson.preferredPort -eq 7000) 'Preferred port was not read from the declaration.'
    Assert ($validJson.range.min -eq 7000 -and $validJson.range.max -eq 7099) 'Declared range was not read correctly.'

    @'
preferredPort: 7100
portRange: 7000-7099
'@ | Set-Content -LiteralPath $configPath -Encoding utf8
    $savedErrorAction = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $invalid = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $helper -ProjectRoot $tempRoot -Port 5174 -RoutesJson '[]' -ValidateOnly 2>&1
    $invalidExitCode = $LASTEXITCODE
    $ErrorActionPreference = $savedErrorAction
    Assert ($invalidExitCode -ne 0) 'Out-of-range preferred port was accepted.'
    Assert (($invalid -join "`n") -match 'outside project port range') 'Invalid configuration did not explain the range error.'

    Remove-Item -LiteralPath $configPath -Force
    $default = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $helper -ProjectRoot $tempRoot -Port 5174 -RoutesJson '[]' -ValidateOnly 2>&1
    Assert ($LASTEXITCODE -eq 0) "Missing configuration was rejected: $default"
    $defaultJson = $default | ConvertFrom-Json
    Assert ($defaultJson.range.min -eq 4000 -and $defaultJson.range.max -eq 10000) 'Shared default range was not applied.'

    Write-Output 'All project-run port configuration scenarios passed.'
}
finally {
    if (Test-Path -LiteralPath $tempRoot) { Remove-Item -LiteralPath $tempRoot -Recurse -Force }
}
