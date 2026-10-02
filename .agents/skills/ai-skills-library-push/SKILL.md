---
name: ai-skills-library-push
description: Copy one named global Codex skill or all valid global skills into the local AI Skills Library checkout.
---

# AI Skills Library Push

Use this skill only to copy global Codex skills into the local library checkout. It does not publish changes to GitHub.

1. Require exactly one argument: a skill folder name or the literal `all`.
2. Resolve the global source as `$HOME/.agents/skills` and the library destination as this repository's `.agents/skills`. Show both full paths and the selected scope.
3. For a named skill, validate the selected source. For `all`, select every valid top-level skill directory. A valid skill is a real directory containing `SKILL.md`; refuse a symbolic link or junction as the selected directory and refuse linked files or directories within it.
4. When the library checkout is available, use its `scripts/skill-copy-lifecycle.ps1` helper with `-Action push -Skill <name|all>`. Preflight the complete selection before copying anything. A missing/invalid source, invalid destination, unapproved conflict, or inability to write to the checkout fails the operation without changing any skill. If the checkout is not writable, clearly say no skills changed and suggest asking a library maintainer to import the skill; `promote` only copies a project skill to global skills.
5. If source and destination contents match, skip that skill. If a destination is absent, plan a physical directory copy. If destination contents differ, report the conflict and ask the user whether to replace it. Do not use `-ReplaceConflicts` unless the user explicitly authorizes replacement; for `all`, show every conflict and get approval before replacing any.
6. Copy only after every selected skill passes preflight. Verify each destination is a physical directory with `SKILL.md` and content matching its source. If a copy fails, remove only directories newly created by this invocation, leaving sources and pre-existing destinations unchanged.
7. Report `Changed`, `Skipped`, and `Failed` names separately. Do not create a junction or symbolic link, move/delete a source, fetch/commit/push Git history, or modify unrelated skills. If the helper is unavailable, follow these same steps with filesystem copy operations.
