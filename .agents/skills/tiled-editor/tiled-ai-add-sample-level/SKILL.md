---
name: tiled-ai-add-sample-level
description: Create a small Tiled AI sample level from one tileset with empty Objects, Wang-autotiled Walls when available, and a repeated Floor. Use when a project needs a fresh playable map or an end-to-end terrain test.
---

# Tiled AI Add Sample Level

Create a new, saved sample map through the live `tiled-ai` MCP. Accept one
tileset plus optional tile-grid and world dimensions. Defaults are 32×32 pixel
tiles and a 50×50-cell world. Never overwrite an existing map or tileset.

## Validate the inputs

- Require one open or supplied tileset. Inspect it with `list_tilesets`,
  `open_tileset`, or `inspect_tileset_image` rather than guessing its ID.
- If the caller omits dimensions, use 32×32 pixels and 50×50 cells. If a
  supplied tileset's grid differs, keep its grid and report that override.
- Require an explicit new `.tmx` destination. Ask before choosing a project
  default such as `output/tiled-ai-sample-level/Map.tmx`.
- Run `$tiled-ai-setup` first and call `get_editor_state`; stop if Tiled is not
  connected.

## Build the map

1. Use `create_map` with the chosen dimensions and an initial `Floor` tile
   layer. Attach the selected tileset with `attach_tileset`.
2. Create an empty `Objects` object layer and an empty `Walls` tile layer.
   Keep the order `Objects`, `Walls`, `Floor` from top to bottom; use the live
   layer IDs returned by the MCP rather than names alone.
3. Select a caller-supplied floor tile, or inspect the palette and choose one
   clearly designated base/floor tile. Fill all 50×50 default cells with it
   using `fill_region` or `set_tiles`. Do not choose a decorative, collision,
   or terrain-edge tile as the floor without confirmation.
4. Inspect `list_wang_sets` for the attached tileset. If a compatible Wang set
   and terrain color exist, paint a bounded perimeter or room footprint on
   `Walls` with `paint_terrain`. Use an irregular footprint only when the set
   supports every boundary it requires. If no compatible Wang data exists,
   leave `Walls` empty and report that autotiling was unavailable; do not fake
   it by manually picking edge tiles.
5. Verify the floor, empty Objects layer, Walls result, and layer order with
   `read_region`, `list_layers`, and `get_region_image`.
6. Re-read revisions after every mutation. Save the map with `save_map` and
   save the external tileset separately with `save_tileset` only if it changed.

Follow the shared [MCP editing contract](../references/tiled-ai-mcp.md).
