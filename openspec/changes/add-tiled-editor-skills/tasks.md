# Tasks

## 1. Import and namespace the authoring skills

- [x] 1.1 Copy each of the seven validated global `tiled-editor-*` directories into `.agents/skills/tiled-editor/` under its corresponding `tiled-ai-*` name, preserving every supporting resource, and verify each destination contains a valid `SKILL.md` plus a matching source tree digest.
- [x] 1.2 Update each imported skill's frontmatter name, self-references, and UI display name to its `tiled-ai-*` canonical name and `Tiled AI …` label, and verify all frontmatter names match their directory names.
- [x] 1.3 Rewrite each imported authoring skill to require the selected Tiled AI MCP, verify a live session before mutation, use its map-editing tools for Tiled changes, and preserve each skill's existing runtime-integration guidance.
- [x] 1.4 Create and validate `tiled-ai-setup`, which checks every required Tiled AI dependency and proves a live Tiled connection; it MUST stop at the first missing prerequisite with a minimal corrective action.
- [x] 1.5 Create and validate `tiled-ai-add-sample-level`, which accepts optional grid size, world size, and one tileset; defaults to 32×32 tiles and a 50×50 map; creates `Objects`, `Walls`, and `Floor`; keeps objects empty; repeats a floor tile; and uses Wang autotiling for walls only when supported.

## 2. Publish catalog navigation

- [x] 2.1 Create the `tiled-editor` category README with concise descriptions and direct links for the nine library-owned skills, including the selected Tiled AI MCP setup companion, and verify every target resolves within the repository.
- [x] 2.2 Add the Tiled-editor category to the root skills catalog and repository README, and verify the category is discoverable from both catalog entry points.

## 3. Support library lifecycle operations

- [x] 3.1 Extend the lifecycle helper's recognized categories and resolver to support `tiled-editor`, and verify named push and pull preflight plans resolve the correct category without replacing or removing either source.
- [x] 3.2 Verify bulk pull includes valid `tiled-editor` skills and preserves the existing preflight failure behavior by exercising the helper against an isolated temporary global-skills directory.
- [x] 3.3 Install the nine renamed library skills into the global skills directory, verify their metadata and trees, then remove only the seven superseded global `tiled-editor-*` directories so the palette has no legacy duplicates.

## 4. Validate the library change

- [x] 4.1 Run the skill validator for every imported and new skill and correct any naming, frontmatter, or scaffold errors it reports.
- [x] 4.2 Run OpenSpec validation for `add-tiled-editor-skills` and inspect the repository diff to confirm the library change is scoped, the global migration changed only the seven approved legacy directories, and no MCP configuration or unselected community package was changed.
