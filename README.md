![Samuel Asher Rivello](https://raw.githubusercontent.com/SamuelAsherRivello/github-repository-template/main/project-name/documentation/samuel-asher-rivello-banner.png)

# AI Skills Library

Reusable Codex skills for local projects and teams.

## Table of Contents

1. [What About Sandbox?](#what-about-sandbox)
2. [Getting Started](#getting-started)
3. [OpenSpec Workflow](#openspec-workflow)
4. [Credits](#credits)

## What About Sandbox?

- [Windows Sandbox Setup for Codex](documentation/setup-sandbox-windows.md): Video overview, official documentation, setup, permissions, and usage.

## Getting Started

### 1. Install Commands

Use these commands to copy or move skills between this library, your Codex user skills, and the current project's `.agents/skills` directory. They do not create or use symbolic links or junctions.

| Command | Effect |
| --- | --- |
| `$ai-skills-library-push <skill>` | Copies one skill from Codex user skills into this library, then commits and pushes it. |
| `$ai-skills-library-pull` | Copies all library skills into Codex user skills. |
| `$ai-skills-library-move-global <skill>` | Moves one skill from the current project's `.agents/skills` to Codex user skills. |
| `$ai-skills-library-move-project <skill>` | Moves one skill from Codex user skills to the current project's `.agents/skills`. |

Codex user skills are stored in `C:\\Users\\<your-user>\\.agents\\skills` on Windows. Commands stop for an existing destination skill instead of overwriting it without your explicit approval.

### 2. Use Commands

Invoke the installed skills in Codex with their `$skill-name` commands.

## OpenSpec Workflow

Here are the workflow commands and the proposal artifacts.

| # | Name | Comment | Model intelligence |
| --- | --- | --- | --- |
| - | (Git Synchronize)<br>- | Share progress. |![LOW](https://img.shields.io/badge/-LOW-22C55E?style=flat) |
| 1 | Explore<br>`$openspec-explore` | (Optional) Brainstorm possibilities. |![HIGH](https://img.shields.io/badge/-HIGH-EF4444?style=flat) |
| 2 | Propose<br>`$openspec-propose` | Creates one focused feature change. |![HIGH](https://img.shields.io/badge/-HIGH-EF4444?style=flat) |
| 3 | Refine<br>`$openspec-grill-me {n}` | (Optional) Clear doubts via {n} multiple-choice questions. |![HIGH](https://img.shields.io/badge/-HIGH-EF4444?style=flat) |
| - | (Git Synchronize)<br>- | Share progress. |![LOW](https://img.shields.io/badge/-LOW-22C55E?style=flat) |
| 4 | Apply<br>`$openspec-apply-change` | Implements and completes one change. |![MED](https://img.shields.io/badge/-MED-F59E0B?style=flat) |
| 5 | Sync<br>`$openspec-sync-specs` | Updates main specs without archiving. |![MED](https://img.shields.io/badge/-MED-F59E0B?style=flat) |
| 6 | Archive<br>`$openspec-archive-change` | Finalizes and archives a change. |![LOW](https://img.shields.io/badge/-LOW-22C55E?style=flat) |
| - | (Git Synchronize)<br>- | Share progress. |![LOW](https://img.shields.io/badge/-LOW-22C55E?style=flat) |

### Proposal Artifacts

With the default spec-driven schema, `$openspec-propose` creates these files inside `openspec/changes/<change-name>/`. Other schemas may use different artifacts.

| # | Name | Answers | Comment |
| --- | --- | --- | --- |
| 1 | `proposal.md` | **Why** | The problem or opportunity, goals, and scope of the change. |
| 2 | `specs/<capability-path>/spec.md` | **What** | Requirements and scenarios describing the required behavior; these are changes to the main specs. |
| 3 | `design.md` | **How** | Technical approach, architecture, and key implementation decisions. |
| 4 | `tasks.md` | **Steps** | The actionable implementation checklist and progress. |

## Credits

### Contributors

- Samuel Asher Rivello - Over 25 years of game development XP (2026)

### Contact

- [LinkedIn.com/in/SamuelAsherRivello](https://Linkedin.com/in/SamuelAsherRivello)
- [GitHub.com/SamuelAsherRivello](https://github.com/SamuelAsherRivello/)
- [Twitter.com/srivello](https://twitter.com/srivello/)
- Resume / Portfolio: [SamuelAsherRivello.com](http://www.SamuelAsherRivello.com)

### License

- No license file is currently provided in this repository.
