# Spec Delta

## Purpose

Defines a discoverable library category for specialized Tiled editor skills and
keeps the community MCP companion distinct from the library-owned workflows.

## ADDED Requirements

### Requirement: Tiled editor skills have a dedicated categorized collection
The library SHALL provide a `tiled-editor` category containing maintained,
independently installable skill directories for setup, character, object,
pickup, spawner, tileset, collider-copy, collider-update, and sample-level
authoring workflows.

#### Scenario: User browses the Tiled editor collection
- **WHEN** a user opens the `tiled-editor` category catalog
- **THEN** the user can navigate to each maintained Tiled authoring and setup
  skill and identify its distinct purpose

### Requirement: Library-owned Tiled authoring skills use a stable namespace
The imported and new library-owned skills SHALL be named with the `tiled-ai-`
prefix, presented with a `Tiled AI` UI label, and retain their distinct
authoring responsibilities and supporting resources.

#### Scenario: User installs a specialized authoring skill
- **WHEN** a user selects a Tiled character, object, pickup, spawner, tileset,
  or collider workflow from the library
- **THEN** the installed skill has a `tiled-ai-`-prefixed name and retains the
  workflow resources required by that skill

### Requirement: Tiled AI MCP is verified before authoring
Each Tiled AI authoring skill SHALL require the selected `rpgjs/tiled-ai` MCP
to be registered and connected to an open Tiled editor session before it edits
a map or tileset. The category SHALL provide `tiled-ai-setup` to verify this
dependency chain and diagnose the first unmet prerequisite.

#### Scenario: A prerequisite is missing
- **WHEN** a user runs the setup skill and a required runtime, bridge,
  extension, MCP registration, or editor connection is unavailable
- **THEN** the skill stops before a smoke test, identifies that prerequisite,
  and gives the smallest corrective action

#### Scenario: A ready setup is tested
- **WHEN** every prerequisite is available and the user has connected Tiled
- **THEN** the setup skill verifies the live session through the MCP and
  reports a passing result
