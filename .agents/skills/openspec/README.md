# OpenSpec

An active OpenSpec state owner uses the shared [OpenSpec footer](./openspec-footer.md)
at meaningful user-facing checkpoints. Unchanged polls and wrappers/macros stay
silent; a wrapper delegates its title and footer to its active child.

Use these workflows to shape, implement, and close a focused repository
change. The sequence below is a common path, not a required gate.

## Suggested Flow

```text
Optional discovery: dashboard | explore | grill-me
Bootstrap:          init (explicit setup only; planning root, no local skills)
Coordination:       orchestrate-proposal (one change) | orchestrate-program (one program)
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
`openspec-orchestrate-proposal` coordinates one existing change and is not a
required step in the single-change flow. `openspec-orchestrate-program`
coordinates a program's proposal owners; `openspec-apply-program` is its
execution wrapper. `openspec-create-program` delegates planning presentation to
the proposal workflow that is actively creating a child proposal.

## User Workflows

| # | Name | Comment |
|---:|---|---|
| 1 | [openspec-apply-change](./openspec-apply-change/SKILL.md) | Implement a planned change task by task. |
| 2 | [openspec-apply-change-with-playwright](./openspec-apply-change-with-playwright/SKILL.md) | Implement a planned change and validate it in a browser. |
| 3 | [openspec-archive-change](./openspec-archive-change/SKILL.md) | Archive a completed OpenSpec change. |
| 4 | [openspec-audit](./openspec-audit/SKILL.md) | Read-only diagnosis of OpenSpec state and workflow readiness. |
| 5 | [openspec-commit-inclusive](./openspec-commit-inclusive/SKILL.md) | Commit and push all files attributable to one archived change. |
| 6 | [openspec-dashboard](./openspec-dashboard/SKILL.md) | Open or inspect the local OpenSpec dashboard. |
| 7 | [openspec-init](./openspec-init/SKILL.md) | Explicitly bootstrap an OpenSpec planning root without local skills. |
| 8 | [openspec-explore](./openspec-explore/SKILL.md) | Investigate a change before committing to implementation. |
| 9 | [openspec-grill-me](./openspec-grill-me/SKILL.md) | Interview the user to settle planning decisions. |
| 10 | [openspec-macro-finalize-sync-archive-commit-push](./openspec-macro-finalize-sync-archive-commit-push/SKILL.md) | Run the close sequence for one completed change. |
| 11 | [openspec-orchestrate-proposal](./openspec-orchestrate-proposal/SKILL.md) | Coordinate one existing OpenSpec proposal through verified completion. |
| 12 | [openspec-orchestrate-program](./openspec-orchestrate-program/SKILL.md) | Coordinate an existing program's proposal owners and integrated verification. |
| 13 | [openspec-apply-program](./openspec-apply-program/SKILL.md) | Execute an existing program through its program coordinator. |
| 14 | [openspec-create-program](./openspec-create-program/SKILL.md) | Create program planning by delegating proposal creation to its active child. |
| 15 | [openspec-propose](./openspec-propose/SKILL.md) | Create a complete change proposal and planning artifacts. |
| 16 | [openspec-sync-specs](./openspec-sync-specs/SKILL.md) | Sync accepted delta specifications into the main specifications. |
| 17 | [openspec-update-change](./openspec-update-change/SKILL.md) | Revise an existing change's planning artifacts. |

## Legacy metadata

`openspec-release-version` currently contains only `agents/openai.yaml`, not a
`SKILL.md`. It is metadata, not an executable OpenSpec workflow; do not invent
or list it as one until an actual workflow is supplied.
