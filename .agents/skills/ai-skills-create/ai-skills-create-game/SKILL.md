---
name: ai-skills-create-game
description: Use when creating a Babylon Lite browser game from an idea, including requested multiplayer. Build from the shared template and deliver through GitHub Pages unless scope is limited.
---

# AI Skills Create Game

Create a tested game in strict TypeScript, single player by default. Deliver through release and GitHub Pages unless the user limits scope to planning or local work.

## Inputs and sources

Accept natural language or prompt fields:

- `game` is required; infer a small coherent game unless the idea is missing or contradictory.
- `mode` defaults to `single-player`; networked cooperative/competitive requests select `multiplayer`.
- Derive `name`, default slug `babylon-lite-<game-slug>`, and owner `SamuelAsherRivello` unless overridden.
- `art`, `references`, and `requirements` refine presentation, mechanics, controls, destination, and scope. Identify each reference's role and faithful/inspiration intent; resolve material conflicts.

Use the [template](https://github.com/SamuelAsherRivello/github-repository-template) and [skills library](https://github.com/SamuelAsherRivello/ai-skills-library). Verify authenticated access/default branches, record revisions, and generate through GitHub's template flow. Never replace a colliding repository/folder without a continuation request. Read generated `AGENTS.md` and checklist before editing.

Import needed library skills as real files under the template's installation policy. Preserve customizations, resolve overlaps, and follow its OpenSpec setup procedure. Never hand-edit generated skills or update unrelated global skills.

Preserve template layout, corner roles, links, and version conventions; rename the copied application directory and update paths per its checklist. Inspect scripts/current APIs. Use Babylon Lite with WebGPU and its 2D Pixel Perfect policy; never silently substitute renderers.

Author game source, React components, tests, executable JavaScript configuration, and JavaScript tooling in `.ts`/`.tsx` with `strict: true`. Migrate a JavaScript starter in the copied project before handoff, including local-only work. Generated JavaScript, dependencies, and native shell orchestration remain valid; renaming files or adding blanket declarations does not establish type safety.

## Design and build

Define criteria for actions, camera, objective, scoring, progression, outcomes, restart, and visuals. Default to one-screen 9:16 portrait, original game/gutter artwork, keyboard/concurrent touch controls, instructions, pause/resume, and replay. Explicit requirements override defaults; requested sandboxes need interactions/reset rather than invented win conditions.

Show unsupported-WebGPU/initialization errors. Keep rules testable independently of rendering/input. Prevent duplicate loops and stuck input across resize, pause, restart, focus loss, pointer cancellation, and teardown. Integrate actual supplied/generated assets with provenance; use image generation or procedural art as appropriate.

For multiplayer, read [multiplayer.md](references/multiplayer.md) before planning; extend/release/deploy/verify the shared server before creating the client. **Use Vercel Hobby as provided**, including duration limits. Never recommend alternative providers, paid plans, or external storage workarounds. Single player needs no server dependency/release.

Use OpenSpec proposal, design, requirements, and verifiable tasks. Continue implementation when ready unless planning-only; track design changes and task evidence.

## Verify without disrupting the user

Run complete strict typechecking, source-coverage checks, rule/transition tests, and production build. Follow the TypeScript gate in [delivery.md](references/delivery.md). Play a full loop in a real WebGPU browser: desktop/mobile layouts, keyboard/touch/pointer controls, pause, outcomes, replay, assets, console errors, and actual screenshots.

Default to headless isolated test profiles. Necessary headed testing must launch minimized without taking focus, including Edge/WebGPU fallbacks. Never open normal visible automation windows. If unavailable, use another method or report unverified criteria. Keep tests silent; close only automation-owned processes. `$playwright-cli` is optional. Verify actual WebGPU capability and distinguish emulated touch from physical devices.

Before release/local handoff, follow [delivery.md](references/delivery.md) for the quality gate, documentation, scoped delivery, and verification report.
