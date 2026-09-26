---
name: ai-skills-library-move-global
description: Move one project skill into Codex user skills after checking for destination conflicts.
---

# AI Skills Library Move Global

Use this skill when the user wants to transfer one named skill from the current project's `.agents/skills` directory to Codex user skills.

1. Require exactly one skill name. The source is `<project-root>/.agents/skills/<skill-name>` and the destination is `$HOME/.agents/skills/<skill-name>`.
2. Confirm the source is a real directory and contains `SKILL.md`. Refuse symbolic links and junctions.
3. Stop if the destination exists. Do not overwrite, merge, or delete a destination skill.
4. Move the complete skill directory to the destination, verify the destination contains `SKILL.md`, and verify the source no longer exists.
5. Report the exact global path. Mention a Codex restart only if the skill does not appear automatically.

This command transfers ownership; it does not copy the skill or update the shared library.
