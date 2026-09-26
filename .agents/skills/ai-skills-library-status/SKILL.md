---
name: ai-skills-library-status
description: Compare library, Codex user, and current-project skills in one lean status report.
---

# AI Skills Library Status

Use this skill when the user wants a compact comparison of the shared library, Codex user skills, and the current project's skills. This command is read-only.

Treat this repository's `.agents/skills` directory as the canonical REPO baseline. Compare it with `$HOME/.agents/skills` (GLOBAL) and the current project's `.agents/skills` (PROJECT). A skill is a directory containing `SKILL.md`; compare complete directory contents recursively, not just `SKILL.md`.

Always print this legend before any status section:

```text
Legend: + only here; - missing here but present in REPO; ~ differs from REPO
```

Then print the complete REPO skill-name list. For GLOBAL and PROJECT, print only differences from REPO:

```text
AI Skills Library Status

Legend: + only here; - missing here but present in REPO; ~ differs from REPO

REPO (17)
  ai-skills-library-pull
  ...

GLOBAL  C:\\Users\\srive\\.agents\\skills
  + herdr
  ~ openspec-propose

PROJECT  D:\\Projects\\example\\.agents\\skills
  + project-release-notes
  - docker-sandbox-codex
  ~ openspec-apply-change
```

If GLOBAL or PROJECT has no differences, print `= matches REPO` below that section. If the project has no `.agents/skills` directory, list every REPO skill as missing under PROJECT. Do not copy, move, create, delete, modify, commit, fetch, or push anything.
