# Proposal

## Why

The Tiled skills previously treated wall art as the terrain being painted,
which produces incomplete or incorrectly oriented dungeon boundaries. A live
Dungeon fixture established that its Wang set represents the walkable floor
region: its boundary cells render wall art automatically.

## What Changes

- Separate PNG-to-TSX conversion from adding autotiling semantics.
- **BREAKING**: replace `tiled-ai-configure-autotiling` with
  `tiled-ai-add-tileset-autotiling`.
- Define a fitness result for each exact tileset and require a rendered
  coverage fixture before it is declared Wang-ready.
- Make the default Figure 8 paint a supported walkable footprint, with a
  two-cell connector and inner loop, rather than manually assembling wall
  strokes.
- Update the sample-level workflow and Tiled MCP contract to consume the new
  capability.

## Capabilities

### New Capabilities

- `tiled-tileset-autotiling`: Convert a verified external Tiled tileset into
  an explicitly scoped, rendered-and-tested Wang autotiling asset.

### Modified Capabilities

- `skill-catalog-navigation`: Expose the renamed autotiling skill in the
  Tiled-editor catalog.

## Impact

Changes are scoped to `.agents/skills/tiled-editor/`, its catalog and shared
MCP contract, plus an output-only Tiled fixture. The `tiled-ai` MCP remains
the required live editor bridge; no runtime game integration is added.
