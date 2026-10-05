# Design

## Context

The category had one broad tileset workflow and a `configure` name that did
not distinguish image conversion from terrain authoring. A live Dungeon
fixture showed that its 6×5 room reference is a nine-pattern edge Wang set:
the selected terrain is the walkable floor, while the boundary tiles render
wall art.

## Goals / Non-Goals

**Goals:**

- Keep image-to-TSX conversion and autotiling authoring independently
  selectable.
- Make the Figure 8 a reproducible evidence fixture for compatible room-frame
  art.
- Prevent skills from silently extrapolating unobserved Wang masks.

**Non-Goals:**

- Infer a complete Wang vocabulary from arbitrary art without a visible
  reference or successful rendered proof.
- Add game-runtime collision or navigation behavior.
- Support one-cell corridors or isolated floor cells unless the exact tileset
  explicitly proves those masks.

## Decisions

### Replace configure naming with an explicit add-metadata workflow

`tiled-ai-add-tileset` is constrained to image conversion only.
`tiled-ai-add-tileset-autotiling` consumes an existing TSX and authors its
Wang data. This makes the input boundary visible and avoids claiming that every
imported sheet is autotile-ready.

### Paint terrain footprints, not wall lines

The bridge paints one Wang colour across the selected footprint. For room-frame
art, a solid walkable region emits the directional side/corner masks required
by the source reference. Painting a wall line cannot encode the intended
inside/outside boundary orientation.

### Make the Figure 8 topology intentionally mask-limited

The default fixture uses 10×10 lobes, a two-cell-wide connector, and a 4×4
hole. This emits the nine masks supplied by the Dungeon room reference and
avoids unknown singleton and opposite-edge patterns. An optional opaque void
tile fills the central hole after the Wang operation; it is documented as a
non-Wang fill.

### Treat saved fixture evidence as the fitness gate

The tool validates the external TSX in its own Tiled document, then attaches
it to a disposable map and uses map-local Wang IDs for painting. It verifies
cells and a bounded render before saving both artifacts.

## Risks / Trade-offs

- [A different sheet has ambiguous directional art] → Classify it as not
  Wang-ready instead of saving guessed metadata.
- [A desired layout emits an unsupported mask] → Report the exact missing
  combination and constrain the accepted footprint.
- [Interior floor is duplicated on the Walls renderer layer] → Keep the
  repeated Floor layer below it; this is required by the bridge's one-colour
  painting model and is visually idempotent for the verified floor tile.

## Migration Plan

1. Add the renamed autotiling skill and update all catalog and workflow links.
2. Remove the superseded `tiled-ai-configure-autotiling` skill entry.
3. Validate both skill packages and execute a fresh imported-Dungeon Figure 8
   fixture through the live MCP.
