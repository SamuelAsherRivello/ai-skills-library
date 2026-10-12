# Spec Delta

## MODIFIED Requirements

### Requirement: The OpenSpec catalog presents a suggested flow
The OpenSpec category catalog SHALL present a non-mandatory order that separates
optional discovery and planning from implementation and finalization. It SHALL
show that release work is a separate creation-category workflow after a remote
commit is available. It SHALL list the OpenSpec orchestration workflow and
distinguish its project-coordination role from the normal single-change flow.

#### Scenario: User follows the OpenSpec catalog
- **WHEN** a user consults the OpenSpec catalog for a typical change
- **THEN** the user sees optional exploration and interviewing, proposal and
  revision, application, specification sync, archive, and commit/push stages
  without treating the order as mandatory

#### Scenario: User needs project coordination
- **WHEN** a user consults the OpenSpec catalog for coordination across project
  chats
- **THEN** the user can identify the orchestration workflow and its distinct
  coordination purpose
