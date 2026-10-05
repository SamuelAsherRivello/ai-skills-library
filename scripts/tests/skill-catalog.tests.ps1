$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$skillsRoot = Join-Path $repoRoot '.agents\skills'
$categories = @('ai-skills-create', 'ai-skills-library', 'docker-sandbox', 'openspec')

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

$oldRelease = Join-Path $skillsRoot 'openspec\openspec-release-version\SKILL.md'
$newRelease = Join-Path $skillsRoot 'ai-skills-create\ai-skills-release-version\SKILL.md'
Assert (-not (Test-Path -LiteralPath $oldRelease -PathType Leaf)) 'Old OpenSpec release skill remains.'
Assert (Test-Path -LiteralPath $newRelease -PathType Leaf) 'Relocated release skill is missing.'
Assert ((Get-Content -LiteralPath $newRelease -Raw) -match '(?m)^name: ai-skills-release-version$') 'Relocated release skill has the wrong name.'

$disallowedName = 'po' + 'cock'
$disallowed = Get-ChildItem -LiteralPath $skillsRoot -Recurse -File |
    Where-Object { $_.Extension -in '.md', '.yaml' } |
    Select-String -Pattern $disallowedName -CaseSensitive:$false -List
Assert ($null -eq $disallowed) 'Catalog or skill content includes a prohibited external repository reference.'

Write-Output 'All skill catalog scenarios passed.'
