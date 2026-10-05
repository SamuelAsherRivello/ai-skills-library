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
3. Use exactly the selected tileset for the entire first iteration: select one
   caller-supplied or clearly designated base/floor tile and fill all 50×50
   default cells with it using `fill_region` or `set_tiles`. Use the same
   tileset's Wang set for Walls. Do not attach, mix, or infer a second tileset.
   Do not choose a decorative, collision, or terrain-edge tile as the floor
   without confirmation.
4. Inspect `list_wang_sets` for the attached tileset. If a compatible Wang set
   and terrain color exist, use the default **Figure 8** footprint on `Walls`
   with `paint_terrain`, unless the caller supplies a different layout:
   - Fill the entire map with the repeated Floor tile first; there is no
     exterior void in the default sample.
   - Left lobe: place a centred 10×10 **outer** wall loop around an 8×8
     walkable room. Cut a two-cell doorway only where the connector enters.
   - Connector: retain a two-cell-wide Floor corridor between lobes and paint
     its top and bottom wall boundaries from the same Wang terrain.
   - Right lobe: place a centred 10×10 **inner** demonstration: an outer wall
     loop with a two-cell doorway to the connector, plus a centred 4×4 blocked
     core. The two-cell-wide Floor band between them is the walkable inner
     loop. Paint every wall cell with the same Wang terrain.
   Use an irregular footprint only when the set supports every required outer
   and inner boundary. If no compatible Wang data exists, leave `Walls` empty
   and report that autotiling was unavailable; do not fake it by manually
   picking edge tiles.
5. Verify the floor, empty Objects layer, Walls result, and layer order with
   `read_region`, `list_layers`, and `get_region_image`.
6. Re-read revisions after every mutation. Save the map with `save_map` and
   save the external tileset separately with `save_tileset` only if it changed.

Follow the shared [MCP editing contract](../references/tiled-ai-mcp.md).
