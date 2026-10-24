$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$openSpecRoot = Join-Path $repoRoot '.agents\skills\ai-skills-openspec'

function Assert([bool] $Condition, [string] $Message) {
    if (-not $Condition) { throw $Message }
}

$owners = [ordered]@{
    'ai-skills-openspec-dashboard' = 'OS-DSH'
    'ai-skills-openspec-init' = 'OS-INI'
    'ai-skills-openspec-audit' = 'OS-AUD'
    'ai-skills-openspec-explore' = 'OS-EXP'
    'ai-skills-openspec-grill-me' = 'OS-GRL'
    'ai-skills-openspec-propose' = 'OS-PRP'
    'ai-skills-openspec-update-change' = 'OS-REV'
    'ai-skills-openspec-apply-change' = 'OS-APP'
    'ai-skills-openspec-sync-specs' = 'OS-SYN'
    'ai-skills-openspec-archive-change' = 'OS-ARC'
    'ai-skills-openspec-commit-inclusive' = 'OS-CMT'
    'ai-skills-openspec-orchestrate-proposal' = 'OS-ORC'
    'ai-skills-openspec-orchestrate-program' = 'OS-ORP'
}

$manager = Get-Content -LiteralPath (Join-Path $openSpecRoot 'ai-skills-openspec-title-management\SKILL.md') -Raw
foreach ($required in @('sole OpenSpec title writer', 'OS-<slug>:', 'coolcool', '({completed}/{total})', 'never renames a child')) {
    Assert ($manager.Contains($required)) "Title manager lacks required behavior: $required"
}

foreach ($entry in $owners.GetEnumerator()) {
    $content = Get-Content -LiteralPath (Join-Path (Join-Path $openSpecRoot $entry.Key) 'SKILL.md') -Raw
    Assert ($content.Contains('`$ai-skills-openspec-title-management`')) "Title owner does not delegate: $($entry.Key)"
    Assert ($content.Contains($entry.Value)) "Title owner has wrong prefix: $($entry.Key)"
    Assert (-not $content.Contains('preserve human overrides')) "Retired permanent override behavior remains: $($entry.Key)"
}

foreach ($wrapper in @('ai-skills-openspec-apply-change-with-playwright', 'ai-skills-openspec-apply-program', 'ai-skills-openspec-create-program', 'ai-skills-openspec-macro-finalize-sync-archive-commit-push')) {
    $content = Get-Content -LiteralPath (Join-Path (Join-Path $openSpecRoot $wrapper) 'SKILL.md') -Raw
    Assert ($content.Contains('active child invokes `$ai-skills-openspec-title-management`')) "Wrapper does not leave title management to its child: $wrapper"
}

$contract = Get-Content -LiteralPath (Join-Path $openSpecRoot 'openspec-title-management.md') -Raw
Assert ($contract.Contains('each owner invokes `$ai-skills-openspec-title-management`')) 'Title contract does not centralize owner invocation.'
Assert ($contract.Contains('wrappers and macros do not invoke it')) 'Title contract allows wrapper double-renames.'

Write-Output 'OpenSpec title-management scenarios passed.'
