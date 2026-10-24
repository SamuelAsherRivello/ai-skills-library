# OpenSpec chat title contract

This contract applies during workflow execution, not when editing, evaluating,
or discussing a skill. Only the active state owner updates this chat's title.
Read the shared [footer contract](openspec-footer.md) for response checkpoints.

## State owners

| Workflow | Prefix | Subject | Progress unit |
| --- | --- | --- | --- |
| openspec-dashboard | OS-DSH | selected change, otherwise project | tasks when a change is selected |
| openspec-init | OS-INI | project | no task count before a change exists |
| openspec-audit | OS-AUD | selected change, otherwise project | tasks when a change is selected |
| openspec-explore | OS-EXP | topic or change | tasks only for an existing change |
| openspec-grill-me | OS-GRL | plan or change | tasks only for an existing change |
| openspec-propose | OS-PRP | change | tasks once tracking exists |
| openspec-update-change | OS-REV | change | tasks when tracking exists |
| openspec-apply-change | OS-APP | change | tasks |
| openspec-sync-specs | OS-SYN | change | tasks when tracking exists |
| openspec-archive-change | OS-ARC | change | retained tasks when available |
| openspec-commit-inclusive | OS-CMT | archived change | retained tasks when available |
| openspec-orchestrate-proposal | OS-ORC | change | tasks |
| openspec-orchestrate-program | OS-ORP | program ID | proposals |

Use `{prefix}: {subject} ({completed}/{total})` with unpadded integers, for
example `OS-APP: add-auth (3/7)` or `OS-ORP: site-expansion (0/5)`.
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

## Wrappers and macros

These workflows do not own a prefix, progress suffix or footer:

- openspec-apply-change-with-playwright delegates to openspec-apply-change.
- openspec-apply-program delegates to openspec-orchestrate-program.
- openspec-create-program delegates presentation to its active
  openspec-propose child when creating proposals.
- openspec-macro-finalize-sync-archive-commit-push delegates successively to
  openspec-sync-specs, openspec-archive-change and openspec-commit-inclusive.

Leave the last active child's title in place. Do not restore a macro title
between calls, add a wrapper prefix, or emit an extra macro footer. A blocker
before any child is selected gets a plain explanation, not fabricated child
progress. An owning child may report required wrapper verification in its
checkpoint. It must not claim completion before that verification passes.

A program coordinator is a distinct owner, not a presentation-only macro:
it owns OS-ORP in its chat, while children own their titles in their own chats.
An inline interview temporarily owns OS-GRL; returning to a real parent phase
is one ownership handoff, not permission for competing title updates.

## Safe updates

Set the title once when a state begins and only when its subject, phase or
verified count changes. Record the last confirmed applied title in existing
workflow state. Never write an unchanged title on a poll.

Before later writes, verify the current title still matches the last one this
workflow confirmed. Preserve human overrides, including across restarts.
Do not stack prefixes. Do not rename unrelated or child chats. Ask a child
owner to repair missing naming. Reconcile uncertain writes by reading before
retrying. If title tools or progress evidence are unavailable, keep working
and report the narrow limitation when actionable.
