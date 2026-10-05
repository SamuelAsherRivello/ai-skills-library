---
name: tiled-ai-add-tileset
description: Convert supplied tile-sheet art into a saved external Tiled TSX through the live Tiled AI MCP. Use before adding autotiling, colliders, or map palette references.
---

# Tiled AI Add Tileset

Convert an image into one inspected, saved external `.tsx` tileset. This skill
does not infer autotiling, collision, map placement, or game-runtime behavior:
use the dedicated follow-up skill for each of those concerns.

## Convert the art

1. Run `$tiled-ai-setup`, then inspect the supplied image through
   `inspect_tileset_image`. Determine the intended tile width, height, margin,
   spacing, columns, rows, and transparency from the actual pixels. Image
   divisibility is only a candidate grid, not proof.
2. Create a collision-free external `.tsx` with
   `create_tileset_from_image`. Use a stable user-supplied or project-local
   destination, never overwrite an existing file, and preserve the generated
   relative image reference.
3. Inspect the open TSX using `get_map_info` and all required pages of
   `get_tileset_images`. Verify the grid, tile count, and imported image match
   the source before saving it with `save_tileset`.
4. Do not attach the result to a map, write colliders, or add Wang metadata in
   this workflow. Route follow-up requests explicitly:
   - `$tiled-ai-add-tileset-autotiling` for Wang terrain metadata and a
     Figure 8 fitness proof.
   - `$tiled-ai-copy-tileset-colliders` or
     `$tiled-ai-update-tileset-colliders` for collision geometry.

Follow the shared [MCP editing contract](../references/tiled-ai-mcp.md).

## Result Links

Finish with clickable links to the saved TSX and its MCP-imported source image.
Report the verified grid and tile count. Do not claim that converted art is
autotile-ready until `$tiled-ai-add-tileset-autotiling` has passed.
