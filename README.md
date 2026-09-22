# ai-skills-library

Shared AI skills and agent workflow library.

This repository uses the conventional agent skills layout so it can be cloned, inspected, or wired into Codex like a normal project-level skill source:

```text
.agents/skills/<skill-name>/SKILL.md
```

## Install In A Codex Machine

Give an AI agent these steps when you want an arbitrary checkout to use this shared skills library.

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

2. Optional: remove existing global Codex skills from scope.

   Do this only if you want this library to be the only global/user skill source. Prefer renaming the folder instead of deleting it.

   ```powershell
   $UserSkills = Join-Path $HOME ".agents\skills"
   if (Test-Path -LiteralPath $UserSkills) {
     $Backup = Join-Path $HOME (".agents\skills.disabled-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
     Move-Item -LiteralPath $UserSkills -Destination $Backup
   }
   ```

3. Optional: remove project-local Codex skills from the current checkout.

   Do this only if you want to test with no project-local skills. Prefer renaming the folder instead of deleting it, and do not touch unrelated project files.

   ```powershell
   $ProjectSkills = Join-Path (Get-Location) ".agents\skills"
   if (Test-Path -LiteralPath $ProjectSkills) {
     $Backup = Join-Path (Get-Location) (".agents\skills.disabled-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
     Move-Item -LiteralPath $ProjectSkills -Destination $Backup
   }
   ```

4. Point Codex's user skills at this library.

   Use this step after step 2 if you want the library checkout to be the active global/user skill source.

   ```powershell
   $LibrarySkills = "D:\Documents\Projects\VC\Github\ai-skills-library\.agents\skills"
   $UserAgents = Join-Path $HOME ".agents"
   $UserSkills = Join-Path $UserAgents "skills"
   New-Item -ItemType Directory -Force -Path $UserAgents | Out-Null
   try {
     New-Item -ItemType SymbolicLink -Path $UserSkills -Target $LibrarySkills -ErrorAction Stop | Out-Null
   } catch {
     New-Item -ItemType Junction -Path $UserSkills -Target $LibrarySkills | Out-Null
   }
   ```

5. Smoke test discovery from any project.

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