# Spec Delta

## MODIFIED Requirements

### Requirement: Each skill category has a standalone catalog
The library SHALL provide a `README.md` at `.agents/skills/` and at each
established category directory. Each catalog SHALL state its scope and link to
every skill it covers with an original concise description. When a maintained
skill is renamed, the catalog SHALL link only to the new canonical skill name.

#### Scenario: User browses a category
- **WHEN** a user opens a category catalog
- **THEN** the user can identify the category purpose and navigate directly to
  each contained skill without consulting an external skill repository

#### Scenario: User finds tileset autotiling
- **WHEN** a user opens the Tiled-editor category catalog
- **THEN** it links to `tiled-ai-add-tileset-autotiling` as the canonical
  workflow for adding Wang metadata to an existing tileset
