---
name: tiled-ai-add-tileset-autotiling
description: Add and verify Wang autotiling metadata on one existing Tiled tileset through the live Tiled AI MCP. Use after art has already been converted into an external tileset.
---

# Tiled AI Add Tileset Autotiling

Turn one existing external tileset into a **verified** Wang-autotiling
tileset. This skill authors metadata; `$tiled-ai-add-tileset` is responsible
for turning a source image into the external TSX first.

## Inspect and classify

- Run `$tiled-ai-setup`, identify the exact open TSX with
  `get_editor_state`, then inspect it with `get_map_info`, `list_wang_sets`,
  and all pages of `get_tileset_images`. Never copy tile IDs from another
  tileset, even when both use the same image layout.
- Use an explicit reference block in the art, a companion key, an existing
  correct map, or a documented source profile to establish *every* Wang ID.
  Do not infer a profile from image dimensions, a filename, a familiar visual
  style, or the apparent colour of pixels. A rendered test, not the preview,
  establishes fitness.
- Classify the **matching topology**, not the subject matter of the artwork:
  - An **edge** set has values only at indices `0, 2, 4, 6`; it suits paths,
    fences, rails, and other side-connected features. Two edge colours require
    all 16 combinations for unrestricted painting.
  - A **corner** set has values only at `1, 3, 5, 7`; it suits patches and
    terrain transitions. Two corner colours require all 16 combinations;
    three corner colours require 81 for unrestricted painting.
  - A **mixed** set has both kinds of values. A two-colour mixed set is 256
    masks when complete. Reduced mixed sets are valid only for the explicitly
    identified family of masks they contain.
- For each candidate tile, record the eight samples in Tiled's clockwise order
  `N, NE, E, SE, S, SW, W, NW`. Keep the mapping as a table of **local tile
  ID -> eight values**. There is no safe visual shortcut for a facing, a
  concavity, or an asymmetric decorative tile.
- Treat duplicate art as a variant only when it has the exact same eight-value
  signature. It can make selection non-deterministic; it does not fill a
  missing mask. A rotated-looking tile is still a different local tile and
  needs its own explicit assignment. Do not rely on an editor transform to
  invent it.
- Report one of these outcomes:
  - **Wang-ready**: the requested fixture paints and renders with no missing,
    blank, wrong-facing, or broken cells.
  - **Limited Wang-ready**: a named footprint family works, but a required
    mask is absent. State the missing Wang IDs and reject wider requests.
  - **Not Wang-ready**: no unambiguous tile-role mapping or viable fixture.
    Do not write guessed metadata.

## Reference profile: canonical 47-tile Blob

The public Stagecast Blob sheets are a reliable *reference profile*, not a
generic rule for every 7x7 image. They demonstrate a reduced two-edge /
two-corner mixed set with 47 masks rather than the 256 masks of a complete
two-colour mixed set. The linked `wangbl.png` is labelled, and its Dungeon,
Trench, Islands, Commune, and Bridge sheets use the same role layout with
different artwork.

- The profile paints one region colour. The contrasting background is **unset
  (`0`)**, not a second Wang colour. Do not create two colours just because the
  artwork visibly contains two materials.
- For a labelled canonical sheet, let `m` be its printed decimal mask. Bit
  weights are exactly `N=1, NE=2, E=4, SE=8, S=16, SW=32, W=64, NW=128`, so
  map it mechanically with `wangid[i] = 1 if (m & (1 << i)) else 0`. Use the
  actual colour ID returned by Tiled in place of `1` when authoring.
- Its allowed mask set is:

  ```text
  0, 1, 4, 5, 7, 16, 17, 20, 21, 23, 28, 29, 31,
  64, 65, 68, 69, 71, 80, 81, 84, 85, 87, 92, 93, 95,
  112, 113, 116, 117, 119, 124, 125, 127,
  193, 197, 199, 209, 213, 215, 221, 223,
  241, 245, 247, 253, 255
  ```

  The 7x7 packing has 49 cells because mask `0` appears three times; the 6x8
  packing has one duplicate `255`. Map every duplicate to its same mask; do
  not mistake the packing extras for new terrain roles.
- A quick corroboration (not a substitute for the labelled source) is the
  Blob invariant: for each side, a filled corner on either end requires the
  intervening edge to be filled. Equivalently, an unset edge must have both
  adjacent corners unset. This produces outer and inner corners while keeping
  a connected central fill. It is deliberately directional: the profile can
  draw the designated blob material over its background, but not the inverse.
- Use this profile only after confirming the exact source identity or a
  pixel-for-pixel/role-for-role companion reference. A merely similar 7x7
  sheet is **Not Wang-ready** until its own tile-to-mask key is supplied.

