# Spec Delta

## MODIFIED Requirements

### Requirement: Categorized library skills are discoverable by the installer
Each skill SHALL remain a self-contained directory with a `SKILL.md` under one
of the documented `ai-skills-create`, `ai-skills-library`, `openspec`, or
`docker-sandbox` categories. Each category SHALL provide a catalog README that
documents its contained skills without changing their installer-facing names or
paths, and the documented installer SHALL discover skills in those categories.
The Blender repository SHALL remain a separate repository with its own
`skills/` source tree.

#### Scenario: User selects a skill from a category
- **WHEN** a user runs the documented installer against the library
- **THEN** skills from all four categories are available for selection by
  their skill names

#### Scenario: User reads a category catalog
- **WHEN** a user opens a catalog README under the library skill tree
- **THEN** the catalog links to the self-contained skills in that category
  without changing how the installer discovers them
