# OpenSpec

All OpenSpec workflow responses end with the shared [OpenSpec footer](./openspec-footer.md).

Use these workflows to shape, implement, and close a focused repository
change. The sequence below is a common path, not a required gate.

## Suggested Flow

```text
Optional discovery: dashboard | explore | grill-me
Coordination:       orchestrate (project-wide, alongside the normal flow)
Plan:               propose <-> update-change
Build:              apply-change
Close:              sync-specs -> archive-change -> commit-inclusive
Shortcut:           macro-finalize-sync-archive-commit-push
Release:            ai-skills-create-github-release after a remote commit exists
```

`openspec-dashboard` can be used at any stage. `openspec-commit-inclusive`
performs and verifies its normal push, so the close flow does not require a
second push. Version release is intentionally separate from OpenSpec; use
[`ai-skills-create-github-release`](../ai-skills-create/ai-skills-create-github-release/SKILL.md)
only after a releasable remote commit exists.
`openspec-orchestrate` coordinates existing project chats and is not a required
step in the single-change flow.

## User Workflows

| # | Name | Comment |
|---:|---|---|
| 1 | [openspec-apply-change](./openspec-apply-change/SKILL.md) | Implement a planned change task by task. |
| 2 | [openspec-apply-change-with-playwright](./openspec-apply-change-with-playwright/SKILL.md) | Implement a planned change and validate it in a browser. |
| 3 | [openspec-archive-change](./openspec-archive-change/SKILL.md) | Archive a completed OpenSpec change. |
| 4 | [openspec-commit-inclusive](./openspec-commit-inclusive/SKILL.md) | Commit and push all files attributable to one archived change. |
| 5 | [openspec-dashboard](./openspec-dashboard/SKILL.md) | Open or inspect the local OpenSpec dashboard. |
| 6 | [openspec-explore](./openspec-explore/SKILL.md) | Investigate a change before committing to implementation. |
| 7 | [openspec-grill-me](./openspec-grill-me/SKILL.md) | Interview the user to settle planning decisions. |
| 8 | [openspec-macro-finalize-sync-archive-commit-push](./openspec-macro-finalize-sync-archive-commit-push/SKILL.md) | Run the close sequence for one completed change. |
| 9 | [openspec-orchestrate](./openspec-orchestrate/SKILL.md) | Coordinate existing project chats to complete their assigned OpenSpec changes; its own managed title uses `OS-orchestrate: {change}`. |
| 10 | [openspec-propose](./openspec-propose/SKILL.md) | Create a complete change proposal and planning artifacts. |
| 11 | [openspec-sync-specs](./openspec-sync-specs/SKILL.md) | Sync accepted delta specifications into the main specifications. |
| 12 | [openspec-update-change](./openspec-update-change/SKILL.md) | Revise an existing change's planning artifacts. |