Sources for this profile: [Stagecast Blob reference](https://www.boristhebrave.com/permanent/24/06/cr31/stagecast/wang/blob.html),
[labelled Blob variants](https://www.boristhebrave.com/permanent/24/06/cr31/stagecast/wang/blob_g.html), and
[Tiled terrain-set documentation](https://doc.mapeditor.org/en/stable/manual/terrain/).

## Author the terrain set

1. Create or update one `edge`, `corner`, or `mixed` Wang set from the source
   art. Keep the eight-index order used by Tiled: top, top-right, right,
   bottom-right, bottom, bottom-left, left, top-left. A tile may have one
   assignment; variants may share an assignment. Use `mixed` whenever the
   requested topology needs both side and diagonal information, including an
   inner void whose diagonal corner cells are indistinguishable from ordinary
   floor in an edge-only set.
2. Name each colour for the **region that will be painted**. Do not label an
   edge set "wall" merely because its boundary tiles draw walls.
3. A common room-frame sheet uses a single `Walkable floor` edge colour. Its
   paint footprint includes the visual boundary cells; Tiled selects outer
   wall/corner art at that footprint's boundary and a repeated floor tile in
   its interior. For this pattern, a separate repeated `Floor` map layer may
   sit underneath the generated `Walls` renderer layer.
4. Derive all assignments from a complete source reference block. Use a
   mechanical profile mapping when the source provides one; otherwise build a
   reviewed local-ID table before editing. Do not assign a tile whose mask is
   ambiguous, and do not silently omit a mask the requested fixture needs.
   For the observed Dungeon Figure 8 **limited** profile, use one `Walkable
   floor` colour and these mixed-set assignments (the array is in Tiled's
   eight-index order):

   ```text
   0:  [0,0,1,1,1,0,0,0]  1:  [0,0,1,1,1,1,1,0]
   5:  [0,0,0,0,1,1,1,0] 12: [1,1,1,1,1,0,0,0]
   13: [1,1,1,1,1,1,1,1] 17: [1,0,0,0,1,1,1,1]
   48: [1,1,1,0,0,0,0,0] 49: [1,1,1,0,0,0,1,1]
   53: [1,0,0,0,0,0,1,1] 6:  [1,1,1,0,1,1,1,1]
   8:  [1,1,1,1,1,0,1,1] 30: [1,0,1,1,1,1,1,1]
   32: [1,1,1,1,1,1,1,0]
   ```

   Tile `31` is a decorative alternative to tile `1` in the reference art;
   give it tile `1`'s ID only when either visual variant is acceptable. A Wang
   set cannot deterministically select two different art tiles for the same
   neighbor mask. Do not invent missing masks for other sheets.
5. Save an external TSX only after a matching rendered fixture passes. For a
   limited set, save the precise allowed topology and the missing Wang IDs in
   the result; future maps must not expand its claim.

## Coverage-first proof fixtures

Build the smallest disposable fixture that reaches the masks the caller needs,
then verify both its data and rendered output. Do not treat a large attractive
map as evidence of coverage.

| Requested behaviour | Required fixture feature | What it catches |
| --- | --- | --- |
| Exterior boundary | Filled rectangle with all four turns | reversed or wrong-facing outer corners |
| Concavity / rooms | 2x2 or larger unpainted hole in a filled area | missing diagonal-aware inner corners |
| Corridors | horizontal and vertical runs, one-cell turns, a T and a plus | absent straights, caps, joins, or rotation errors |
| Sparse detail | one-cell island and one-cell notch, only when requested | unsupported isolated/concave masks |
| Blob profile | all four behaviours above, painted in the profile's declared direction | use of the non-invertible 47-mask set backwards |

- Before painting, make a required-mask inventory from the fixture's eight
  samples. For each cell, state its expected mask/signature and the local tile
  that must satisfy it. If an expected signature has no mapped tile, stop with
  **Limited Wang-ready** or **Not Wang-ready**; never let the Terrain Brush
  choose an unrelated fallback unnoticed.
- After `paint_terrain`, use `read_region` to assert that every expected cell
  is populated by a local tile with the recorded signature, and use
  `get_region_image` to check joins, orientation, transparent gaps, and visual
  inversions. Repeat the fixture after an erase/repaint near a boundary: the
  brush must also repair neighboring tiles correctly.
- A Blob set is Wang-ready only for the requested painted direction and
  tested footprint family. Do not claim it supports a reversed terrain, a
  second colour, or every arbitrary mixed mask merely because all 47 supplied
  tiles render cleanly.

## Figure 8 proof

For the default Figure 8, create a disposable map using the exact TSX:

- A repeated Floor layer, an empty Objects object layer, and a Walls tile
  layer in the visual order `Objects`, `Walls`, `Floor`.
- Paint the **walkable footprint** on Walls, not a one-cell wall stroke: a
  10×10 left lobe, a 10×10 right lobe, and a four-tile-tall bridge between
  them. The bridge contains a two-tile-tall walkable passage, so its top and
  bottom rows become walls. Leave a 4×4 unpainted core inside the right lobe.
  This topology requires the four diagonal-aware inner-corner masks above.
- When the art has an opaque void tile, place it in the unpainted 4×4 core
  after the Wang operation so that core is visibly non-walkable. This is a
  deliberate fill, not a claimed Wang result.
- Verify the complete cell set with `read_region` and the rendered map with
  `get_region_image`. The test fails if any expected Wang cell is null,
  transparent, a wrong-facing edge, or a broken join.
- Keep positive and negative controls together. In Tiled 1.12.2, the exact
  Dungeon Figure 8 assignments above painted a clean 8x8 rectangle with local
  tile IDs `0, 1, 5, 12, 13, 17, 48, 49, 53` and a seamless rendered border.
  The same set rejected a one-cell paint with `MISSING_WANG_PATTERN` for
  `[0,0,0,0,0,0,0,0]`, changing no cells. This is evidence that it is
  **Limited Wang-ready** for room/frame footprints, not evidence of general
  mixed-terrain coverage. Never add an all-zero assignment just to silence
  that error; it must be visually identified as a legitimate source tile.

Do not widen corridors to one cell or create isolated floor cells unless the
tileset has been separately proven by the relevant coverage fixture. The Blob
profile is a candidate for these forms, not a waiver for visual verification.
`paint_terrain` works on one declared colour and cannot recover an
unrepresented pattern.

Follow the shared [MCP editing contract](../references/tiled-ai-mcp.md).

## Result Links

Finish with clickable links to the saved TSX and fixture map. Name the Wang
set, colour, matching topology, source of the local-ID mapping, supported
footprint family, known missing masks, and fitness outcome.
