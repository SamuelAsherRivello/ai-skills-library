# OpenSpec

An active OpenSpec state owner uses the shared [OpenSpec footer](./openspec-footer.md)
at meaningful user-facing checkpoints. Unchanged polls and wrappers/macros stay
silent; a wrapper delegates its title and footer to its active child.

Use these workflows to shape, implement, and close a focused repository
change. The sequence below is a common path, not a required gate.

Coordinators and their enrolled chats share one leading `* `, for example
`* OS-ORC: add-auth (3/7)` and `* OS-APP: add-auth (2/4)`. Every workflow preserves
this marker across phase changes. The [title contract](./openspec-title-management.md)
defines membership, nested coordination and marker-only updates; the ledger
identifies which coordinator owns each chat.

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

`ai-skills-openspec-dashboard` can be used at any stage. `ai-skills-openspec-commit-inclusive`
performs and verifies its normal push, so the close flow does not require a
second push. Version release is intentionally separate from OpenSpec; use
[`ai-skills-create-github-release`](../ai-skills-create/ai-skills-create-github-release/SKILL.md)
only after a releasable remote commit exists.
`ai-skills-openspec-orchestrate-proposal` coordinates one existing change and is not a
required step in the single-change flow. `ai-skills-openspec-orchestrate-program`
coordinates a program's proposal owners; `ai-skills-openspec-apply-program` is its
execution wrapper. `ai-skills-openspec-create-program` delegates planning presentation to
the proposal workflow that is actively creating a child proposal.

## User Workflows

| # | Name | Comment |
|---:|---|---|
| 1 | [ai-skills-openspec-apply-change](./ai-skills-openspec-apply-change/SKILL.md) | Implement a planned change task by task. |
| 2 | [ai-skills-openspec-apply-change-with-playwright](./ai-skills-openspec-apply-change-with-playwright/SKILL.md) | Implement a planned change and validate it in a browser. |
| 3 | [ai-skills-openspec-archive-change](./ai-skills-openspec-archive-change/SKILL.md) | Archive a completed OpenSpec change. |
| 4 | [ai-skills-openspec-audit](./ai-skills-openspec-audit/SKILL.md) | Read-only diagnosis of OpenSpec state and workflow readiness. |
| 5 | [ai-skills-openspec-commit-inclusive](./ai-skills-openspec-commit-inclusive/SKILL.md) | Commit and push all files attributable to one archived change. |
| 6 | [ai-skills-openspec-dashboard](./ai-skills-openspec-dashboard/SKILL.md) | Open or inspect the local OpenSpec dashboard. |
| 7 | [ai-skills-openspec-init](./ai-skills-openspec-init/SKILL.md) | Explicitly bootstrap an OpenSpec planning root without local skills. |
| 8 | [ai-skills-openspec-explore](./ai-skills-openspec-explore/SKILL.md) | Investigate a change before committing to implementation. |
| 9 | [ai-skills-openspec-grill-me](./ai-skills-openspec-grill-me/SKILL.md) | Interview the user to settle planning decisions. |
| 10 | [ai-skills-openspec-macro-finalize-sync-archive-commit-push](./ai-skills-openspec-macro-finalize-sync-archive-commit-push/SKILL.md) | Run the close sequence for one completed change. |
| 11 | [ai-skills-openspec-orchestrate-proposal](./ai-skills-openspec-orchestrate-proposal/SKILL.md) | Coordinate one existing OpenSpec proposal through verified completion. |
| 12 | [ai-skills-openspec-orchestrate-program](./ai-skills-openspec-orchestrate-program/SKILL.md) | Coordinate an existing program's proposal owners and integrated verification. |
| 13 | [ai-skills-openspec-apply-program](./ai-skills-openspec-apply-program/SKILL.md) | Execute an existing program through its program coordinator. |
| 14 | [ai-skills-openspec-create-program](./ai-skills-openspec-create-program/SKILL.md) | Create program planning by delegating proposal creation to its active child. |
| 15 | [ai-skills-openspec-propose](./ai-skills-openspec-propose/SKILL.md) | Create a complete change proposal and planning artifacts. |
| 16 | [ai-skills-openspec-sync-specs](./ai-skills-openspec-sync-specs/SKILL.md) | Sync accepted delta specifications into the main specifications. |
| 17 | [ai-skills-openspec-title-management](./ai-skills-openspec-title-management/SKILL.md) | Centrally rebuild active OpenSpec thread titles. |
| 18 | [ai-skills-openspec-update-change](./ai-skills-openspec-update-change/SKILL.md) | Revise an existing change's planning artifacts. |

## Upstream updates

The 18 executable skills use `ai-skills-openspec-*` names and remain in the
`ai-skills-openspec` category. The `openspec` CLI and planning directories keep their
existing names.

`documentation/openspec-upstream.json` records each local skill's original
upstream name. The update script uses those names to read upstream sources and
recorded baselines, then translates known skill references into the local
namespace before merging. It preserves local customizations, holds conflicted
skills at their previous baselines, and does not install new upstream skills.
Custom skills remain excluded from upstream merges by their author metadata.

## Legacy metadata

`ai-skills-openspec-release-version` currently contains only `agents/openai.yaml`, not a
`SKILL.md`. It is metadata, not an executable OpenSpec workflow; do not invent
or list it as one until an actual workflow is supplied.
