# Spec Delta

## Purpose

Keeps locally adapted OpenSpec skills current with upstream releases while
preserving independent edits and making conflicting edits visible for review.

## ADDED Requirements

### Requirement: OpenSpec refresh merges each skill from its recorded baseline
The updater SHALL use each skill's previously recorded upstream revision as
the merge base when combining current local OpenSpec skills with a newer
upstream release.

#### Scenario: Local and upstream changes do not overlap
- **WHEN** both the local skill and the new upstream version differ from the
  previous upstream baseline in separate content regions
- **THEN** the refreshed skill contains both the local adaptation and the new
  upstream change

#### Scenario: Only the local skill changed
- **WHEN** the local skill contains edits absent from the previous upstream
  baseline and the new upstream version leaves that content unchanged
- **THEN** the refreshed skill preserves those local edits

### Requirement: OpenSpec refresh advances clean skills and holds conflicts
The updater SHALL report overlapping edits that cannot be merged
automatically, leave each conflicted skill and its baseline unchanged, and
advance the content and baseline only for skills that merge cleanly.

#### Scenario: One skill has conflicting local and upstream edits
- **WHEN** local and new upstream edits overlap and cannot be merged
- **THEN** the updater reports the affected skill and conflict for review and
  leaves that skill's active file and recorded baseline unchanged

#### Scenario: Other skills merge cleanly during a conflict
- **WHEN** one OpenSpec skill conflicts but other existing upstream-owned
  skills merge without conflict
- **THEN** the clean skills and their baselines advance while the conflicted
  skill remains available for a later retry

### Requirement: OpenSpec refresh targets only categorized OpenSpec skills
The updater SHALL refresh existing upstream-owned skills within the
`openspec` category, preserve local edits and custom skills in that category,
and leave skills in other categories unchanged.

#### Scenario: Refresh discovers categorized OpenSpec skills
- **WHEN** a new stable OpenSpec release is available
- **THEN** the updater considers existing upstream-owned skills under the
  `openspec` category and does not create new skill directories or modify
  skills in other categories
