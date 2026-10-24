# OpenSpec chat title contract

This contract applies during workflow execution, not when editing, evaluating,
or discussing a skill. Each active state owner delegates its current-chat title
to `$ai-skills-openspec-title-management`; it does not write titles directly. Read the
shared [footer contract](openspec-footer.md) for response checkpoints.

## State owners

| Workflow | Prefix | Subject | Progress unit |
| --- | --- | --- | --- |
| ai-skills-openspec-dashboard | OS-DSH | selected change, otherwise project | tasks when a change is selected |
| ai-skills-openspec-init | OS-INI | project | no task count before a change exists |
| ai-skills-openspec-audit | OS-AUD | selected change, otherwise project | tasks when a change is selected |
| ai-skills-openspec-explore | OS-EXP | topic or change | tasks only for an existing change |
| ai-skills-openspec-grill-me | OS-GRL | plan or change | tasks only for an existing change |
| ai-skills-openspec-propose | OS-PRP | change | tasks once tracking exists |
| ai-skills-openspec-update-change | OS-REV | change | tasks when tracking exists |
| ai-skills-openspec-apply-change | OS-APP | change | tasks |
| ai-skills-openspec-sync-specs | OS-SYN | change | tasks when tracking exists |
| ai-skills-openspec-archive-change | OS-ARC | change | retained tasks when available |
| ai-skills-openspec-commit-inclusive | OS-CMT | archived change | retained tasks when available |
| ai-skills-openspec-orchestrate-proposal | OS-ORC | change | tasks |
| ai-skills-openspec-orchestrate-program | OS-ORP | program ID | proposals |

At state start and whenever its verified subject, phase, or progress changes,
each owner invokes `$ai-skills-openspec-title-management` with its own prefix and the
resolved change, topic, project, or program context. The manager reads the
current title, retains a normalized user-edited subject, restores the active
owner's prefix, and renders any verified applicable progress. Owners do not
write thread titles themselves.

Use `{marker}{prefix}: {subject} ({completed}/{total})` with unpadded integers, for
example `OS-APP: add-auth (3/7)` or `*OS-ORP: site-expansion (0/5)`.
When no trustworthy count exists, omit the whole suffix. Missing or unavailable
tracking is not zero tasks. Interview question counts and planned artifacts
are not implementation task counts.

Use current CLI task progress for a change, or verified retained tracking for
an archive. Program totals include every distinct required child in current
scope, including research, blocked and not-yet-created children; exclude
superseded, cancelled and optional unenrolled children. Count a child complete
only after current CLI `all_done` and coordinator acceptance of its evidence.
Reconcile totals after scope changes, reopenings and resume. Never equate a
complete proposal count with passing the program's integrated gates.

## Shared orchestration marker

The literal leading `*` is a first-class orchestration marker, separate from
both the workflow prefix and the user subject. Use exactly one asterisk with
no following space for a coordinator and every chat enrolled under it, including
research, non-OpenSpec subtasks, paused owners and nested coordinators.
Examples: `*OS-ORC: add-auth (3/7)`, `*OS-APP: add-auth (2/4)`,
`*OS-ORP: site-expansion (0/5)`, and `*Investigate browser support`.
Use the same no-space form for storage and display, for example `*OS-ORC:`
and `*DreamHost email follow-up`. Codex normalizes Markdown titles repeatedly.
A raw `* ` becomes a list bullet, and `\* ` only survives the first parse before
becoming that same bullet on the next. Neither is a stable visible marker.
The formatter accepts legacy spaced/escaped markers and always emits one
literal `*` directly adjacent to the name. Never add a space after it.

Standalone chats receive no marker. A marker identifies orchestration
participation, not a unique orchestrator; use the ledger to distinguish groups.

Record the coordinator thread ID, root coordinator ID for nested orchestration,
exact enrolled thread IDs, marker ownership and observed titles in the existing
coordination ledger. Pass this identity and enrollment context in assignments,
workflow handoffs and resumes. Never infer enrollment or authority from `*`
alone, a shared project, a title match, or a historical ledger entry.

Keep the marker before every `OS-...:` prefix through user subject edits,
phase/progress changes, interviews, wrappers and finalization. Normalize repeated
leading markers to one; preserve asterisks inside the subject. If the title is
already marked but membership cannot be checked, preserve the marker without
claiming enrollment or enrolling other chats. Verified membership restores a
missing marker. Unknown progress does not prevent marker reconciliation.

The title manager remains the sole title writer. A coordinator may delegate a
marker-only update for an explicit set of verified enrolled chat IDs, including
idle owners. This narrow exception changes only the leading marker, preserving
the rest of each title exactly. Child owners still own their phase, subject and
progress. Do not perform a project-wide naming pass or guess another owner's
prefix/count. New enrolled chats may receive a marked temporary creation title.

Pause, completion and archive retain the marker for continuity. On explicit
detachment or transfer, reconcile the ledger first. Remove only a marker recorded
as orchestration-owned when no coordinator role or other enrollment remains;
transferred and nested owners retain one marker. Do not restore an old title or
strip an unowned asterisk. Reconcile at enrollment, resume and meaningful
membership changes, never by repeatedly writing an unchanged title.

## Wrappers and macros

These workflows do not own a prefix, progress suffix or footer:

- ai-skills-openspec-apply-change-with-playwright delegates to ai-skills-openspec-apply-change.
- ai-skills-openspec-apply-program delegates to ai-skills-openspec-orchestrate-program.
- ai-skills-openspec-create-program delegates presentation to its active
  ai-skills-openspec-propose child when creating proposals.
- ai-skills-openspec-macro-finalize-sync-archive-commit-push delegates successively to
  ai-skills-openspec-sync-specs, ai-skills-openspec-archive-change and ai-skills-openspec-commit-inclusive.

Leave the last active child's title in place. The active child invokes
`$ai-skills-openspec-title-management`; wrappers and macros do not invoke it, restore a
macro title between calls, add a wrapper prefix, or emit an extra macro footer. A blocker
before any child is selected gets a plain explanation, not fabricated child
progress. An owning child may report required wrapper verification in its
checkpoint. It must not claim completion before that verification passes.

A program coordinator is a distinct owner, not a presentation-only macro:
it invokes `$ai-skills-openspec-title-management` with OS-ORP in its chat, while children
own their titles in their own chats.
An inline interview temporarily owns OS-GRL; returning to a real parent phase
is one ownership handoff, not permission for competing title updates.

## Visible result verification

Distinguish persisted title verification from visible sidebar verification.
A successful title-write response or matching list/read result verifies stored
text only. Inspect an available supported UI snapshot or user-supplied screenshot
before claiming the marker is visible. If rendering is unavailable, report the
stored update as verified and the visible result as unverified.

When a screenshot contradicts a title read, investigate title parsing or stale
presentation state. Never dismiss the screenshot because the same backend value
can be read again. Reconcile at most once using the no-space formatter, then report
any remaining display limitation. Do not edit app databases/configuration, force
an app restart or repeatedly rewrite titles to manufacture visible confirmation.

## Safe updates

Call the manager once when a state begins and after a verified subject, phase,
or count change. It never writes an unchanged canonical title and must not
block workflow work when title tools or progress evidence are unavailable.
Owners never rename unrelated chats. For child phase/subject/progress updates,
ask the child's owner to invoke the manager. Coordinators may delegate only the
scoped marker-only updates defined above.
