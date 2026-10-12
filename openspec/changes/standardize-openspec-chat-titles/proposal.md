# Proposal

## Why

OpenSpec workflows do not present a consistent, compact chat identity while a
change moves through planning, implementation, and close-out. A shared naming
contract makes active work readable without overriding a user-managed title.

## What Changes

- Define automatic, user-override-safe OpenSpec chat-title management with the
  `OS-<slug>` naming convention for every catalogued OpenSpec workflow.
- Show task progress only for the two apply workflows, at the end of the
  title: `OS-app: {change} (07/10)` and `OS-apw: {change} (07/10)`.
- Update orchestration naming so its own title is `[OS-orc: {change}]` and its
  enrolled agents retain their existing titles wrapped as `[{old-name}]`.
- Require title updates to preserve user overrides and to stop managing a chat
  after an unrelated user request.
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
