<!-- AI: Keep commands rooted at the repository. This repository stores shared Codex skills in .agents/skills/. -->
# ai-skills-library

<!-- AI: Update this project summary only when the shared library purpose changes. -->
Shared AI skills and agent workflow library for Codex. This repository uses the conventional agent skills layout so it can be cloned, inspected, or wired into Codex like a normal project-level skill source:

```text
.agents/skills/<skill-name>/SKILL.md
```

## Table of Contents

1. [Getting Started](#getting-started)
2. [Credits](#credits)

## Getting Started

<!-- AI: Preserve the additive setup model. Do not remove or rename existing user/project skills when installing this library unless explicitly requested. -->
Use these steps when you want an arbitrary checkout to use this shared skills library alongside the user's existing skills.

### 🛠 Build Project

1. No build step is required; this repository contains Markdown skill instructions and optional skill metadata.
2. To validate a skill after editing, run the local Codex skill validator against that skill folder.

### 🛠 Run Project

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

### 🛠 Release Version

1. Review changed skill files and validate edited skills before release.
2. Commit and push changes to the repository's default branch.
3. Pull this repository on each machine that consumes the shared skills.

## Credits

<!-- AI: Preserve established attribution and ownership. Customize the following subsections only from confirmed contributor, contact, and license information; do not infer a new owner from the repository name. -->
### 💡 Contributors

<!-- AI: Preserve existing contributor credit and add contributors only when confirmed. Do not automatically advance experience counts or their reference year. -->
- Samuel Asher Rivello - Over 25 years of game development XP (2026)

### 💡 Contact

<!-- AI: Preserve confirmed contact destinations and their order unless requested otherwise. Use readable display URLs without a protocol or trailing slash while keeping the real link target intact. Do not invent accounts or change target capitalization based on display styling. -->
- [LinkedIn.com/in/SamuelAsherRivello](https://Linkedin.com/in/SamuelAsherRivello) ⭐
- [GitHub.com/SamuelAsherRivello](https://github.com/SamuelAsherRivello/)
- [Twitter.com/srivello](https://twitter.com/srivello/)
- Resume / Portfolio: [SamuelAsherRivello.com](http://www.SamuelAsherRivello.com)

### 💡 License

<!-- AI: Keep the license statement consistent with the actual repository files. Do not add a license name, owner, or date unless a matching license file exists or the user explicitly requests it. -->
- No license file is currently provided in this repository.