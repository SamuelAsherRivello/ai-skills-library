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
foreach ($required in @('sole OpenSpec title writer', 'OS-<slug>:', 'coolcool', '({completed}/{total})', 'marker-only delegation')) {
    Assert ($manager.Contains($required)) "Title manager lacks required behavior: $required"
}

foreach ($entry in $owners.GetEnumerator()) {
    $content = Get-Content -LiteralPath (Join-Path (Join-Path $openSpecRoot $entry.Key) 'SKILL.md') -Raw
    Assert ($content.Contains('`$ai-skills-openspec-title-management`')) "Title owner does not delegate: $($entry.Key)"
    Assert ($content.Contains($entry.Value)) "Title owner has wrong prefix: $($entry.Key)"
    Assert ($content.Contains('leading `*` orchestration marker')) "Title owner drops orchestration context: $($entry.Key)"
    Assert (-not $content.Contains('preserve human overrides')) "Retired permanent override behavior remains: $($entry.Key)"
}

foreach ($wrapper in @('ai-skills-openspec-apply-change-with-playwright', 'ai-skills-openspec-apply-program', 'ai-skills-openspec-create-program', 'ai-skills-openspec-macro-finalize-sync-archive-commit-push')) {
    $content = Get-Content -LiteralPath (Join-Path (Join-Path $openSpecRoot $wrapper) 'SKILL.md') -Raw
    Assert ($content.Contains('leading `*` orchestration marker')) "Wrapper drops orchestration context: $wrapper"
    Assert ($content.Contains('active child invokes `$ai-skills-openspec-title-management`')) "Wrapper does not leave title management to its child: $wrapper"
}

$contract = Get-Content -LiteralPath (Join-Path $openSpecRoot 'openspec-title-management.md') -Raw
Assert ($contract.Contains('each owner invokes `$ai-skills-openspec-title-management`')) 'Title contract does not centralize owner invocation.'
Assert ($contract.Contains('wrappers and macros do not invoke it')) 'Title contract allows wrapper double-renames.'

# Exercise the actual formatter used by the title manager without mutating chats.
$formatter = Join-Path $openSpecRoot 'ai-skills-openspec-title-management\scripts\format-orchestration-marker.ps1'
$cases = @(
    @('OS-ORC: add-auth (3/7)', 'Add', '*OS-ORC: add-auth (3/7)'),
    @('OS-APP: add-auth (2/4)', 'Add', '*OS-APP: add-auth (2/4)'),
    @('OS-ORP: program (0/5)', 'Add', '*OS-ORP: program (0/5)'),
    @('Investigate browser support', 'Add', '*Investigate browser support'),
    @('* OS-APP: add-auth (2/4)', 'Add', '*OS-APP: add-auth (2/4)'),
    @('** * OS-APP: add-auth (2/4)', 'Add', '*OS-APP: add-auth (2/4)'),
    @('* OS-GRL: renamed subject', 'Preserve', '*OS-GRL: renamed subject'),
    @('* OS-ARC: add-auth (4/4)', 'Preserve', '*OS-ARC: add-auth (4/4)'),
    @('* OS-CMT: add-auth (4/4)', 'Preserve', '*OS-CMT: add-auth (4/4)'),
    @('OS-EXP: standalone', 'Preserve', 'OS-EXP: standalone'),
    @('A* search', 'Add', '*A* search'),
    @('* A* search', 'Remove', 'A* search'),
    @('OS-APP: standalone', 'Remove', 'OS-APP: standalone'),
    @('* OS-APP:  Keep MY wording! (2/4)', 'Preserve', '*OS-APP:  Keep MY wording! (2/4)'),
    @('  ordinary  title  ', 'Preserve', '  ordinary  title  '),
    @('\* OS-APP: escaped (2/4)', 'Add', '*OS-APP: escaped (2/4)'),
    @('\* OS-APP: escaped (2/4)', 'Preserve', '*OS-APP: escaped (2/4)'),
    @('\* OS-APP: escaped (2/4)', 'Remove', 'OS-APP: escaped (2/4)'),
    @('* \* ** OS-APP: mixed (2/4)', 'Add', '*OS-APP: mixed (2/4)'),
    @('\* A* search', 'Remove', 'A* search')
)
foreach ($case in $cases) {
    $actual = & $formatter -Title $case[0] -Action $case[1]
    Assert ($actual -ceq $case[2]) "Marker scenario failed: $($case[0]) / $($case[1]) => $actual"
    if ($case[1] -ne 'Remove') {
        Assert ((& $formatter -Title $actual -Action $case[1]) -ceq $actual) 'Marker formatting is not idempotent.'
    }
}
foreach ($prefix in $owners.Values) {
    $title = "${prefix}: subject with A* (1/3)"
    Assert ((& $formatter -Title $title -Action Add) -ceq "*$title") "Marker breaks phase $prefix."
}
$rejected = $false
try { & $formatter -Title '** * ' -Action Add | Out-Null } catch { $rejected = $true }
Assert $rejected 'Formatter accepted an empty marked title.'

Assert ($contract.Contains('Never infer enrollment or authority from `*`')) 'Marker is treated as enrollment authority.'
Assert ($contract.Contains('Pause, completion and archive retain the marker')) 'Completion drops membership markers.'
Assert ($contract -match 'explicit\s+detachment or transfer') 'Marker removal has no membership lifecycle.'
Assert ($manager.Contains('preserve its phase,')) 'Marker-only updates may rewrite child fields.'
Write-Output "OpenSpec title-management scenarios passed, including $($cases.Count) marker cases and $($owners.Count) workflow phases."
