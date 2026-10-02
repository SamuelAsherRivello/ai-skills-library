[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('push', 'pull', 'promote', 'demote')]
    [string] $Action,

    [Parameter(Mandatory)]
    [string] $Skill,
    [string] $LibraryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..')),
    [string] $GlobalSkillsDirectory = (Join-Path $HOME '.agents/skills'),
    [string] $ProjectDirectory = (Get-Location).Path,
    [switch] $ReplaceConflicts
)

$ErrorActionPreference = 'Stop'
$libraryRoot = [System.IO.Path]::GetFullPath($LibraryRoot)
$librarySkills = Join-Path $libraryRoot '.agents/skills'
$globalSkills = [System.IO.Path]::GetFullPath($GlobalSkillsDirectory)

function Resolve-ProjectSkills {
    if (-not [string]::IsNullOrWhiteSpace($ProjectDirectory)) {
        $current = [System.IO.DirectoryInfo]::new([System.IO.Path]::GetFullPath($ProjectDirectory))
    }
    else {
        $current = [System.IO.DirectoryInfo]::new((Get-Location).Path)
    }
    while ($null -ne $current) {
        $candidate = Join-Path $current.FullName '.agents/skills'
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            return [System.IO.Path]::GetFullPath($candidate)
        }
        $current = $current.Parent
    }
    throw 'Could not find a project .agents/skills directory above the current directory.'
}

function Test-SafeSkillName([string] $Name) {
    return $Name -match '^[A-Za-z0-9][A-Za-z0-9._-]*$' -and $Name -notin @('.', '..')
}

