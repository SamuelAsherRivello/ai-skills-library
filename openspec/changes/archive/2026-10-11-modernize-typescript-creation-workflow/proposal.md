# Proposal

## Why

The template and generated games currently author JavaScript/JSX, while the multiplayer repository typechecks only part of its implementation and ships an untyped shared client. Strict TypeScript must cover authored runtime code, tests, and executable JavaScript tooling so future apps and games inherit verified types rather than an unchecked starter.

## What Changes

- Implement a behavior-preserving migration of `github-repository-template` to TypeScript/TSX, including Vite configuration, tests, and executable JavaScript scripts.
- Convert of `rmc-colyseus-multiplayer-server` server modules, simulations, shared browser client, tests, probes, and release/deployment scripts to strict TypeScript. Extract executable JavaScript embedded in workflow YAML into checked TypeScript scripts.
- Build and verify compiled ESM JavaScript and generated declarations locally for every shared-client export, preserving runtime API, game protocols, artifact names, and existing JavaScript consumers.
- Require strict TypeScript source, complete typecheck coverage, and blocking verification in both creation skills. Apply the same requirement to all future template uses and all multiplayer-server change scopes, for humans and AI agents.
- Preserve Vercel Hobby hosting, bounded session behavior, unobtrusive browser testing, template presentation, and existing delivery authorization boundaries.

## Capabilities

### New Capabilities

- `typescript-project-baselines`: TypeScript source, configuration, tests, tooling, and package contracts for the two upstream repositories.

### Modified Capabilities

- `creation-quality-gates`: Require strict TypeScript coverage and verification for every newly created game and app, including when a source template has not migrated yet.

## Impact

The coordinating change lives in `ai-skills-library`. It plans work in two separate repositories; it does not grant this repository's apply operation filesystem authority over them. Upstream implementation must run in each target checkout under its own instructions and permissions, recording revision and verification evidence here.

Affected surfaces include template `project-name/src`, `project-name/test`, `vite.config.js`, npm metadata and workflows; multiplayer `server.ts`, `multiplayer-server/src`, `multiplayer-server/packages/client`, `multiplayer-server/test`, root `scripts`, and workflows; and the app/game creation skills and their verification references. Source extensions and internal tooling paths change, but public import specifiers, release tarball naming, runtime protocols, and deployment endpoints remain compatible.

Existing generated games/apps are compatibility consumers, not migration targets. The user subsequently authorized upstream implementation and this finalization macro, including scoped commits and normal pushes. Releases, deployment and global skill synchronization remain outside this change. The user approved moving public rollout tasks to `release-typescript-creation-workflow`.
