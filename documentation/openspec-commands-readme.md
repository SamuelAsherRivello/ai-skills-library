# OpenSpec Commands

Use OpenSpec to agree on a focused change before implementation, then keep its specifications aligned with the completed work.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Details](#details)
3. [Command List](#command-list)
4. [Resources](#resources)

## Getting Started

Use this suggested flow for one focused change. It is guidance, not a required
gate.

### 1. Plan

**Prompt AI:**

```
$openspec-propose
```

Optionally use `$openspec-explore` or `$openspec-grill-me` first. Then create
the proposal, specifications, design, and tasks for the change.

### 2. Apply

**Prompt AI:**

```
$openspec-apply-change
```

Implement the approved change and complete its tasks.

### 3. Finalize

**Prompt AI:**

```
$openspec-sync-specs
```

Sync accepted delta specifications, archive the completed change, then use
`$openspec-commit-inclusive` to commit and push the scoped work. The
finalization macro combines those close-out steps when appropriate.

## Details

Here are more commands to try.

## Command List

<p align="center">
  <img src="diagrams/openspec-workflow-dark.svg" width="800" alt="Dark theme: Start points to Explore (Optional), then Propose to Grill Me (Optional) to Apply to Archive and back to Explore.">
</p>

Here are commands and the recommended AI intelligence level to use.

| # | Command | Purpose | Rec. Intelligence |
| --- | --- | --- | --- |
| 1 | `$openspec-dashboard` | Inspect the local dashboard at any stage. | ![Low](https://img.shields.io/badge/Low-red?style=flat-square) |
| 2 | `$openspec-explore` | Brainstorm or investigate a possible change without implementation. | ![Low](https://img.shields.io/badge/Low-red?style=flat-square) |
| 3 | `$openspec-grill-me {n}` | Settle planning decisions with focused questions. | ![High](https://img.shields.io/badge/High-green?style=flat-square) |
| 4 | `$openspec-propose` | Create one focused change proposal. | ![Med](https://img.shields.io/badge/Med-yellow?style=flat-square) |
| 5 | `$openspec-update-change` | Revise planning artifacts as decisions evolve. | ![Med](https://img.shields.io/badge/Med-yellow?style=flat-square) |
| 6 | `$openspec-apply-change` | Implement the current change. | ![High](https://img.shields.io/badge/High-green?style=flat-square) |
| 7 | `$openspec-sync-specs` | Apply accepted delta specifications to the main specifications. | ![Med](https://img.shields.io/badge/Med-yellow?style=flat-square) |
| 8 | `$openspec-archive-change` | Finalize and archive a completed change. | ![Low](https://img.shields.io/badge/Low-red?style=flat-square) |
| 9 | `$openspec-commit-inclusive` | Commit and push files related to one archived change. | ![High](https://img.shields.io/badge/High-green?style=flat-square) |
| 10 | `$openspec-macro-finalize-sync-archive-commit-push` | Run the full close-out sequence after implementation. | ![High](https://img.shields.io/badge/High-green?style=flat-square) |

For a repository version release after a remote commit exists, use
[`$ai-skills-release-version`](../.agents/skills/ai-skills-create/ai-skills-release-version/SKILL.md).

### Proposal Artifacts

With the default spec-driven schema, `$openspec-propose` creates these files inside
`openspec/changes/<change-name>/`. Other schemas may use different artifacts.

| File | Purpose | Answers? |
| --- | --- | --- |
| `proposal.md` | Defines the problem, goals, and scope. | ![Why](https://img.shields.io/badge/Why-yellow?style=flat-square) |
| `specs/<capability-path>/spec.md` | Defines requirements and scenarios. | ![What](https://img.shields.io/badge/What-blue?style=flat-square) |
| `design.md` | Records the technical approach and key decisions. | ![Where](https://img.shields.io/badge/Where-red?style=flat-square) |
| `tasks.md` | Tracks implementation work. | ![When](https://img.shields.io/badge/When-green?style=flat-square) |

## Resources

- [OpenSpec documentation](https://openspec.dev/docs)
- [OpenSpec on GitHub](https://github.com/Fission-AI/OpenSpec)
