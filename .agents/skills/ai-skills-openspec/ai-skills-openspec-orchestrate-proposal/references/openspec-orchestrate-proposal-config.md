# Proposal coordinator naming

- Coordinator: `*OS-ORC: {subject} ({completed}/{total})`. Omit unverified progress.
- Shared marker: exactly one literal leading `*` on the coordinator and all
  enrolled chats. Preserve child subjects, workflow prefixes and progress.
- Scope: verified membership in this proposal's ledger, never every project chat.
  Record coordinator/root thread IDs, enrolled IDs and marker ownership.
- Delegate coordinator rendering and enrolled-chat marker-only updates to
  `$ai-skills-openspec-title-management`. Child owners alone rebuild their phases
  and progress. Non-OpenSpec and idle owners also receive the marker.
- Read the shared [title contract](../../openspec-title-management.md). Carry
  membership through assignments, phase changes and resumes. Nested membership
  still uses one asterisk. The ledger, not the marker, identifies the exact group.
- Reconcile at execution start and verified progress/membership changes. Retain
  markers on pause/completion; removal follows explicit detachment rules.
- Editing this skill never triggers a rename. Naming failure does not block work.
- Legacy project-wide naming ledgers do not authorize enrolling or renaming chats.
