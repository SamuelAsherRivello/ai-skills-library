---
name: ai-skills-create-game
description: Use when creating a Babylon Lite browser game from an idea, including requested multiplayer. Gate on requirements and required access, then create a public template repository and deliver a playable GitHub Pages game.
---

# AI Skills Create Game

Create a tested game in strict TypeScript, single player by default. For a game-delivery request, create a public repository from the shared template and publish a playable GitHub Pages game; multiplayer also requires a verified Vercel backend. Do not silently turn a delivery request into a local-only result.

## Mandatory intake and access gate

Complete this gate before creating a repository, editing a checkout, generating assets, or beginning OpenSpec artifacts. Report a concise readiness table or equivalent that identifies every required capability as ready, not required, or blocked.

1. Establish the game requirements, repository owner, and automation identity. Resolve and verify the AI organization as the repository owner unless the user explicitly supplies another owner; do not invent an organization slug. The required automation identity is the existing GitHub user `ai-rmc-com` (the AI user). If any essential choice is unclear, ask targeted questions and wait for the answers: **2D or 3D; single-player or multiplayer; art source** (user-supplied, AI-generated, or online assets with provenance and rights); and any services or credentials the design needs. Do not infer an art-rights decision from a visual style alone.
2. Inspect access for every service and tool in scope for this request: verify that `ai-rmc-com` is the authenticated GitHub actor, then resolve and verify the AI organization and the AI user's repository-creation permission for it; also inspect the shared template, GitHub Pages publication, and (for multiplayer) the selected server repository plus its Vercel project, deployment permission, and required credentials. Do not infer access from a stated owner, AI user, or authenticated identity. Inspect the in-scope global OpenSpec skills—`openspec-explore`, `openspec-propose`, `openspec-update-change` when a plan changes, and `openspec-apply-change`—and Playwright CLI by default. Include any user-named services, assets, or credentials in the same check.
3. If required access, credentials, template/server permission, or an in-scope global skill is unavailable, pause before implementation and state the exact missing access or skill. Ask the user to restore access or change scope; do not install substitutes, create repository-local OpenSpec skills, or silently degrade to a local-only build. Playwright CLI is optional: report it unavailable and use another suitable verification method only after the required gate passes.
4. Once ready, use the in-scope global OpenSpec workflow in this order: **Explore → Propose → optional Update → Apply**. Do not generate, install, or copy repository-local OpenSpec skills unless the user explicitly authorizes it. Apply remains the implementation step; Update is only needed when the approved plan changes.

## Inputs and sources

Accept natural language or prompt fields:

- `game` is required; infer a small coherent game unless the idea is missing or contradictory.
- `mode` defaults to `single-player`; networked cooperative/competitive requests select `multiplayer`.
- Derive `name` and default slug `babylon-lite-<game-slug>`; the owner remains the verified AI organization resolved during intake unless explicitly overridden, and `ai-rmc-com` remains the required AI user pending successful preflight.
- `art`, `references`, and `requirements` refine presentation, mechanics, controls, destination, and scope. Identify each reference's role and faithful/inspiration intent; resolve material conflicts.

Use the [template](https://github.com/SamuelAsherRivello/github-repository-template) and [skills library](https://github.com/SamuelAsherRivello/ai-skills-library). After the intake gate passes, generate a **public** repository through GitHub's template flow, record revisions, and never replace a colliding repository/folder without a continuation request. Read generated `AGENTS.md` and checklist before editing.

Import needed non-OpenSpec library skills as real files under the template's installation policy. Preserve customizations and resolve overlaps. Use the in-scope global OpenSpec skills from the intake gate; do not install or copy them into the generated repository without explicit user authorization. Never hand-edit generated skills or update unrelated global skills.

Preserve template layout, corner roles, links, and version conventions; rename the copied application directory and update paths per its checklist. Inspect scripts/current APIs. Use Babylon Lite with WebGPU and its 2D Pixel Perfect policy; never silently substitute renderers.

Author game source, React components, tests, executable JavaScript configuration, and JavaScript tooling in `.ts`/`.tsx` with `strict: true`. Migrate a JavaScript starter in the copied project before handoff. Generated JavaScript, dependencies, and native shell orchestration remain valid; renaming files or adding blanket declarations does not establish type safety.

## Design and build

Define criteria for actions, camera, objective, scoring, progression, outcomes, restart, and visuals. Default to one-screen 9:16 portrait, original game/gutter artwork, keyboard/concurrent touch controls, instructions, pause/resume, and replay. Explicit requirements override defaults; requested sandboxes need interactions/reset rather than invented win conditions.

Show unsupported-WebGPU/initialization errors. Keep rules testable independently of rendering/input. Prevent duplicate loops and stuck input across resize, pause, restart, focus loss, pointer cancellation, and teardown. Integrate actual supplied/generated assets with provenance; use image generation or procedural art as appropriate. When the user supplies or drags in approved art assets, copy them into the generated project's appropriate asset location and update every reference to use that project-local copy. Preserve provenance and license attribution, never delete or alter the user's source assets, and never leave a runtime or build dependency on the user's original external folder.

For multiplayer, read [multiplayer.md](references/multiplayer.md) before planning; extend, release, deploy, and verify the shared Vercel server before creating the client. **Use Vercel Hobby as provided**, including duration limits. Never recommend alternative providers, paid plans, or external storage workarounds. Single player has no backend.

Use the global OpenSpec sequence established by the intake gate for proposal, design, requirements, and verifiable tasks. Continue implementation once the gate and required planning steps are complete; track design changes and task evidence. A request explicitly limited to planning ends with planning artifacts only and must say that no game was published.

## Verify without disrupting the user

Run complete strict typechecking, source-coverage checks, rule/transition tests, and production build. Follow the TypeScript gate in [delivery.md](references/delivery.md). Play a full loop in a real WebGPU browser: desktop/mobile layouts, keyboard/touch/pointer controls, pause, outcomes, replay, assets, console errors, and actual screenshots.

Default to Playwright CLI with isolated test profiles when its intake check passes. Necessary headed testing must launch minimized without taking focus, including Edge/WebGPU fallbacks. Never open normal visible automation windows. If Playwright CLI is unavailable, use another suitable method and report it. Keep tests silent; close only automation-owned processes. Verify actual WebGPU capability and distinguish emulated touch from physical devices.

Before release, follow [delivery.md](references/delivery.md) for the quality gate, documentation, scoped delivery, and verification report.
