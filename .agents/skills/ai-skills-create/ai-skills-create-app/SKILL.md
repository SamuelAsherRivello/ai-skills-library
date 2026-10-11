---
name: ai-skills-create-app
description: Create a non-game React application from the shared repository template. Use when starting an application rather than a game.
---

# AI Skills Create App

Create a new repository and React application in strict TypeScript. Route game/game-engine/Babylon-renderer requests to `$ai-skills-create-game`; do not add gameplay or game dependencies unless the user changes scope. Publish, deploy, or release only when explicitly requested.

Author application source, React components, tests, executable JavaScript configuration, and JavaScript tooling in `.ts`/`.tsx` with `strict: true`. Migrate a JavaScript shared or custom starter in the copied project before handoff, including local-only work. Generated JavaScript, dependencies, and native shell orchestration remain valid; file renames or blanket declarations do not establish type safety.

## Inputs

Accept natural language or prompt fields, not shell flags. `app` describes users, purpose, and essential features; `name` supplies repository identity. Infer omitted identity fields where safe. Optional `folder` and `project` default from the name, `visibility` to `public`, and `owner` to the authenticated GitHub account. `requirements` controls features, exclusions, visuals, and delivery scope.

Use the [shared template](https://github.com/SamuelAsherRivello/github-repository-template) unless another is supplied. Confirm only material missing information, unavailable ownership, or destination conflicts.

## Create and verify

1. Verify authentication and template-generation permissions. Generate through GitHub's template flow and clone; never overwrite or reuse an existing repository/folder without an explicit continuation request. Verify remote/default branch.
2. Read generated `AGENTS.md` and template checklist. Inspect actual React/Vite structure and commands; preserve conventions, rename the copied application directory and update dependent paths as required. Remove game-only starter code/dependencies. Implement the responsive, accessible app within scope, keeping meaningful application behavior testable independently of React/external adapters.
3. Run complete strict typechecking, source-coverage checks, meaningful tests, and the production build under [the quality gate](references/quality-gate.md). Test meaningful user flows and recovery states in a real browser when warranted. `$playwright-cli` is optional; use it when available and useful, otherwise another suitable tool. Report unverified browser behavior if no suitable method is available.
4. Use headless automation with isolated test profiles. If headed testing is necessary, launch minimized without taking focus; never spawn normal visible windows for automated testing, including browser capability fallbacks. If a tool cannot comply, choose another method or report the limitation. Keep tests silent and close only automation-owned sessions/processes.
5. Complete [the quality gate](references/quality-gate.md) before reporting completion. Then perform only requested delivery actions through the repository's existing workflows and verify their actual outcome. Local-only scope does not authorize publishing.

Return repository URL, local checkout, validation evidence, final triage packet/scores, deferred candidates, requested delivery results, and precise blockers. Preserve unrelated work; never expose credentials, force-push, delete repositories, or overwrite destinations. Stop affected work when access or a destination conflict blocks it.
