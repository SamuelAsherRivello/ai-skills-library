[CmdletBinding()]
param(
    [string] $ProjectDirectory = (Get-Location).Path,
    [string] $GlobalSkillsDirectory = (Join-Path $HOME '.agents\skills'),
    [string] $LegacyGlobalSkillsDirectory = (Join-Path $HOME '.codex\skills'),
    [switch] $Initialize
)

$ErrorActionPreference = 'Stop'
$requiredSkills = @(
    'openspec-init',
    'openspec-dashboard',
    'openspec-explore',
    'openspec-grill-me',
    'openspec-propose',
    'openspec-update-change',
    'openspec-apply-change',
    'openspec-apply-change-with-playwright',
    'openspec-sync-specs',
    'openspec-archive-change',
    'openspec-commit-inclusive',
    'openspec-macro-finalize-sync-archive-commit-push',
    'openspec-orchestrate-proposal',
    'openspec-orchestrate-program',
    'openspec-create-program',
    'openspec-apply-program'
)

function Test-PhysicalTree([string] $Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) { return $false }
    $root = Get-Item -LiteralPath $Path -Force
    if (($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { return $false }
    foreach ($entry in Get-ChildItem -LiteralPath $Path -Force -Recurse) {
        if (($entry.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { return $false }
    }
    return $true
}

function Get-TreeDigest([string] $Path) {
    $records = foreach ($file in Get-ChildItem -LiteralPath $Path -File -Force -Recurse | Sort-Object FullName) {
        $relative = $file.FullName.Substring($Path.Length).TrimStart('\', '/').Replace('\', '/')
        "$relative`0$($file.Length)`0$((Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash)"
    }
    $bytes = [Text.Encoding]::UTF8.GetBytes(($records -join "`n"))
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-', '') }
    finally { $sha.Dispose() }
}

function Get-Suite([string] $Root) {
    $result = [ordered]@{ Root = $Root; Complete = $false; Invalid = @(); Present = @(); Digests = @{} }
    if (-not (Test-Path -LiteralPath $Root -PathType Container)) { return [pscustomobject] $result }
    foreach ($name in $requiredSkills) {
        $skill = Join-Path $Root $name
        if (-not (Test-Path -LiteralPath $skill -PathType Container)) { continue }
        $result.Present += $name
        if (-not (Test-PhysicalTree $skill) -or -not (Test-Path -LiteralPath (Join-Path $skill 'SKILL.md') -PathType Leaf)) {
            $result.Invalid += $name
            continue
        }
        $result.Digests[$name] = Get-TreeDigest $skill
    }
    $result.Complete = $result.Invalid.Count -eq 0 -and $result.Present.Count -eq $requiredSkills.Count
    return [pscustomobject] $result
}

function Compare-Suites($Left, $Right) {
    if (-not $Left.Complete -or -not $Right.Complete) { return 'incomplete' }
    foreach ($name in $requiredSkills) {
        if ($Left.Digests[$name] -cne $Right.Digests[$name]) { return 'different' }
    }
    return 'identical'
}

function Write-Result([string] $State, [string] $Message, $Global, $Project, $Legacy) {
    [pscustomobject]@{
        state = $State
        message = $Message
        project = $Project
        canonicalGlobal = $Global
        legacyGlobal = $Legacy
    } | ConvertTo-Json -Depth 6
}

$project = [IO.Path]::GetFullPath($ProjectDirectory)
if (-not (Test-Path -LiteralPath $project -PathType Container)) { throw "Project directory does not exist: $project" }
if (-not (Get-Command openspec -ErrorAction SilentlyContinue)) {
    Write-Result 'CliUnavailable' 'OpenSpec CLI is not available; install a supported CLI before bootstrap.' $null $project $null
    exit 2
}
$versionText = (& openspec --version 2>&1 | Out-String).Trim()
$version = $null
if (-not [Version]::TryParse(($versionText -replace '[^0-9.]', ''), [ref] $version) -or $version -lt [Version]'1.14.0') {
    Write-Result 'CliUnsupported' "OpenSpec 1.14.0 or later is required; found '$versionText'." $null $project $null
    exit 2
}

Push-Location $project
try { $contextText = (& openspec context --json 2>&1 | Out-String).Trim() }
finally { Pop-Location }
if ($contextText -match '(?i)Declared in|Invalid store declaration') {
    Write-Result 'DeclaredStoreInvalid' $contextText $null $project $null
    exit 2
}
try { $context = $contextText | ConvertFrom-Json -ErrorAction Stop } catch { $context = $null }
if ($context -and $context.root -and $context.root.path) {
    Write-Result 'AlreadyInitialized' 'A usable OpenSpec root already exists; bootstrap will not modify it.' $null $project $null
    exit 0
}

$planningRoot = Join-Path $project 'openspec'
if (Test-Path -LiteralPath $planningRoot) {
    $item = Get-Item -LiteralPath $planningRoot -Force
    $state = if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { 'PlanningRootLinked' } else { 'PlanningRootInvalid' }
    Write-Result $state 'An unresolved OpenSpec planning path already exists; repair or select its declared store before bootstrap.' $null $project $null
    exit 2
}

$global = Get-Suite ([IO.Path]::GetFullPath($GlobalSkillsDirectory))
$legacy = Get-Suite ([IO.Path]::GetFullPath($LegacyGlobalSkillsDirectory))
$projectAgents = Get-Suite (Join-Path $project '.agents\skills')
$projectCodex = Get-Suite (Join-Path $project '.codex\skills')
$projectSuites = @($projectAgents, $projectCodex)
$projectSuites = @($projectSuites | Where-Object { @($_.Present).Count -gt 0 })
if ((@($projectSuites | Where-Object { @($_.Invalid).Count -gt 0 }).Count -gt 0) -or $global.Invalid.Count -gt 0 -or $legacy.Invalid.Count -gt 0) {
    Write-Result 'LinkedOrInvalidSuite' 'A custom skill candidate is linked or malformed; do not initialize or copy until it is repaired.' $global $project $legacy
    exit 2
}
if ($projectSuites.Count -gt 0) {
    $state = if ($projectSuites.Count -gt 1) { 'ProjectDuplicate' } elseif (-not $projectSuites[0].Complete) { 'ProjectLocalPartial' } elseif (-not $global.Complete) { 'ProjectLocalException' } else { if ((Compare-Suites $projectSuites[0] $global) -eq 'identical') { 'ProjectGlobalDuplicate' } else { 'ProjectPrivateFork' } }
    Write-Result $state 'Project-local OpenSpec skills already exist. Preserve them; choose explicitly whether to retain, migrate, or retire them before bootstrap.' $global $project $legacy
    exit 2
}
if (-not $global.Complete) {
    Write-Result 'GlobalSuiteIncomplete' 'The canonical global custom suite is missing or partial. Select a trusted library source and install globally before bootstrap.' $global $project $legacy
    exit 2
}
if ($legacy.Present.Count -gt 0) {
    $state = if ($legacy.Complete) { if ((Compare-Suites $global $legacy) -eq 'identical') { 'LegacyGlobalDuplicate' } else { 'LegacyGlobalConflict' } } else { 'LegacyGlobalPartial' }
    Write-Result $state 'Legacy .codex global skills exist. Resolve the migration or duplicate explicitly; bootstrap will not modify either global root.' $global $project $legacy
    exit 2
}

if (-not $Initialize) {
    Write-Result 'ReadyToInitialize' 'The global custom suite is complete and no local copy or planning root exists. Re-run with -Initialize to create planning data only.' $global $project $legacy
    exit 0
}
Push-Location $project
try { & openspec init --tools none; $exitCode = $LASTEXITCODE }
finally { Pop-Location }
if ($exitCode -ne 0) { throw "openspec init --tools none failed with exit code $exitCode." }
Push-Location $project
try { $verifiedContext = (& openspec context --json 2>&1 | Out-String).Trim() }
finally { Pop-Location }
try { $verified = $verifiedContext | ConvertFrom-Json -ErrorAction Stop } catch { $verified = $null }
if (-not ($verified -and $verified.root -and $verified.root.path)) { throw 'OpenSpec initialization completed without a usable planning root.' }
Write-Result 'Initialized' 'Planning data was initialized with --tools none; no project skill directory was created.' $global $project $legacy
