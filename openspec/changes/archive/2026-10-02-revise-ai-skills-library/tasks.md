# Tasks

## 1. Copy lifecycle commands

- [x] 1.1 Rewrite push to copy one named global skill or explicitly selected `all` into the local library, validate and preflight the complete request before writes, and report changed, skipped, and failed skills; verify its instructions cover the push scenarios in the delta spec.
- [x] 1.2 Rewrite pull to copy one named library skill or explicitly selected `all` into global skills, validate and preflight the complete request before writes, and report changed, skipped, and failed skills; verify its instructions cover the pull scenarios in the delta spec.
- [x] 1.3 Add promote and demote skills for one named skill each, with copy-only behavior, source validation, conflict handling, and separate outcome reporting; verify their instructions cover both transfer scenarios in the delta spec.
- [x] 1.4 Add tests or an executable validation approach for lifecycle safety and copy behavior, and verify it covers all documented transfer directions, conflicts, and no-partial-change preflight.

## 2. Documentation and migration

- [x] 2.1 Revise library update and welcome guidance and the README/global installation documentation to explain separate project, global, and library copies, the four commands, and the retirement of link-based installation; verify no installation instructions direct users to junctions or symbolic links.
- [x] 2.2 Update the skill movement diagram and command reference to show copy directions and command selection; verify referenced diagram and command names match the implemented skills.

## 3. Integration verification

- [x] 3.1 Validate the active OpenSpec change strictly and verify every delta requirement has matching command guidance, documentation, and verification evidence.
