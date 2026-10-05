# Spec Delta

## MODIFIED Requirements

### Requirement: Each skill category has a standalone catalog
The library SHALL provide a `README.md` at `.agents/skills/` and at each
established category directory, including `tiled-editor`. Each catalog SHALL
state its scope and link to every skill it covers with an original concise
description.

#### Scenario: User browses a category
- **WHEN** a user opens a category catalog
- **THEN** the user can identify the category purpose and navigate directly to
  each contained skill without consulting an external skill repository
