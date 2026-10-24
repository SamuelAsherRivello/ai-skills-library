---
name: ai-skills-openspec-title-management
description: Rebuild an active OpenSpec chat title with verified progress and its orchestration marker, or apply marker-only updates to explicitly enrolled chats on a coordinator's delegation.
---

# OpenSpec title management

This is the sole OpenSpec title writer. Rebuild only the invoking workflow's
current-chat title. The only cross-chat exception is a coordinator's scoped
marker-only delegation below; never rebuild another owner's phase or subject.
It does not implement, plan, archive, sync, commit, push, or change OpenSpec artifacts.

Read the shared [title contract](../openspec-title-management.md). The caller
supplies its active prefix, resolved subject, selected store/program context,
and coordinator identity/enrollment evidence where applicable. Never infer a
prefix, enrollment or authority from a pre-existing title or an asterisk alone.

## Orchestration membership and marker-only updates

Treat the leading `*` as a separate, first-class title field, adjacent to the name. A coordinator and
all enrolled chats use exactly one marker, including non-OpenSpec subtasks and
nested coordinators. Standalone titles remain unmarked. Resolve membership from
the current assignment and coordination ledger, carrying coordinator thread ID,
root coordinator ID, enrolled thread IDs and marker ownership across handoffs.
An existing marker with unavailable membership evidence is preserved without
claiming enrollment. Preserve asterisks inside the subject.

Codex normalizes Markdown titles repeatedly. A raw leading `* ` becomes a
list bullet and disappears. Escaped `\* ` survives one parse but disappears on
a later parse. Use exactly `*Name`, without whitespace after the asterisk, for
both the stored title and visible title. This form has been confirmed in the
sidebar. The formatter accepts legacy spaced/escaped markers and emits the
no-space form once. Never insert a space or backslash afterward. Set aside
any of these legacy spellings before subject parsing.

For marker-only delegation, require the invoking coordinator's current ledger
and an explicit list of current or explicitly detached thread IDs, membership
records and requested add/remove actions.
Read each current title, apply only the leading marker, and preserve its phase,
subject, spacing and progress exactly. Do not rebuild from an old ledger title.
This works for idle and non-OpenSpec owners without sending messages or starting
their workflows. Never touch a chat discovered only by project or title search.

Remove a marker only after explicit detachment/transfer is recorded, its marker
is recorded as orchestration-owned, and the chat has no remaining enrollment or
coordinator role. Transfer and nested membership retain one marker. Pause,
completion and archive retain the marker. Unknown ownership never permits removal.

Use [scripts/format-orchestration-marker.ps1](scripts/format-orchestration-marker.ps1)
with `-Title <current-title> -Action Add|Preserve|Remove` to format the marker.
The helper formats text only; verify enrollment and removal authority before
choosing an action. It never reads chats or grants permission to change them.

## When to reconcile

Read the current title at owner-state start and after verified subject, phase,
progress or membership changes. Reconcile before a meaningful owner response
when the user has edited the title since the last read. Do not write unchanged
titles or poll merely because time passed.

If title tools or current titles are unavailable, continue the caller's work
and report the narrow limitation when useful. Missing tracking omits the
progress suffix; it does not block marker updates or justify invented counts.

## Subject reconstruction for the current chat

Treat the current title as a user-provided replacement subject, not a permanent
opt-out. Before rendering, conservatively normalize it:

1. Set aside the leading orchestration marker before parsing the subject. Use
   the formatter's Remove action on this temporary string only; preserve the
   remembered marker state. This is not a live marker-removal authorization.
2. Remove every repeated OpenSpec prefix fragment matching `OS-<slug>:`.
3. Remove a terminal system-owned progress suffix of the form `(N/M)` before
   deriving the current suffix.
4. Trim and collapse whitespace, then collapse only exact adjacent repeated
   text, including a clearly repeated final word or phrase such as
   `coolcool` -> `cool`.
5. Preserve spelling, punctuation, capitalization, internal asterisks and all
   other wording. Do not correct a typo or guess a different topic.

If the input contains only markers, skip subject parsing and use the caller's
resolved subject before invoking the formatter. If no usable subject remains
after normalization, also use the caller's resolved subject. If both are
unavailable, leave the title unchanged and report why only when actionable.

Render `{active-prefix}: {normalized-subject}` with verified progress as below,
then apply the remembered/verified marker using the formatter. The displayed form is
`{marker}{active-prefix}: {normalized-subject} ({completed}/{total})`, where
`{marker}` is `*` for coordinators/enrolled chats or a preserved existing marker,
and empty otherwise. The marker touches the prefix with no intervening space.
The active caller's prefix always wins. Never stack prefixes
or move the asterisk into the subject when phases change.

## Verified progress and writes

For a change-backed owner, obtain current task progress from the selected
OpenSpec context and `openspec status --change "<change>" --json`, including
`--store <id>` when selected. For a program coordinator, use verified distinct
child-proposal counts from the current ledger and evidence. Use retained archived
counts only when trustworthy.

Append ` ({completed}/{total})` using unpadded integers when applicable and verified.
Replace the old system suffix after verified progress changes. Otherwise omit
it; never render `0/0` or count interview questions or planned artifacts as tasks.

Read immediately before a write, render once, skip an unchanged result, and
verify the result. If a concurrent user edit changes the title, use the newer
title and reconcile once. Do not retry blindly or overwrite it from stale state.

## Verify storage and display separately

A matching title-write response and subsequent list/read confirm persistence,
not the sidebar's rendered text. Check an available supported UI snapshot or a
user-supplied screenshot before claiming visual success. If unavailable, say the
stored update is verified and visible confirmation is still pending.

A screenshot with a missing marker overrides an earlier visual-success claim.
Check Markdown normalization and the exact chat first, without re-enrolling unrelated
chats. Try one supported repair with the formatter, then stop rewriting unchanged
titles. Do not edit app databases/configuration or force a restart as a shortcut.
