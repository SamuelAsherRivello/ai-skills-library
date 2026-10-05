# Tasks

## 1. Split and rename tileset workflows

- [x] 1.1 Restrict `tiled-ai-add-tileset` to image-to-TSX conversion only; verify both skill packages pass `quick_validate.py`.
- [x] 1.2 Replace `tiled-ai-configure-autotiling` with `tiled-ai-add-tileset-autotiling`; verify no maintained catalog or workflow link targets the removed name.
- [x] 1.3 Update the Tiled category catalog, sample-level workflow, and shared MCP contract; verify the catalog links resolve to existing skill files.

## 2. Verify room-frame Wang authoring

- [x] 2.1 Create a fresh external TSX from the Dungeon PNG through the live MCP and verify the imported image, 32×32 grid, and 108 tiles.
- [x] 2.2 Add the nine observed `Walkable floor` edge assignments and verify the resulting tileset Wang set through `list_wang_sets`.
- [x] 2.3 Create and save a disposable Figure 8 fixture with Floor, Walls, and empty Objects layers; verify the two-cell connector, inner loop, opaque core, generated cell data, and bounded render.

## 3. Validate the change

- [x] 3.1 Run strict OpenSpec validation and `git diff --check`; verify both complete without errors.
- [x] 3.2 Re-inspect the saved TSX and TMX through Tiled MCP and verify the reported Wang-ready result has clickable, existing output paths.
