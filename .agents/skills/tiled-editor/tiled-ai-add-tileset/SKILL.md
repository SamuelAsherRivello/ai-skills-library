---
name: tiled-ai-add-tileset
description: Add one or more supplied tile-sheet images to an existing Tiled-authored game, including external tileset files, map palette references, compatible collision metadata, runtime loading, tests, and an exact editor handoff. Use for expanding the tiles available for painting; not for adding independently placeable object sprites or animated characters.
---

# Tiled AI Add Tileset

## Tiled AI MCP requirement

Run `$tiled-ai-setup` first. Use `inspect_tileset_image`,
`create_tileset_from_image`, and `attach_tileset` through the live `tiled-ai`
MCP; inspect the resulting palette and explicitly save its external tileset
and each changed map. Follow the shared
[MCP editing contract](../references/tiled-ai-mcp.md).

Integrate each supplied tile sheet so the human can open the existing map in Tiled, paint with the new palette, save, and run the game. The AI owns file placement, `.tsj` creation, map references, runtime compatibility, and verification.

## Inspect before changing files

1. Find the repository's map, external tileset, source-image, runtime-loader, test, and documentation conventions. Do not impose paths from another project.
2. Inspect the image dimensions and transparency. Determine the intended tile width, height, margin, spacing, columns, rows, and tile count from the sheet and nearby assets. Require an integral grid; do not silently crop pixels.
3. Compare the sheet's layout and tile meanings with existing tilesets, not merely its colors or filename. A palette variant with the same cell layout can usually reuse collision metadata by tile ID. Similar-looking artwork with different semantics cannot.
4. Determine which maps should expose the new palette and whether adding it requires runtime texture registration or loader changes.

## Confirm collision reuse when applicable

When the sheet appears structurally equivalent to an existing terrain sheet, pause before mutation and ask a concrete question such as:

> This looks like a palette variant of `ExistingTerrain`: the image grid and tile layout match. Should I set it up the same way and copy its per-tile colliders? Yes or no?

State the evidence for the match. Ask once for a group of equivalent sheets when the same answer clearly applies to all of them.

- If yes, copy only metadata that is valid by corresponding local tile ID, especially each tile's `objectgroup`. Keep the new image path and tileset name.
- If no, create the tileset without invented collision geometry. Explain that collision objects can be drawn or edited in Tiled's Tileset Editor and will affect every painted use of that tile.
- If the layout does not match, do not offer blind collider copying. Either derive geometry from an explicit user rule or leave it for authoring.

## Create the external tileset

- Preserve the supplied image bytes unless conversion is required and approved. Put the image beside the project's comparable tile-sheet assets with a stable, collision-free filename.
- Create one external JSON tileset (`.tsj`) per source sheet. Default the tileset name and filename to the image basename.
- Use relative, forward-slash image references from the `.tsj`. Include accurate image dimensions, grid dimensions, margin, spacing, columns, tile count, Tiled format version, and any established project properties.
- Treat the `.tsj` as the authoritative source for tile collision geometry. Preserve all supported collision objects on a tile; do not reduce multiple shapes to the first shape.
- Prefer Tiled-authored rectangles and polygons already supported by the runtime. Do not claim unsupported ellipses, rotations, polylines, or tile transformations work without checking and extending the adapter.

## Add it to maps without disturbing painted content

- Add an external tileset reference to each requested `.tmj` using the path convention already present.
- Append it after existing tilesets and calculate a non-overlapping `firstgid` from the prior tileset's range. Do not renumber existing GIDs or repaint existing layers merely to expose a new palette.
- Preserve layer order, layer names, map origin rules, object data, and all existing tile data.
- Remember that a map stores global tile IDs, while collision definitions live on local tile IDs in the referenced `.tsj`.

## Keep runtime behavior data-driven

- Use the repository's existing Tiled adapter or plugin when it supports the format. Extend that reusable boundary only when the new tileset exposes a real unsupported case.
- Resolve every map tileset by `firstgid`, load its external `.tsj`, and resolve its image relative to the tileset file. Avoid a new hard-coded texture switch for each filename.
- A collision edited in a referenced `.tsj` must apply to all existing painted instances after reload; repainting the map must not be required.
- Preserve existing world-coordinate and origin conventions. Adding a palette must not move the level or change camera behavior.

## Verify the integration

Check at least these observable invariants:

- Every JSON file parses and every relative source/image path resolves with exact filename casing.
- Sheet dimensions equal the declared grid, and tile ranges do not overlap.
- Existing map layer data and existing `firstgid` values remain unchanged.
- Normalization resolves a tile from each added tileset to the correct image and local tile ID.
- Collision-reuse tests prove representative copied shapes match the source by local tile ID, including multiple shapes on one tile when present.
- A collision-only `.tsj` edit changes runtime collider output without repainting the map.
- The focused tests, full test suite, and production build pass. When practical, load the game and inspect browser errors and visible rendering.

If the project has a collider-debug display, use it for runtime verification. Distinguish "the tileset contains colliders" from "the current map paints a tile that uses those colliders."

## Hand off to the human

Finish with exact, clickable paths and a short workflow:

1. Open the named `.tmj` map in Tiled, not the `.tsj`, for level painting.
2. Select the new tileset in the Tilesets panel and paint only on the intended existing layer(s).
3. Save the map. Open the `.tsj` separately only to edit per-tile collision shapes, then save it.
4. Reload or restart the game and play the result. A hard refresh may be needed if the development server or browser cached JSON.

Describe the final folder structure and state whether collision metadata was copied, newly authored, or intentionally left empty. For multiple supplied sheets, repeat the same validated operation and report each basename-to-tileset mapping.