function Test-PhysicalSkill([string] $Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) { return $false }
    $root = Get-Item -LiteralPath $Path -Force
    if (($root.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { return $false }
    $definition = Join-Path $Path 'SKILL.md'
    if (-not (Test-Path -LiteralPath $definition -PathType Leaf)) { return $false }
    foreach ($entry in Get-ChildItem -LiteralPath $Path -Force -Recurse) {
        if (($entry.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { return $false }
    }
    return $true
}

function Get-TreeDigest([string] $Path) {
    $records = [System.Collections.Generic.List[string]]::new()
    foreach ($directory in Get-ChildItem -LiteralPath $Path -Directory -Force -Recurse | Sort-Object { $_.FullName.Substring($Path.Length).ToLowerInvariant() }) {
        $relative = $directory.FullName.Substring($Path.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar).Replace('\', '/')
        $records.Add("D`0$relative")
    }
    foreach ($file in Get-ChildItem -LiteralPath $Path -File -Force -Recurse | Sort-Object { $_.FullName.Substring($Path.Length).ToLowerInvariant() }) {
        $relative = $file.FullName.Substring($Path.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar).Replace('\', '/')
        $hash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
        $records.Add("F`0$relative`0$($file.Length)`0$hash")
    }
    $text = [string]::Join("`n", $records)
    $bytes = [Text.Encoding]::UTF8.GetBytes($text)
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-', '') }
    finally { $sha.Dispose() }
}

function Test-DirectoryWritable([string] $Path) {
    $probe = Join-Path $Path ('.skill-copy-probe-' + [Guid]::NewGuid().ToString('N'))
    try {
        $stream = [IO.File]::Open($probe, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
        $stream.Dispose()
        Remove-Item -LiteralPath $probe -Force
        return $true
    }
    catch {
        if (Test-Path -LiteralPath $probe) { Remove-Item -LiteralPath $probe -Force -ErrorAction SilentlyContinue }
        return $false
    }
}

function Write-Outcome([string] $Label, [System.Collections.Generic.List[string]] $Items) {
    if ($Items.Count -gt 0) { Write-Output ($Label + ': ' + ($Items -join ', ')) }
    else { Write-Output ($Label + ': (none)') }
}

function Stop-Preflight([string] $Message, [int] $ExitCode = 2) {
    Write-Output 'Changed: (none)'
    Write-Output 'Skipped: (none)'
    Write-Output ('Failed: ' + $Message)
    exit $ExitCode
}

if (-not (Test-SafeSkillName $Skill)) {
    Stop-Preflight "Invalid skill selection '$Skill'. Use one skill folder name or the literal 'all' for push/pull."
}
if ($Skill -eq 'all' -and $Action -notin @('push', 'pull')) {
    Stop-Preflight "The $Action command accepts exactly one skill name; 'all' is supported only by push and pull."
}

switch ($Action) {
    'push'    { $sourceRoot = $globalSkills; $destinationRoot = $librarySkills }
    'pull'    { $sourceRoot = $librarySkills; $destinationRoot = $globalSkills }
    'promote' { $sourceRoot = Resolve-ProjectSkills; $destinationRoot = $globalSkills }
    'demote'  { $sourceRoot = $globalSkills; $destinationRoot = Resolve-ProjectSkills }
}

$changed = [System.Collections.Generic.List[string]]::new()
$skipped = [System.Collections.Generic.List[string]]::new()
$failed = [System.Collections.Generic.List[string]]::new()
$plan = [System.Collections.Generic.List[object]]::new()

if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
    Stop-Preflight "Source skills directory does not exist: $sourceRoot"
}
if (-not (Test-Path -LiteralPath $destinationRoot -PathType Container) -and $Action -eq 'push') {
        Stop-Preflight "The library checkout is not writable or its skills directory is missing: $destinationRoot. Ask a library maintainer to import the skill, or use promote to copy it only to global skills. No skills were changed."
}

if ($Skill -eq 'all') {
    $selections = @(Get-ChildItem -LiteralPath $sourceRoot -Directory -Force | Sort-Object Name)
    if ($selections.Count -eq 0) { Stop-Preflight "No skill directories found in $sourceRoot" }
}
else {
    $selections = @([pscustomobject]@{ Name = $Skill; FullName = (Join-Path $sourceRoot $Skill) })
}

foreach ($selection in $selections) {
    $name = $selection.Name
    $source = Join-Path $sourceRoot $name
    $destination = Join-Path $destinationRoot $name
    if (-not (Test-PhysicalSkill $source)) {
        $failed.Add("$name (missing or invalid source skill)")
        continue
    }
    if (Test-Path -LiteralPath $destination) {
        if (-not (Test-PhysicalSkill $destination)) {
            $failed.Add("$name (destination is not a valid physical skill directory)")
            continue
        }
        if ((Get-TreeDigest $source) -ceq (Get-TreeDigest $destination)) {
            $skipped.Add($name)
            continue
        }
        if (-not $ReplaceConflicts) {
            $failed.Add("$name (destination conflict; ask the user for explicit replacement authorization, then rerun with -ReplaceConflicts)")
            continue
        }
        $plan.Add([pscustomobject]@{ Name = $name; Source = $source; Destination = $destination; Replace = $true })
        continue
    }
    $plan.Add([pscustomobject]@{ Name = $name; Source = $source; Destination = $destination; Replace = $false })
}

if ($Action -eq 'push' -and ($plan.Count -gt 0 -or $failed.Count -gt 0) -and -not (Test-DirectoryWritable $destinationRoot)) {
    $failed.Add("library checkout is not writable: $destinationRoot. Ask a library maintainer to import the skill, or use promote to copy it only to global skills")
}

if ($failed.Count -gt 0) {
    Write-Output 'Changed: (none; preflight failed)'
    Write-Outcome 'Skipped' $skipped
    Write-Output ('Failed: ' + ($failed -join '; '))
    exit 1
}

 $destinationRootCreated = $false
if ($plan.Count -gt 0 -and -not (Test-Path -LiteralPath $destinationRoot -PathType Container)) {
    try {
        New-Item -ItemType Directory -Path $destinationRoot -Force -ErrorAction Stop | Out-Null
        $destinationRootCreated = $true
    }
    catch { Stop-Preflight "Cannot create destination skills directory $destinationRoot. No skills were changed." }
}

$stagingRoot = Join-Path $destinationRoot ('.skill-copy-stage-' + [Guid]::NewGuid().ToString('N'))
$backupRoot = Join-Path $stagingRoot '.__replacement_backups'
$installed = [System.Collections.Generic.List[string]]::new()
$backedUp = [System.Collections.Generic.List[object]]::new()
$preserveStaging = $false
try {
    if ($plan.Count -gt 0) {
        New-Item -ItemType Directory -Path $stagingRoot -ErrorAction Stop | Out-Null
        foreach ($item in $plan) {
            $staged = Join-Path $stagingRoot $item.Name
            Copy-Item -LiteralPath $item.Source -Destination $staged -Recurse -Force:$false -ErrorAction Stop
            if (-not (Test-PhysicalSkill $staged) -or (Get-TreeDigest $item.Source) -cne (Get-TreeDigest $staged)) {
                throw "Staged copy verification failed for $($item.Name)."
            }
        }
        foreach ($item in $plan) {
            $staged = Join-Path $stagingRoot $item.Name
            if (Test-Path -LiteralPath $item.Destination) {
                if (-not $item.Replace) { throw "Destination appeared during copy: $($item.Destination)" }
                if (-not (Test-Path -LiteralPath $backupRoot)) { New-Item -ItemType Directory -Path $backupRoot | Out-Null }
                $backup = Join-Path $backupRoot $item.Name
                Move-Item -LiteralPath $item.Destination -Destination $backup -ErrorAction Stop
                $backedUp.Add([pscustomobject]@{ Original = $item.Destination; Backup = $backup })
            }
            Move-Item -LiteralPath $staged -Destination $item.Destination -ErrorAction Stop
            $installed.Add($item.Destination)
            $changed.Add($item.Name)
        }
    }
}
catch {
    $reason = $_.Exception.Message
    foreach ($path in $installed) {
        try { Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction Stop }
        catch { $reason += "; could not roll back ${path}: $($_.Exception.Message)"; $preserveStaging = $true }
    }
    foreach ($backup in $backedUp) {
        if (Test-Path -LiteralPath $backup.Backup) {
            try { Move-Item -LiteralPath $backup.Backup -Destination $backup.Original -ErrorAction Stop }
            catch { $reason += "; original destination preserved at $($backup.Backup); restore failed: $($_.Exception.Message)"; $preserveStaging = $true }
        }
    }
    $changed.Clear()
    foreach ($item in $plan) { $failed.Add("$($item.Name) ($reason)") }
}
finally {
    if (Test-Path -LiteralPath $stagingRoot) {
        if (-not $preserveStaging) { Remove-Item -LiteralPath $stagingRoot -Recurse -Force -ErrorAction SilentlyContinue }
        else { Write-Output "Recovery files retained at $stagingRoot" }
    }
    if ($destinationRootCreated -and -not $preserveStaging -and (Test-Path -LiteralPath $destinationRoot) -and -not (Get-ChildItem -LiteralPath $destinationRoot -Force | Select-Object -First 1)) {
        Remove-Item -LiteralPath $destinationRoot -Force -ErrorAction SilentlyContinue
    }
}

Write-Outcome 'Changed' $changed
Write-Outcome 'Skipped' $skipped
Write-Outcome 'Failed' $failed
if ($failed.Count -gt 0) { exit 1 }
