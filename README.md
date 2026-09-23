![Samuel Asher Rivello](https://raw.githubusercontent.com/SamuelAsherRivello/github-repository-template/main/project-name/documentation/samuel-asher-rivello-banner.png)

# AI Skills Library

Reusable Codex skills for local projects and teams.

## Getting Started

Use these steps to add this library to a project alongside your existing skills.

First, clone the project you want to work on, such as
[Babylon Lite ASCII RPG](https://github.com/SamuelAsherRivello/babylon-lite-ascii-rpg).

### 🛠 Add Library To Your Project

1. Clone or update this library.

   ```powershell
   $LibraryRoot = "D:\Documents\Projects\VC\Github\ai-skills-library"
   if (Test-Path -LiteralPath $LibraryRoot) {
     Set-Location -LiteralPath $LibraryRoot
     git pull
   } else {
     git clone https://github.com/SamuelAsherRivello/ai-skills-library $LibraryRoot
   }
   ```

2. Link each library skill into the user's global Codex skills folder.

   This keeps existing user skills intact and adds this library's skills beside them. Existing skills with the same name are left unchanged and reported.

   ```powershell
   $LibrarySkills = "D:\Documents\Projects\VC\Github\ai-skills-library\.agents\skills"
   $UserSkills = Join-Path $HOME ".agents\skills"
   New-Item -ItemType Directory -Force -Path $UserSkills | Out-Null

   Get-ChildItem -LiteralPath $LibrarySkills -Directory | ForEach-Object {
     $Target = Join-Path $UserSkills $_.Name
     if (Test-Path -LiteralPath $Target) {
       Write-Host "Skipping existing skill: $($_.Name)"
     } else {
       try {
         New-Item -ItemType SymbolicLink -Path $Target -Target $_.FullName -ErrorAction Stop | Out-Null
       } catch {
         New-Item -ItemType Junction -Path $Target -Target $_.FullName | Out-Null
       }
       Write-Host "Linked skill: $($_.Name)"
     }
   }
   ```

3. Start or restart Codex in any project checkout and smoke test discovery.

   ```text
   Use $ai-skills-library-welcome
   ```

## OpenSpec Workflow

This workflow is adapted from the [Babylon Lite ASCII RPG README](https://github.com/SamuelAsherRivello/babylon-lite-ascii-rpg#readme). The intelligence levels are recommendations for the model or reasoning effort you choose; increase them when a change is complex or unclear.

| # | Name | Command | Comment | Model intelligence |
| --- | --- | --- | --- | --- |
| - | (Git Synchronize) | - | Share progress. | Low |
| 1 | Explore | `$openspec-explore` | (Optional) Brainstorm possibilities. | High |
| 2 | Propose | `$openspec-propose` | Creates one focused feature change. | High |
| 3 | Refine | `$openspec-grill-me {n}` | (Optional) Clear doubts via {n} multiple-choice questions. | High |
| - | (Git Synchronize) | - | Share progress. | Low |
| 4 | Apply | `$openspec-apply-change` | Implements and completes one change. | Medium |
| 5 | Sync | `$openspec-sync-specs` | Updates main specs without archiving. | Medium |
| 6 | Archive | `$openspec-archive-change` | Finalizes and archives a change. | Low |
| - | (Git Synchronize) | - | Share progress. | Low |

### Proposal Artifacts

With the default spec-driven schema, `$openspec-propose` creates these files inside `openspec/changes/<change-name>/`. Other schemas may use different artifacts.

| Artifact | Answers | What it contains |
| --- | --- | --- |
| `proposal.md` | **Why and what** | The problem or opportunity, goals, and scope of the change. |
| `specs/<capability-path>/spec.md` | **What** | Requirements and scenarios describing the required behavior; these are changes to the main specs. |
| `design.md` | **How** | Technical approach, architecture, and key implementation decisions. |
| `tasks.md` | **How, step by step** | The actionable implementation checklist and progress. |

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
