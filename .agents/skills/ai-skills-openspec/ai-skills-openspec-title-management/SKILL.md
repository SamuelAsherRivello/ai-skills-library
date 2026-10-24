---
name: ai-skills-openspec-title-management
description: Rebuild the active OpenSpec workflow chat title from its current user-edited subject and verified progress. Use only when an OpenSpec title owner delegates its own current chat.
---

# OpenSpec Title Management

This is the sole OpenSpec title writer. It manages only the invoking workflow's
current chat; it never renames a child, another project chat, or a thread found
by searching. It does not implement, plan, archive, sync, commit, push, or
change OpenSpec artifacts.

The caller supplies its active owner prefix from the shared
[title contract](../openspec-title-management.md), its resolved subject context,
and its selected store or program context when applicable. Do not invent a
prefix or infer ownership from a pre-existing title.

## When to reconcile

Read the current thread title at the start of an owner state and after every
verified subject, phase, task, or proposal-progress change. Reconcile before a
meaningful owner response when the current title was externally changed since
the last read. Do not write on an unchanged poll or merely because time passed.

If title tools are unavailable, the title cannot be read, or verified tracking
cannot be obtained, continue the caller's authorized work. Report the narrow
limitation only when useful; never fabricate a count or make naming failure a
blocker.

## Subject reconstruction

Treat the current title as a user-provided replacement subject, not a permanent
opt-out. Before rendering, conservatively normalize it:

1. Remove every repeated OpenSpec prefix fragment matching `OS-<slug>:`.
2. Remove a terminal system-owned progress suffix of the form `(N/M)` before
   deriving the current suffix.
3. Trim and collapse whitespace, then collapse only exact adjacent repeated
   text, including a clearly repeated final word or phrase such as
   `coolcool` → `cool`.
4. Preserve spelling, punctuation, capitalization, and all other wording. Do
   not rewrite a subjective title, correct a typo, or guess a different topic.

If normalization leaves no usable subject, use the caller's resolved subject
context. If that is also unavailable, leave the title unchanged and report why
only when actionable.

Render `{active-prefix}: {normalized-subject}`. The active caller's prefix
always wins: an Explore owner renders `OS-EXP`, even when the user supplied an
`OS-PRP:` fragment. Never stack prefixes.

## Verified progress

For a change-backed owner, obtain current task progress from the selected
OpenSpec context and `openspec status --change "<change>" --json`. For a
program coordinator, obtain its verified distinct child-proposal count from
the current program ledger and coordinator evidence. Use a retained archived
count only when it is trustworthy.

When a count is applicable and verified, append ` ({completed}/{total})` using
unpadded integers. Replace any old system suffix and refresh it immediately
after a verified progress change. When tracking is inapplicable or unavailable,
omit the suffix; never render `0/0` or derive progress from interview questions
or planned artifacts.

Read immediately before a write, render the canonical title once, and verify
the result. If the user edits the title during that race, use the newer title as
the next subject and reconcile once; do not retry blindly or repeatedly write
an unchanged value.
