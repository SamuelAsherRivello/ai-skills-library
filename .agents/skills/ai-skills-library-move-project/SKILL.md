---
name: ai-skills-library-move-project
description: Move one Codex user skill into the current project's skill directory safely.
---

# AI Skills Library Move Project

Use this skill when the user wants to transfer one named skill from Codex user skills into the current project's `.agents/skills` directory.

1. Require exactly one skill name. The source is `$HOME/.agents/skills/<skill-name>` and the destination is `<project-root>/.agents/skills/<skill-name>`.
2. Confirm the source is a real directory and contains `SKILL.md`. Refuse symbolic links and junctions.
3. Stop if the destination exists. Do not overwrite, merge, or delete a destination skill.
4. Move the complete skill directory to the destination, verify the destination contains `SKILL.md`, and verify the source no longer exists.
5. Report the exact project-local path.

This command transfers ownership; it does not copy the skill or update the shared library.
