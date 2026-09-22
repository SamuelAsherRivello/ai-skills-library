# ai-skills-library

Shared AI skills and agent workflow library.

This repository uses the conventional agent skills layout so it can be cloned, inspected, or wired into Codex like a normal project-level skill source:

```text
.agents/skills/<skill-name>/SKILL.md
```

## Add This Library To Codex

Give an AI agent these steps when you want an arbitrary checkout to use this shared skills library alongside the user's existing skills.

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

3. Smoke test discovery from any project.

   Start or restart Codex in a project checkout and ask:

   ```text
   Use $ai-skills-library-welcome
   ```

   If the skill responds, the shared library is in scope. Pull this repository later to update the shared skills.

## Current Skills

- `.agents/skills/ai-skills-library-welcome`
- `.agents/skills/openspec-dashboard` - custom optional OpenSpecUI dashboard workflow
- `.agents/skills/openspec-finalize-sync-archive-commit-push` - custom optional post-apply finalization workflow
- `.agents/skills/openspec-grill-me` - custom optional OpenSpec interview workflow
- `.agents/skills/openspec-release-version` - custom optional GitHub Actions release workflow
- OpenSpec core profile skills:
  - `.agents/skills/openspec-explore`
  - `.agents/skills/openspec-propose`
  - `.agents/skills/openspec-apply-change`
  - `.agents/skills/openspec-update-change`
  - `.agents/skills/openspec-sync-specs`
  - `.agents/skills/openspec-archive-change`

The OpenSpec core set intentionally matches the lightweight core profile: explore, propose, apply, update, sync, and archive. `openspec-dashboard`, `openspec-finalize-sync-archive-commit-push`, `openspec-grill-me`, and `openspec-release-version` are custom optional companion workflows, not part of OpenSpec's core profile.