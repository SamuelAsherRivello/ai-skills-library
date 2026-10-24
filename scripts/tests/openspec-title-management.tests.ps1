$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$openSpecRoot = Join-Path $repoRoot '.agents\skills\ai-skills-openspec'

function Assert([bool] $Condition, [string] $Message) {
    if (-not $Condition) { throw $Message }
}

$owners = [ordered]@{
    'openspec-dashboard' = 'OS-DSH'
    'openspec-init' = 'OS-INI'
    'openspec-audit' = 'OS-AUD'
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

$manager = Get-Content -LiteralPath (Join-Path $openSpecRoot 'openspec-title-management\SKILL.md') -Raw
foreach ($required in @('sole OpenSpec title writer', 'OS-<slug>:', 'coolcool', '({completed}/{total})', 'never renames a child')) {
    Assert ($manager.Contains($required)) "Title manager lacks required behavior: $required"
}

foreach ($entry in $owners.GetEnumerator()) {
    $content = Get-Content -LiteralPath (Join-Path (Join-Path $openSpecRoot $entry.Key) 'SKILL.md') -Raw
    Assert ($content.Contains('`$openspec-title-management`')) "Title owner does not delegate: $($entry.Key)"
    Assert ($content.Contains($entry.Value)) "Title owner has wrong prefix: $($entry.Key)"
    Assert (-not $content.Contains('preserve human overrides')) "Retired permanent override behavior remains: $($entry.Key)"
}

foreach ($wrapper in @('openspec-apply-change-with-playwright', 'openspec-apply-program', 'openspec-create-program', 'openspec-macro-finalize-sync-archive-commit-push')) {
    $content = Get-Content -LiteralPath (Join-Path (Join-Path $openSpecRoot $wrapper) 'SKILL.md') -Raw
    Assert ($content.Contains('active child invokes `$openspec-title-management`')) "Wrapper does not leave title management to its child: $wrapper"
}

$contract = Get-Content -LiteralPath (Join-Path $openSpecRoot 'openspec-title-management.md') -Raw
Assert ($contract.Contains('each owner invokes `$openspec-title-management`')) 'Title contract does not centralize owner invocation.'
Assert ($contract.Contains('wrappers and macros do not invoke it')) 'Title contract allows wrapper double-renames.'

Write-Output 'OpenSpec title-management scenarios passed.'
