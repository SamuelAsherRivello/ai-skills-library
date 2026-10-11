# typescript-project-baselines Specification

## Purpose

Provides strict TypeScript authoring and verification contracts for the shared repository template and multiplayer backend, including their tests, executable tooling, and downstream client package.

## Requirements

### Requirement: Upstream repositories author executable JavaScript surfaces in TypeScript
The template and multiplayer repositories SHALL author runtime modules, React components, tests, executable JavaScript configuration, and JavaScript tooling in TypeScript or TSX. Generated JavaScript artifacts and third-party code SHALL remain permitted. Existing shell orchestration SHALL remain in its native language.

#### Scenario: Authored source inventory is verified
- **WHEN** either repository runs its source inventory check
- **THEN** an authored JavaScript or JSX runtime, test, configuration, or tooling file fails verification
- **AND** generated output, dependencies, and explicitly identified external fixtures are excluded without excluding first-party implementation

#### Scenario: A workflow contains executable JavaScript
- **WHEN** a workflow currently embeds release or deployment logic as JavaScript
- **THEN** that logic is moved to a typechecked TypeScript script and the workflow invokes it

### Requirement: Strict verification covers all authored TypeScript
Each repository SHALL provide a failing-on-error typecheck covering all authored TypeScript runtime code, tests, configuration, and tooling. Browser and Node environments SHALL use compatible declarations without leaking Node-only APIs into browser consumers. Blanket suppressions and unchecked JavaScript SHALL NOT satisfy this contract.

#### Scenario: A test or probe contains a type error
- **WHEN** an incompatible assignment is introduced into a test or deployment probe
- **THEN** the documented typecheck command fails even if runtime source still typechecks

#### Scenario: An orphan TypeScript file is added
- **WHEN** a new first-party TypeScript file is outside every compiler configuration
- **THEN** source-coverage verification fails

### Requirement: Template consumers inherit the verified TypeScript baseline
Projects generated from the template SHALL inherit working TypeScript source, commands, configuration, and blocking CI verification. Migration SHALL preserve documented template layout, renderer, controls, presentation, and Pages behavior.

#### Scenario: A template copy is customized
- **WHEN** the application directory and repository metadata are renamed for a new app or game
- **THEN** typechecking, tests, production build, and Pages asset paths remain valid for the customized project

### Requirement: Shared multiplayer package exposes checked runtime and type contracts
Every supported shared-client export SHALL resolve to compiled browser-safe ESM JavaScript and generated TypeScript declarations. Public runtime imports, release tarball naming, game identifiers, messages, state behavior, and JavaScript consumer compatibility SHALL be preserved.

#### Scenario: A clean TypeScript consumer installs the tarball
- **WHEN** a consumer installs the packed artifact without access to the source checkout
- **THEN** every documented export resolves with its generated declarations under supported browser and Node resolution modes
- **AND** invalid calls fail compile-time contract tests

#### Scenario: An existing JavaScript consumer uses the new package
- **WHEN** a JavaScript consumer imports supported entry points from the packed artifact
- **THEN** imports and existing runtime behavior remain compatible without requiring a TypeScript loader

### Requirement: Delivery gates enforce type safety and deployment compatibility
Applicable verification, build, packaging, and release/deployment workflows SHALL block on source coverage, strict typechecking, and existing regressions. The migration SHALL preserve free Vercel Hobby hosting and its bounded-session behavior without adding hosting services or paid dependencies.

#### Scenario: Type verification fails before delivery
- **WHEN** source coverage or typechecking fails
- **THEN** a new artifact cannot pass its build or publication/deployment gate

#### Scenario: A migrated backend is staged
- **WHEN** deployment is explicitly authorized after implementation
- **THEN** staged and stable checks verify the intended version, compatible game-specific two-client behavior, and the documented bounded-session probe before publication
- **AND** failure follows the existing rollback path without suggesting another host
