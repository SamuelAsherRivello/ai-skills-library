[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Title,

    [Parameter(Mandatory)]
    [ValidateSet('Add', 'Preserve', 'Remove')]
    [string] $Action
)

# Formatting only. The caller verifies membership and live removal authority.
$leadingMarkers = '^(?:\s*\\?\*)+\s*'
$hasMarker = $Title -match $leadingMarkers
if ($Action -eq 'Preserve' -and -not $hasMarker) { return $Title }
$subject = [regex]::Replace($Title, $leadingMarkers, '')
if ([string]::IsNullOrWhiteSpace($subject)) { throw 'A marker needs a nonempty title.' }
if ($Action -eq 'Remove') { return $subject }
# Codex normalizes Markdown titles repeatedly. A star followed by space is a bullet.
# Keep the literal star adjacent to the name; escaping alone does not survive re-parsing.
return '*' + $subject
