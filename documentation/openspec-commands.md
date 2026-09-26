# OpenSpec Commands

## Workflow

Here is the order you want to call the commands.

Some commands are optional, depending on your needs.

Use Git Synchronize between phases when you want to share progress.

| # | Name | Recommended Model Intelligence | Comment |
| --- | --- | --- | --- |
| - | (Git Synchronize)<br>- | ![LOW](https://img.shields.io/badge/-LOW-22C55E?style=flat) | Share progress. |
| 1 | Explore<br>`$openspec-explore` | ![HIGH](https://img.shields.io/badge/-HIGH-EF4444?style=flat) | (Optional) Brainstorm possibilities. |
| 2 | Propose<br>`$openspec-propose` | ![HIGH](https://img.shields.io/badge/-HIGH-EF4444?style=flat) | Creates one focused feature change. |
| 3 | Refine<br>`$openspec-grill-me {n}` | ![HIGH](https://img.shields.io/badge/-HIGH-EF4444?style=flat) | (Optional) Clear doubts via {n} multiple-choice questions. |
| - | (Git Synchronize)<br>- | ![LOW](https://img.shields.io/badge/-LOW-22C55E?style=flat) | Share progress. |
| 4 | Apply<br>`$openspec-apply-change` | ![MED](https://img.shields.io/badge/-MED-F59E0B?style=flat) | Implements and completes one change. |
| 5 | Sync<br>`$openspec-sync-specs` | ![MED](https://img.shields.io/badge/-MED-F59E0B?style=flat) | Updates main specs without archiving. |
| 6 | Archive<br>`$openspec-archive-change` | ![LOW](https://img.shields.io/badge/-LOW-22C55E?style=flat) | Finalizes and archives a change. |
| - | (Git Synchronize)<br>- | ![LOW](https://img.shields.io/badge/-LOW-22C55E?style=flat) | Share progress. |

## Proposal Artifacts

With the default spec-driven schema, `$openspec-propose` creates these files inside `openspec/changes/<change-name>/`.

These artifacts describe the change before implementation begins.

Other schemas may use different artifacts.

| # | Name | Answers | Comment |
| --- | --- | --- | --- |
| 1 | `proposal.md` | **Why** | The problem or opportunity, goals, and scope of the change. |
| 2 | `specs/<capability-path>/spec.md` | **What** | Requirements and scenarios describing the required behavior; these are changes to the main specs. |
| 3 | `design.md` | **How** | Technical approach, architecture, and key implementation decisions. |
| 4 | `tasks.md` | **Steps** | The actionable implementation checklist and progress. |
