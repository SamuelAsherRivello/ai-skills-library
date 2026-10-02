---
name: ai-skills-library-promote
description: Copy one named project-local skill to global Codex skills for cross-project testing.
---

# AI Skills Library Promote

Use this skill to copy one project-local skill into global Codex skills for testing.

1. Require exactly one skill folder name. Reject `all`, paths, and names containing path separators.
2. Resolve the source as the current project's `.agents/skills/<skill>` and the destination as `$HOME/.agents/skills/<skill>`. Show both full paths.
3. Validate that the source is a real directory containing `SKILL.md`. Refuse a symbolic link or junction as the selected directory and refuse linked files or directories within it.
4. When the library checkout is available, use its `scripts/skill-copy-lifecycle.ps1` helper with `-Action promote -Skill <name> -ProjectDirectory <project-root>`. Preflight before writing. If the destination is the same skill by content, report it as skipped. If it is invalid or contains different content, report a conflict and ask the user whether to replace it. Do not use `-ReplaceConflicts` unless the user explicitly authorizes replacement. A missing destination is eligible for a physical copy.
5. Copy the complete source directory without moving or deleting it. Verify the destination is a physical directory containing `SKILL.md` and that its content matches the source. If copying fails, remove only the destination created by this invocation.
6. Report changed, skipped, and failed skill names separately. Do not create links or perform Git operations. If the helper is unavailable, follow these same steps with filesystem copy operations.
