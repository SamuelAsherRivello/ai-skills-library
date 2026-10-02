---
name: ai-skills-library-welcome
description: Confirm that the shared ai-skills-library Codex skills are installed and available in the current project.
metadata:
  short-description: Smoke test shared skill availability
---

# AI Skills Library Welcome

Use this skill when the user wants to verify that the shared `ai-skills-library` Codex skills are discoverable from the current project or machine.

Respond briefly:

- Confirm that this skill being available means the shared library is in Codex's skill scope.
- Explain that project, global Codex, and library checkout skills are separate copies. Changes in one location do not update the others automatically.
- Point to the explicit copy commands: `pull` copies library skills to global skills, `push` copies global skills to the library checkout, `promote` copies a project skill to global skills, and `demote` copies a global skill to the project.
- Mention that these commands preserve their sources and stop on destination conflicts.
- If useful, suggest running the same smoke test from another project to confirm machine-level setup.
