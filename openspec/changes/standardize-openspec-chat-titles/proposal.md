# Proposal

## Why

OpenSpec workflows do not present a consistent, compact chat identity while a
change moves through planning, implementation, and close-out. A shared naming
contract must make active work readable while retaining a user's renamed
subject when the workflow rebuilds its standard title.

## What Changes

- Define automatic OpenSpec chat-title management with the `OS-<slug>` naming
  convention for every catalogued OpenSpec workflow. A user rename supplies a
  replacement subject; it does not permanently opt the active owner out of
  title management.
- For every owner with verified, applicable task or proposal progress, render
  the current progress suffix at the end of the rebuilt title and refresh it
  whenever the verified count changes.
- Normalize only unambiguous title duplication: repeated OpenSpec prefix
  fragments, adjacent repeated text, and whitespace. Preserve all other user
  wording, including spelling, capitalization, and punctuation.
- Update orchestration naming so its own title is `[OS-orc: {change}]` and its
  enrolled agents retain their existing titles wrapped as `[{old-name}]`.
- Require title updates to preserve a normalized user-provided subject while
  restoring the active owner's prefix and system-owned progress suffix. An
  unrelated request transfers ownership only when another workflow actually
  becomes active.
- Add a Coordination line to the shared OpenSpec footer for standalone,
  orchestrator, and orchestrated-agent context.
- Add `openspec-orchestrate` to the library catalog, synchronize the completed
  OpenSpec skill updates to global discovery, and compare conflicting copies by
  quality and recency before selecting or escalating a conflict.

## Capabilities

### New Capabilities
- `openspec-chat-title-management`: Optional, safe lifecycle titles for
  OpenSpec workflows and orchestrated project chats.

### Modified Capabilities
- `skill-catalog-navigation`: The OpenSpec catalog includes the orchestration
  workflow and its invocation role.
- `skill-copy-lifecycle`: Copy and move commands resolve conflicting skill
  copies using the approved quality-and-recency policy.

## Impact

Affected OpenSpec skill instructions and the orchestration naming reference;
OpenSpec catalog documentation and catalog tests; global skill discovery
synchronization; and the repository's normal commit/publish workflow.
