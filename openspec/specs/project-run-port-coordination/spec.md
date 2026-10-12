# project-run-port-coordination Specification

## Purpose
Provides a shared, agent-agnostic contract for assigning local development
ports across multiple projects without serving one project's application at
another project's expected URL.

## Requirements

### Requirement: Document the shared port configuration contract

The Run skill family SHALL provide a reference document under the reusable
`.agents/skills/ai-skills-run/` skill tree that defines project declarations,
valid TCP-port ranges, defaults, and conflict behavior.

#### Scenario: Agent reads the Run configuration reference
- **WHEN** an agent starts, stops, or inspects a local project server
- **THEN** it can locate one shared reference that explains how to interpret a
  project's declared range and how to handle missing or invalid declarations

### Requirement: Support an optional agent-agnostic project declaration

The Run skills SHALL recognize an optional project-local declaration at
`.agents/project-run-configuration.md`; a project without that declaration
SHALL remain runnable using the documented default range and SHALL be reported
as having no explicit port preference.

#### Scenario: Project declares a valid range
- **WHEN** the declaration contains a valid preferred port and inclusive range
- **THEN** Start uses that preference and does not select a port outside the
  declared range

#### Scenario: Project has no declaration
- **WHEN** the project has no project-local port declaration
- **THEN** Start uses the shared default policy and Status recommends declaring
  a range without treating the project as invalid

#### Scenario: Project declaration is invalid
- **WHEN** the declaration contains malformed, reversed, or out-of-bounds
  values
- **THEN** the skill reports the validation error and does not silently widen
  or reinterpret the requested range

### Requirement: Keep startup within the selected project range

Start SHALL probe the preferred port and safe fallback candidates only within
the selected project's effective range, preserving verified project ownership
and leaving unrelated listeners untouched.

#### Scenario: Preferred port is occupied by another project
- **WHEN** the preferred port is listening for another verified project
- **THEN** Start preserves that server and selects the first usable port within
  the current project's effective range

#### Scenario: Effective range is exhausted
- **WHEN** every candidate in the effective range is unavailable or unsafe
- **THEN** Start reports range exhaustion and does not fall back to an
  undeclared port

### Requirement: Reconcile all visible project declarations and listeners

Status SHALL support an all-projects view that groups development processes by
verified project root and reports each declaration, active port, ownership
evidence, overlapping ranges, occupied candidates, and missing declarations.

#### Scenario: Two projects declare overlapping ranges
- **WHEN** Status discovers two verified project roots whose declarations
  overlap
- **THEN** it reports the overlap and the active ports without stopping or
  reconfiguring either project

#### Scenario: A listener belongs to an undeclared project
- **WHEN** Status identifies a development listener whose project root has no
  declaration
- **THEN** it reports the listener using ownership evidence and recommends a
  project declaration

### Requirement: Bound cross-project configuration edits by one approval

The Run workflow SHALL be able to present a reconciliation plan listing the
identified project documents and proposed range changes, and one user approval
SHALL authorize the complete identified set for that reconciliation only.

#### Scenario: User approves a reconciliation plan
- **WHEN** the user approves a plan naming the affected project documents and
  proposed non-overlapping ranges
- **THEN** the agent may update those named documents, re-read them, and verify
  that each resulting declaration is valid

#### Scenario: User does not approve the plan
- **WHEN** the user declines or does not authorize the proposed edits
- **THEN** the workflow leaves project documents unchanged and reports the
  conflicts for manual resolution

### Requirement: Preserve lifecycle ownership safety

Stop and Status SHALL identify development servers from project-root command
context, validated run records, and process relationships rather than port
numbers alone; port-range coordination SHALL NOT authorize killing or replacing
an unrelated listener.

#### Scenario: Port is occupied by an unrelated process
- **WHEN** a candidate port is listening but cannot be associated with a
  project development process
- **THEN** the workflow preserves the listener and classifies the candidate as
  occupied by an unrelated process
