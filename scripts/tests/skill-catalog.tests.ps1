$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$skillsRoot = Join-Path $repoRoot '.agents\skills'
$categories = @('ai-skills-create', 'ai-skills-library', 'docker-sandbox', 'ai-skills-openspec', 'ai-skills-triage', 'ai-skills-productivity', 'slidev')

function Assert([bool] $Condition, [string] $Message) {
    if (-not $Condition) { throw $Message }
}

function Get-LinkedSkills([string] $CatalogPath) {
    $content = Get-Content -LiteralPath $CatalogPath -Raw
    return @([regex]::Matches($content, '\]\(\./(?<skill>[a-z0-9][a-z0-9-]*)/SKILL\.md\)') |
        ForEach-Object { $_.Groups['skill'].Value })
}

foreach ($category in $categories) {
    $categoryPath = Join-Path $skillsRoot $category
    $catalogPath = Join-Path $categoryPath 'README.md'
    Assert (Test-Path -LiteralPath $catalogPath -PathType Leaf) "Missing catalog: $catalogPath"

    $expected = @(Get-ChildItem -LiteralPath $categoryPath -Directory -Force |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') } |
        ForEach-Object Name | Sort-Object)
    $linked = @(Get-LinkedSkills $catalogPath | Sort-Object)
    Assert ($linked.Count -eq ($linked | Select-Object -Unique).Count) "Catalog repeats a skill: $category"
    Assert (($expected -join "`n") -ceq ($linked -join "`n")) "Catalog does not match its skill directories: $category"
}

$rootCatalog = Join-Path $skillsRoot 'README.md'
$rootContent = Get-Content -LiteralPath $rootCatalog -Raw
foreach ($category in $categories) {
    Assert ($rootContent.Contains("./$category/README.md")) "Root catalog does not link category: $category"
}

$oldRelease = Join-Path $skillsRoot 'ai-skills-openspec\openspec-release-version\SKILL.md'
$newRelease = Join-Path $skillsRoot 'ai-skills-create\ai-skills-create-github-release\SKILL.md'
Assert (-not (Test-Path -LiteralPath $oldRelease -PathType Leaf)) 'Old OpenSpec release skill remains.'
Assert (Test-Path -LiteralPath $newRelease -PathType Leaf) 'Relocated release skill is missing.'
Assert ((Get-Content -LiteralPath $newRelease -Raw) -match '(?m)^name: ai-skills-create-github-release\r?$') 'Relocated release skill has the wrong name.'

$disallowedName = 'po' + 'cock'
$disallowed = Get-ChildItem -LiteralPath $skillsRoot -Recurse -File |
    Where-Object { $_.Extension -in '.md', '.yaml' } |
    Select-String -Pattern $disallowedName -CaseSensitive:$false -List
Assert ($null -eq $disallowed) 'Catalog or skill content includes a prohibited external repository reference.'

$openSpecRoot = Join-Path $skillsRoot 'ai-skills-openspec'
$titleContract = Join-Path $openSpecRoot 'openspec-title-management.md'
$footer = Join-Path $openSpecRoot 'openspec-footer.md'
Assert (Test-Path -LiteralPath $titleContract -PathType Leaf) 'OpenSpec title contract is missing.'
Assert ((Get-Content -LiteralPath $footer -Raw).Contains('Coordination: Standalone')) 'OpenSpec footer lacks standalone coordination context.'

$titleSlots = @{
    'openspec-dashboard' = 'OS-DSH'
    'openspec-init' = 'OS-INI'
    'openspec-explore' = 'OS-EXP'
    'openspec-grill-me' = 'OS-GRL'
    'openspec-propose' = 'OS-PRP'
    'openspec-update-change' = 'OS-REV'
    'openspec-apply-change' = 'OS-APP'
    'openspec-sync-specs' = 'OS-SYN'
    'openspec-archive-change' = 'OS-ARC'
    'openspec-commit-inclusive' = 'OS-CMT'
    'openspec-orchestrate-proposal' = 'OS-ORC'
    'openspec-orchestrate-program' = 'OS-ORP'
}
foreach ($entry in $titleSlots.GetEnumerator()) {
    $content = Get-Content -LiteralPath (Join-Path (Join-Path $openSpecRoot $entry.Key) 'SKILL.md') -Raw
    Assert ($content.Contains('../openspec-title-management.md')) "OpenSpec skill lacks title contract: $($entry.Key)"
    Assert ($content.Contains("owns ``$($entry.Value)``")) "OpenSpec skill has the wrong title slot: $($entry.Key)"
}

foreach ($wrapper in @('openspec-apply-change-with-playwright', 'openspec-apply-program', 'openspec-create-program', 'openspec-macro-finalize-sync-archive-commit-push')) {
    $content = Get-Content -LiteralPath (Join-Path (Join-Path $openSpecRoot $wrapper) 'SKILL.md') -Raw
    Assert ($content.Contains('../openspec-title-management.md')) "OpenSpec wrapper lacks title contract: $wrapper"
    Assert ($content.Contains('## Delegated workflow presentation')) "OpenSpec wrapper owns presentation unexpectedly: $wrapper"
}

$orchestrationConfig = Get-Content -LiteralPath (Join-Path $openSpecRoot 'openspec-orchestrate-proposal\references\openspec-orchestrate-proposal-config.md') -Raw
Assert ($orchestrationConfig.Contains('OS-ORC: {change}')) 'Proposal coordinator title format is missing.'
Assert (-not $orchestrationConfig.Contains('OS-orc:')) 'Retired lower-case proposal coordinator title remains.'

foreach ($skillName in @('ai-skills-library-push', 'ai-skills-library-pull', 'ai-skills-library-move-global', 'ai-skills-library-move-project')) {
    $content = Get-Content -LiteralPath (Join-Path (Join-Path $skillsRoot 'ai-skills-library') "$skillName\SKILL.md") -Raw
    Assert ($content.Contains('clearly better')) "Lifecycle skill lacks quality conflict guidance: $skillName"
}

Write-Output 'All skill catalog scenarios passed.'
