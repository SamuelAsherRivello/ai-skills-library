# Spec Delta

## Purpose

Makes the library's existing categorized skills directly discoverable through
standalone, maintained category catalogs and workflow guidance.

## ADDED Requirements

### Requirement: Each skill category has a standalone catalog
The library SHALL provide a `README.md` at `.agents/skills/` and at each
established category directory. Each catalog SHALL state its scope and link to
every skill it covers with an original concise description.

#### Scenario: User browses a category
- **WHEN** a user opens a category catalog
- **THEN** the user can identify the category purpose and navigate directly to
  each contained skill without consulting an external skill repository

### Requirement: Catalogs explain invocation roles
Each category catalog SHALL distinguish explicit user workflows from skills
that can be reached by the model when that distinction affects selection or
safety. The root catalog SHALL link to each category catalog.

#### Scenario: User chooses a workflow
- **WHEN** a user reviews a category catalog before invoking a skill
- **THEN** the catalog communicates whether the workflow is intentionally
  explicit or may be selected for a matching task

### Requirement: The OpenSpec catalog presents a suggested flow
The OpenSpec category catalog SHALL present a non-mandatory order that separates
optional discovery and planning from implementation and finalization. It SHALL
show that release work is a separate creation-category workflow after a remote
commit is available.

#### Scenario: User follows the OpenSpec catalog
- **WHEN** a user consults the OpenSpec catalog for a typical change
- **THEN** the user sees optional exploration and interviewing, proposal and
  revision, application, specification sync, archive, and commit/push stages
  without treating the order as mandatory
