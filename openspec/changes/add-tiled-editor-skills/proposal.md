# Proposal

## Why

The library has seven reusable Tiled authoring skills only in the global skills
directory, so they cannot be discovered, reviewed, or installed from the shared
catalog. They should be collected into a dedicated category, use the verified
Tiled AI MCP bridge, and include a setup skill that makes its prerequisites
testable.

## What Changes

- Add a `tiled-editor` skill category to the library catalog.
- Import the seven existing global Tiled-editor skills into that category and
  rename the maintained library copies with the `tiled-ai-` prefix:
  `add-character`, `add-object`, `add-pickup-object`, `add-spawner`,
  `add-tileset`, `copy-tileset-colliders`, and `update-tileset-colliders`.
- Preserve each skill's supporting scripts and references when importing it.
- Add category and root-catalog documentation for the new skills.
- Extend the library lifecycle tooling to recognize `tiled-editor` as a valid
  category for push and pull operations.
- Select the tested `rpgjs/tiled-ai` bridge as the required MCP companion and
  rewrite the eight library-owned workflows to operate through it.
- Add `tiled-ai-setup`, a step-by-step setup and verification skill that stops
  at the first unmet prerequisite with its smallest remediation.
- Add `tiled-ai-add-sample-level`, which creates a grid- and world-size
  configurable sample map with `Objects`, `Walls`, and `Floor` layers.

## Capabilities

### New Capabilities

- `tiled-editor-skill-catalog`: A categorized, installable collection of
  specialized Tiled editor authoring skills with a separately identifiable MCP
  companion slot.

### Modified Capabilities

- `skill-catalog-navigation`: The root catalog must expose the new
  Tiled-editor category and its skills.
- `skill-copy-lifecycle`: Lifecycle commands must recognize the new category
  while retaining their existing source-preservation and conflict protections.

## Impact

Affected areas are `.agents/skills/` catalogs and skill directories, the
`scripts/skill-copy-lifecycle.ps1` category resolver, and their associated
tests or verification. Global skill sources remain unchanged by the
library-checkout import until the validated renamed copies are installed
globally. The migration then removes only the seven superseded global
`tiled-editor-*` directories. The bridge is documented as a required external
dependency; this change does not vendor the bridge or modify its installation.
