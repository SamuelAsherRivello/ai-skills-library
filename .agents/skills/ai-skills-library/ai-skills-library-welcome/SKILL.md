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
- Explain the command directions: `pull` copies library skills to global skills, `push` copies global skills to the library checkout, `move-global` moves project skills to global skills, and `move-local` moves global skills into the project. Inside the library checkout, the move commands copy and preserve the canonical catalog source; explain this exception. `promote` and `demote` remain one-skill copy commands for ordinary projects.
- Mention that copy and move commands stop on destination conflicts; moves preserve their source if copying or verification fails.
- If useful, suggest running the same smoke test from another project to confirm machine-level setup.
