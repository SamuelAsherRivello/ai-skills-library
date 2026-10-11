# Spec Delta

## ADDED Requirements

### Requirement: Newly created apps and games use strict TypeScript throughout
Both creation workflows SHALL deliver authored application/game source, tests, executable JavaScript configuration, and JavaScript tooling as TypeScript or TSX with strict checking. Generated JavaScript, dependencies, and native shell orchestration SHALL remain permitted. This applies to custom or not-yet-migrated templates as well as the shared template.

#### Scenario: A JavaScript template is selected
- **WHEN** a creation workflow starts from a JavaScript or JSX starter
- **THEN** it migrates the copied project to strict TypeScript before completion
- **AND** it preserves upstream source and unrelated files

#### Scenario: A local-only application is requested
- **WHEN** the requested outcome excludes publishing
- **THEN** TypeScript source, test/tooling coverage, and verification are still required before local handoff
- **AND** publishing remains outside the authorized scope

### Requirement: Creation quality gates verify TypeScript coverage and behavior
Creation workflows SHALL verify all authored TypeScript is included in strict typechecking and reject remaining first-party JavaScript or blanket suppression workarounds. They SHALL run typechecking, meaningful tests, and the production build before declaring completion, retaining existing triage and browser verification requirements.

#### Scenario: A copied test remains JavaScript
- **WHEN** runtime source has migrated but a first-party test or executable JavaScript tool has not
- **THEN** the workflow does not claim TypeScript migration complete

#### Scenario: Browser testing is required
- **WHEN** the workflow verifies app behavior or WebGPU gameplay
- **THEN** it uses headless or minimized automation without taking focus
- **AND** TypeScript success alone does not substitute for behavior verification

### Requirement: Multiplayer creation checks the published client types
Multiplayer game creation SHALL verify the exact released client artifact supplies compatible declarations for the used public exports. It SHALL preserve the required server-first workflow and Vercel Hobby constraint. An untyped legacy artifact SHALL NOT be hidden behind blanket local declarations or treated as verified TypeScript support.

#### Scenario: The released artifact has no usable declarations
- **WHEN** the selected client release is untyped or its declarations do not resolve
- **THEN** the workflow prepares the compatible upstream typing work within the multiplayer workflow or reports its specific blocker
- **AND** it does not falsely claim typed integration or bypass the free hosting requirement
