# creation-quality-gates Specification

## Purpose

Ensures repositories produced by the application and game creation workflows
start with clear AI-facing guidance, meaningful architectural seams, and
evidence-backed triage results rather than requiring cleanup after creation.

## Requirements

### Requirement: Creation workflows SHALL establish triage-ready repository evidence

Each application or game creation workflow SHALL establish discoverable
repository instructions, verified command guidance, project orientation,
definition-of-done expectations, maintenance relationships, and safety
boundaries before final delivery.

#### Scenario: Newly created application is delivered
- **WHEN** the application creation workflow reaches its delivery stage
- **THEN** the repository contains evidence for the applicable AI-readiness
  areas and the final report links to that evidence

#### Scenario: Newly created game is delivered
- **WHEN** the game creation workflow reaches its delivery stage
- **THEN** the repository documents its runtime boundaries, game entry points,
  verification commands, controls, release expectations, and safety limits

### Requirement: Creation workflows SHALL run an evidence-backed final analysis

The workflows SHALL run `ai-skills-triage-analyze` after implementation and applicable
safe conformity work, preserve its packet in the repository's required triage
location, and report the resulting Standardization and Architecture scores.

#### Scenario: Final analysis succeeds
- **WHEN** all required creation checks complete
- **THEN** the workflow produces a final triage packet and reports its location,
  scores, verification evidence, and known limitations

#### Scenario: Analysis identifies unresolved architecture work
- **WHEN** final analysis identifies a material module, contract, dependency,
  ownership, state, or communication issue
- **THEN** the workflow records it as a deferred follow-up and points to
  `ai-skills-triage-rearchitect` without applying an unapproved structural refactor

### Requirement: Creation workflows SHALL preserve product-specific architecture seams

The workflows SHALL create or maintain independently testable product logic
and explicit boundaries between presentation or transport adapters and the
application or game behavior they invoke.

#### Scenario: Application behavior is tested without presentation
- **WHEN** an application feature has domain or application behavior
- **THEN** that behavior has a meaningful test seam that does not require
  rendering the full browser interface

#### Scenario: Game rules are tested without rendering or input
- **WHEN** a game contains rules, scoring, progression, or state transitions
- **THEN** those behaviors can be tested independently of Babylon rendering and
  browser input where the mechanic makes that separation meaningful

### Requirement: Safe standardization SHALL be separated from rearchitecture

The creation workflows SHALL use `ai-skills-triage-standardize` only for bounded,
behavior-preserving conformity work and SHALL not use it to change module
ownership, public contracts, dependency direction, state ownership, or
inter-module communication.

#### Scenario: Safe gap is found
- **WHEN** analysis identifies a missing command, orientation document, naming
  convention, or other low-risk conformity item
- **THEN** the workflow may apply and verify that item through the standardize
  path before final analysis

#### Scenario: Structural candidate is found
- **WHEN** analysis identifies a structural architecture candidate
- **THEN** the workflow defers it to the explicitly invoked rearchitect process
  and does not silently introduce a broad refactor

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
