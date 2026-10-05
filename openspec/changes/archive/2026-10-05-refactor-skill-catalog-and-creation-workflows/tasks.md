# Tasks

## 1. Add navigable skill catalogs

- [x] 1.1 Create standalone README catalogs at `.agents/skills/` and each of its four category roots, with complete relative links and original descriptions; verify every tracked skill directory is listed exactly once in its category README.
- [x] 1.2 Document explicit and model-reachable invocation roles only where they affect safe selection, and add the suggested non-mandatory OpenSpec flow; verify the OpenSpec catalog names the existing close sequence and the separate release workflow accurately.
- [x] 1.3 Add a structural catalog test that detects missing, stale, or cross-category skill links; verify it passes against the complete checked-in catalog.

## 2. Add the React application creation workflow

- [x] 2.1 Create `ai-skills-create/ai-skills-create-app` with `SKILL.md` and `agents/openai.yaml`; verify the skill frontmatter, folder name, and metadata pass focused skill validation.
- [x] 2.2 Define application inputs, template use, non-game boundary, and safe repository-creation checks; verify the skill routes game requests to the existing game workflow and does not prescribe Babylon setup.
- [x] 2.3 Add the new application skill to the creation catalog and relevant root documentation; verify all links resolve to its `SKILL.md`.

## 3. Relocate and generalize version release

- [x] 3.1 Move `openspec-release-version` to `ai-skills-create/ai-skills-release-version`, update its frontmatter and UI metadata, and remove the old path as part of the move; verify there is exactly one tracked release skill with the new name.
- [x] 3.2 Revise release instructions to require an existing template-compatible GitHub Actions workflow and `version.txt`, derive and apply the established version rule, and verify remote release results without requiring OpenSpec; verify missing or incompatible setup has an explicit no-mutation exit path.
- [x] 3.3 Update catalogs and OpenSpec documentation to remove the old OpenSpec release entry and present release after a pushed commit; verify no active documentation link targets the old release path.

## 4. Preserve installation and lifecycle behavior

- [x] 4.1 Update root documentation to link to the category catalogs and describe the expanded creation category; verify it remains standalone and contains no reference to external skill repositories.
- [x] 4.2 Extend relevant installation or lifecycle tests for the new `ai-skills-create-*` skills and category README files; verify the existing copy-lifecycle test suite passes unchanged behavior checks.

## 5. Run integrated validation

- [x] 5.1 Run focused validation for changed and new skill packages, catalog structural tests, and the copy-lifecycle suite; verify all commands pass and report any environment limitation.
- [x] 5.2 Run strict OpenSpec validation for `refactor-skill-catalog-and-creation-workflows`; verify proposal artifacts and spec deltas are valid before requesting implementation.
