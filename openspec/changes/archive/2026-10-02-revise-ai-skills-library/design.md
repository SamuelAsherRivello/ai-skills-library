# Design

## Context

The existing library offers manual project copying by default and an optional
global junction workflow. The proposed lifecycle replaces live links with
explicit copies across three independently owned locations: a project, the
user's global Codex skills directory, and the local library Git checkout.

## Goals / Non-Goals

**Goals:**

- Make the direction of every transfer explicit and reviewable.
- Let authors test one project skill globally before promoting it into the
  shared library.
- Provide atomic preflight for `push all` and `pull all`.
- Give users without library-checkout write access an actionable push failure.

**Non-Goals:**

- Performing Git fetch, commit, merge, rebase, or remote push operations.
- Maintaining a live synchronization daemon, junction, or symbolic link.
- Bulk promotion or demotion.
- Removing existing global skills or existing filesystem links automatically.

## Decisions

### Four commands model transfer direction

`push` means global-to-library and `pull` means library-to-global. `promote`
means project-to-global and `demote` means global-to-project. The source name,
destination name, and requested skill scope are shown before a copy starts.

This matches the author workflow without treating the global directory as a
hidden source of truth. An alternative of a single bidirectional sync command
was rejected because timestamps and automatic conflict selection make the
direction ambiguous.

### Copy instead of move or link

Each lifecycle action makes a physical directory copy after source validation.
It never removes the source and never creates a link. This allows a project
experiment, global test copy, and reviewed library version to differ
intentionally.

### Explicit selection and all-command boundary

Push and pull take one skill name or the literal `all`; promote and demote take
exactly one skill. All operations build and validate their complete copy plan
before writing, so a blocked item produces no partial bulk result. This is
preferred to continuing past conflicts because an `all` request represents one
requested library/global state transition.

### Conflict and permission policy

Matching destinations are skipped. Different destinations stop for explicit
replacement authorization. Missing or invalid inputs fail with their name in a
separate report. Push tests library-checkout write access before any work; its
permission error names the checkout and offers maintainer import or promote as
the next action.

### Git remains outside lifecycle commands

Push and pull use the local library checkout only. A maintainer reviews its
working tree and performs ordinary Git operations separately. This avoids
confusing a local skill copy with publication to GitHub.

## Risks / Trade-offs

- [Copies can become stale] -> Reports identify source and destination, and
  users run an explicit command to refresh a copy.
- [Replacement can lose a destination-only edit] -> Stop before replacement
  unless the user explicitly approves it.
- [A sandbox exposes global skills read-only] -> Document that pull and
  promote require an intentionally writable shared-skill mount or a host-side
  run.
- [Existing junction users need migration] -> Retire the link instructions
  without automatically removing links; document a separate, user-approved
  migration path.

## Migration Plan

1. Add the four lifecycle skills and their tests.
2. Revise update/welcome behavior and installation documentation.
3. Publish the new copy-based instructions.
4. Users who choose to leave junctions manually install copied skills, verify
   them, then remove only their own links under a separately approved action.
