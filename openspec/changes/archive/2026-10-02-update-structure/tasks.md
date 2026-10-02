# Tasks

## 1. Categorize Library Skills and Update Copy Lifecycle

- [x] 1.1 Move each tracked skill and its supporting files into the agreed category directory, retain `.agents/skills/.openspec-target`, and verify every skill has one valid `SKILL.md` at the category/skill depth.
- [x] 1.2 Update skill push, pull, promote, demote, and status helpers to discover the categorized layout; implement known family routing and preflight category selection for unknown skills, then verify named and `all` operations with conflict and unmapped-skill fixtures.
- [x] 1.3 Update affected skill instructions, scripts, tests, and repository documentation to use categorized paths; verify a repository-wide search finds no stale flat-layout assumptions except intentional migration/history references.
- [x] 1.4 Add or revise copy lifecycle tests for categorized discovery, all-or-nothing preflight, category routing, unknown category prompts, and source preservation; run the focused test suite and record results.

## 2. Preserve Local OpenSpec Adaptations During Refresh

- [x] 2.1 Change upstream provenance metadata to record each skill's baseline revision and migrate existing metadata; verify every existing upstream-owned OpenSpec skill maps to its correct prior baseline.
- [x] 2.2 Implement per-skill three-way merge against old baseline, current local content, and new upstream content; verify clean upstream updates and local-only edits are preserved and advance the affected baseline.
- [x] 2.3 Handle conflicts without changing the active skill or its baseline while allowing other skills to update; add tests for overlapping edits, mixed clean/conflicting skills, custom skills, and unrelated categories, then run the updater test suite.
- [x] 2.4 Update the manual workflow to report per-skill merge outcomes and stage only intended OpenSpec content/provenance changes; verify a dry-run or fixture workflow summary clearly identifies clean, unchanged, and conflicted skills.

## 3. Align Codex and Claude Installation Guidance

- [x] 3.1 Verify the current `skills` CLI discovers nested library categories and supports selection for Codex and Claude Code; verify documented project-local, global, `--copy`, and update commands against CLI help or disposable fixtures.
- [x] 3.2 Update the library README with the agreed quick-install section structure, project-local default, global option, selection explanation, copy behavior, and update command; verify each shown command matches the supported CLI behavior.
- [x] 3.3 Update the separate `ai-skills-blender` root README and getting-started guide to the same install section format while preserving links to its advanced guides/installers; verify repository history and skill source paths remain independent.

## 4. Integration Review

- [x] 4.1 Run OpenSpec validation and the relevant repository test suites; resolve reported issues and verify the change still satisfies each requirement in `specs/`.
- [x] 4.2 Review both repositories' final installation sections side by side and verify matching headings, install semantics, repository-specific commands, and advanced Blender links.
