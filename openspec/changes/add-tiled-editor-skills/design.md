# Design

## Context

The seven existing Tiled authoring skills are standalone global directories.
The library catalog and lifecycle helper currently recognize four categories.
See [proposal.md](proposal.md) for motivation and the accompanying spec deltas
for externally visible behavior.

## Goals / Non-Goals

**Goals:**

- Preserve each existing skill's full contents while establishing a canonical,
  categorized library copy.
- Use a predictable `tiled-ai-` namespace for the library-owned skills.
- Use the verified `rpgjs/tiled-ai` MCP companion as the shared map-editing
  dependency.
- Provide a setup skill that verifies every dependency and connection before
  an authoring skill makes edits.
- Make ordinary library push and pull operations work for the new category.

**Non-Goals:**

- Rewriting the specialized authoring guidance to depend on a live MCP bridge.
- Removing the existing global source copies as part of this library checkout
  import.

## Decisions

### Add a category rather than fold Tiled skills into game creation

Create `.agents/skills/tiled-editor/` with its own catalog. These skills are
editor and asset-authoring workflows rather than a particular engine or game
creation template. Folding them into `ai-skills-create` would obscure their
reuse for existing games.

### Rename only library-owned skills

The imported authoring skills will be renamed from `tiled-editor-*` to
`tiled-ai-*`, preserving the suffix that identifies their task. A community
companion, once selected, retains its own package identity (`tiled-ai`) rather
than being renamed or merged. This avoids confusing a generic bridge skill
with the library's higher-level workflows.

### Use the tested Tiled AI MCP

`rpgjs/tiled-ai` is the leading evaluation candidate for autotiling: its
documented MCP creates Wang sets and uses Tiled's Wang engine to paint terrain.
Other candidates have different trade-offs: TiledMCP offers controlled file
edits and an optional terrain preview, while `@fablenator/tiled-mcp` explicitly
does not support Wang terrains. A live smoke test has created an external
tileset, a Wang set, and an autotiled map through this bridge. Each library
skill therefore verifies an active bridge session before modifying an open map.

### Add a setup-and-test entry point

`tiled-ai-setup` checks the required Node runtime, bridge build and doctor
result, Codex MCP registration, Tiled extension, running bridge, and live
Tiled connection in dependency order. It reports the first failed check with a
minimal corrective action, rather than treating a partial setup as success.
Its smoke test uses a disposable map and tileset and proves the live connection
with a read-only editor-state request. The authoring skills may assume that
this setup skill has passed, but still verify a fresh session before a mutation.

### Make a minimal autotile level repeatable

`tiled-ai-add-sample-level` accepts an optional grid size, world size, and one
tileset. When omitted, it uses a 32×32 tile grid and a 50×50 map. It creates
the `Objects`, `Walls`, and `Floor` layers: objects starts empty, floor repeats
a compatible base tile, and walls are painted through a Wang set only when the
provided tileset supports the requested terrain. The skill must explain and
stop before wall painting when no compatible autotile/Wang data exists.

### Extend the category resolver

Add `tiled-editor` to the lifecycle helper's category allowlist. This preserves
its existing preflight, source-preservation, staging, and conflict handling
instead of creating a separate import mechanism.

## Risks / Trade-offs

- [Rename breaks users who invoke old names] → Catalog documentation will list
  the new canonical names; existing global copies remain untouched during the
  import, allowing an explicit migration later.
- [MCP package changes independently] → Keep it separate from owned skills and
  make selection/testing a later reviewed action.
- [Category resolver omits new skills from bulk copy] → Extend and verify both
  named and `all` lifecycle paths.

## Migration Plan

1. Copy and verify the seven global source directories into `tiled-editor`
   under their new library-owned names.
2. Add and link the category catalogs, then update the lifecycle resolver.
3. Add the MCP-backed setup workflow, then revise each authoring workflow to
   verify and use the bridge for live Tiled edits.
4. Validate the library catalog and exercise lifecycle preflight/copy behavior
   before installing the renamed copies globally and removing only the seven
   superseded global source directories.
