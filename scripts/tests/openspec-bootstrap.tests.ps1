$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$bootstrap = Join-Path $repoRoot '.agents\skills\ai-skills-openspec\ai-skills-openspec-init\scripts\bootstrap.ps1'
$sourceRoot = Join-Path $repoRoot '.agents\skills\ai-skills-openspec'
$tempRoot = Join-Path ([IO.Path]::GetTempPath()) ('openspec-bootstrap-' + [Guid]::NewGuid().ToString('N'))

function Assert([bool] $Condition, [string] $Message) {
    if (-not $Condition) { throw $Message }
}

function Copy-Suite([string] $Destination) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    Get-ChildItem -LiteralPath $sourceRoot -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md')
    } | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $Destination $_.Name) -Recurse
    }
}

function Invoke-Bootstrap([string] $Project, [string] $Global, [string] $Legacy, [switch] $Initialize) {
    $previousErrorPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $arguments = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $bootstrap,
            '-ProjectDirectory', $Project, '-GlobalSkillsDirectory', $Global,
            '-LegacyGlobalSkillsDirectory', $Legacy)
        if ($Initialize) { $arguments += '-Initialize' }
        $output = @(& powershell @arguments 2>&1)
    }
    finally {
        $ErrorActionPreference = $previousErrorPreference
    }
    $text = $output | Out-String
    $match = [regex]::Match($text, '(?s)(\{.*\})\s*$')
    if (-not $match.Success) { throw "Bootstrap returned no JSON: $text" }
    return ($match.Groups[1].Value | ConvertFrom-Json)
}

try {
    $project = Join-Path $tempRoot 'project'
    $global = Join-Path $tempRoot 'global'
    $legacy = Join-Path $tempRoot 'legacy'
    New-Item -ItemType Directory -Path $project, $global, $legacy -Force | Out-Null

    $result = Invoke-Bootstrap $project $global $legacy
    Assert ($result.state -eq 'GlobalSuiteIncomplete') "Expected incomplete global suite, got $($result.state)."

    Copy-Suite $global
    $result = Invoke-Bootstrap $project $global $legacy
    Assert ($result.state -eq 'ReadyToInitialize') "Expected ready bootstrap, got $($result.state)."
    $result = Invoke-Bootstrap $project $global $legacy -Initialize
    Assert ($result.state -eq 'Initialized') "Expected initialized bootstrap, got $($result.state)."
    Assert (Test-Path -LiteralPath (Join-Path $project 'openspec') -PathType Container) 'Bootstrap did not create planning data.'
    Assert (-not (Test-Path -LiteralPath (Join-Path $project '.agents\skills'))) 'Bootstrap created project-local skills.'

    $duplicateProject = Join-Path $tempRoot 'duplicate-project'
    $duplicateLocal = Join-Path $duplicateProject '.agents\skills'
    Copy-Suite $duplicateLocal
    $result = Invoke-Bootstrap $duplicateProject $global $legacy
    Assert ($result.state -eq 'ProjectGlobalDuplicate') "Expected project/global duplicate, got $($result.state)."

    $forkProject = Join-Path $tempRoot 'fork-project'
    $forkLocal = Join-Path $forkProject '.agents\skills'
    Copy-Suite $forkLocal
    Add-Content -LiteralPath (Join-Path $forkLocal 'ai-skills-openspec-propose\SKILL.md') -Value "`n<!-- private fork -->"
    $result = Invoke-Bootstrap $forkProject $global $legacy
    Assert ($result.state -eq 'ProjectPrivateFork') "Expected project private fork, got $($result.state)."

    $partialProject = Join-Path $tempRoot 'partial-project'
    $partialLocal = Join-Path $partialProject '.agents\skills'
    New-Item -ItemType Directory -Path $partialLocal -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $sourceRoot 'ai-skills-openspec-propose') -Destination (Join-Path $partialLocal 'ai-skills-openspec-propose') -Recurse
    $result = Invoke-Bootstrap $partialProject $global $legacy
    Assert ($result.state -eq 'ProjectLocalPartial') "Expected partial local suite, got $($result.state)."

    $legacyProject = Join-Path $tempRoot 'legacy-project'
    New-Item -ItemType Directory -Path $legacyProject -Force | Out-Null
    Copy-Suite $legacy
    $result = Invoke-Bootstrap $legacyProject $global $legacy
    Assert ($result.state -eq 'LegacyGlobalDuplicate') "Expected legacy duplicate, got $($result.state)."

    Write-Output 'OpenSpec bootstrap scenarios passed.'
}
finally {
    if (Test-Path -LiteralPath $tempRoot) { Remove-Item -LiteralPath $tempRoot -Recurse -Force }
}
