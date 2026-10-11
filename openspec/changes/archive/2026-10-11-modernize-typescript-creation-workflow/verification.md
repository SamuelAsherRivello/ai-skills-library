# Implementation evidence

## Template baseline (2026-10-11)

- Owning checkout: `D:/Documents/Projects/VC/Github/github-repository-template`, branch `main`, revision `49d6c20741f2aaac509f7954392d72526614aca6`.
- Read owning `AGENTS.md`; `openspec context --json` resolved that checkout as its local root with no members.
- Host Node `26.7.0`, npm `11.19.0`; existing workflows select Node 24. Vite resolved `8.3.0`, React `19.3.0`, Babylon Lite `1.32.0`.
- Existing baseline: all 21 Node tests passed; Vite production build passed with `/github-repository-template/` asset base.
- Preexisting work: staged lowercase component/context/image renames; unstaged import/test changes in those files and `main.jsx`, plus `docs/layout-and-game-integration.md`. Preserve these contents and index; no reset, checkout, or staging performed.
- Executable inventory: 17 source JS/JSX modules, two `.mjs` Node tests, root `vite.config.js`; `package.json` has dev/build/preview/test entry points; `.github/workflows/deploy-pages.yml` invokes install/test/build and `release.yml` invokes install/test and native Bash version/tag/release operations. No additional authored JS scripts were found in the tracked-file inventory.

Migration verification is recorded below as tasks finish. Public deployment, release and publication have not been performed.

## Template migration verification

- Pinned TypeScript `5.9.3`, tsx `4.22.4`, React/DOM types `19.3.0`, Node types `24.19.2`, WebGPU types `0.1.71`. Clean `npm ci` succeeded. Browser and Node configs parsed successfully and include every authored source/test/config/tool file.
- Initial strict diagnostics identified untyped React props/state, renderer lifecycle resources, sprite tuples, recursive test utilities and canvas fixtures. These were resolved with explicit contracts, `unknown` boundaries and documented narrow Babylon runtime/prototype assertions. No blanket suppression or permissive module declarations added.
- Source coverage passed with 21 first-party compiler files and zero authored JS. Disposable authored JS, untracked orphan TS and tracked orphan TS (using a temporary copied Git index) all failed the source guard. Real index was untouched.
- Disposable test/tool TS2322 errors failed both `typecheck` and `build`; a temporary type error appended to `vite.config.ts` failed typecheck. All temporary fixtures were removed and the config restored.
- `npm run typecheck`, all 21 migrated regression tests, and gated `npm run build` passed. A final Node 24 production build again passed all 21 tests and complete compiler/source checks ([output](evidence/template-final-node24-build.txt)). Both Pages and release workflows now check coverage/types/tests before delivery; release also builds before mutating version/tags. Output retained `/github-repository-template/assets/` URLs.
- Headless Microsoft Edge initialized actual WebGPU rendering without a fallback. Verified 16:9 and 9:16 viewport fitting, settings dialog and pause outline, render-preset persistence, reload and resize; zero uncaught page errors. Browser and local server closed in `finally`; no desktop window opened.
- Disposable renamed copy `C:/Users/srive/AppData/Local/Temp/strict-template-renamed-9qw1qkfa`: copied current working files, renamed app directory to `verification-game`, updated path references and initialized disposable Git metadata. Clean install, source coverage, strict typecheck, all tests and gated build passed; subpath assets verified.
- Snapshot of preexisting template working source: `C:/Users/srive/AppData/Local/Temp/template-before-typescript-x000xoex`. Existing lowercase names/imports retained; no Git index reset or staging in the owning checkout.

## Multiplayer baseline (2026-10-11)

- Owning checkout: `D:/Documents/Projects/VC/Babylon/rmc-colyseus-multiplayer-server`, branch `main`, revision `2de6385289f8ded695250b1e4c5599241d2d28de`, clean worktree on inspection.
- Read owning `AGENTS.md`; OpenSpec context resolved this checkout as its local root with no members. Required Node 24, Vercel Hobby and no deployment/publication without a request remain controlling instructions.
- Baseline `npm run typecheck` passed, but its includes only root `server.ts` and `multiplayer-server/src/**/*.ts`; it omits client, tests and tools. Host is Node 26.7.0/npm 11.19.0; target is Node 24. Existing TypeScript/tsx pins are 5.9.3/4.22.4.
- Full inventory: 34 server files (3515 lines, including four JS simulations and two handwritten declaration companions); 44 Node `.mjs` tests (2881 lines, including feasibility); 14 client JS modules plus README/package (2001 lines total); 13 `.mjs` tools/probes (700 lines); 18 YAML workflows (1172 lines). Enumerated using `git ls-files` and `rg --files`; inspected registration in `src/server.ts`.
- Preserved public export inventory: root, racing, racing-track, street-fighter, bomberman, bomberman-cpu, combat, asteroids, asteroids-connection, tetris-duel; all currently resolve to source JS without declarations.
- Caller inventory: root dev/docs/typecheck/probe/long-session/test commands; PR and release packaging; deploy/deploy-tetris/deploy-music/deploy-asteroids; asteroids preview/hosting/store/project/storage workflows; diagnostics, feasibility, drawing-cross-host, deployment-check, music setup/release and verify-hobby. `rg` traced all `.mjs` imports/invocations and inline Node workflow bodies. Fresh publish jobs currently pack without installing/building declarations.

## Multiplayer migration verification

- Server revision remains `2de6385289f8ded695250b1e4c5599241d2d28de` on `main`; template remains `49d6c20741f2aaac509f7954392d72526614aca6` on `main`. Neither checkout was staged, committed, reset, branched, deployed or published. Existing template staged renames were preserved. Library changes outside this change and creation skills were preserved.
- Node **24.21.0** was placed first on subprocess PATH for final verification. `npm ci` installed 153 packages, audited 154, with zero server dependency vulnerabilities. Compiler/runner pins remain TypeScript 5.9.3 and tsx 4.22.4; runtime dependency versions were preserved.
- Final inventory: template **21 authored TS/TSX**, server **131 authored TS** and **zero authored JS** in both checkouts. Server compiler coverage reports 134 first-party files including three imported JSON manifests. Exact paths, compiler configs and all 18 workflows are in [source-inventories.json](evidence/source-inventories.json).
- Server, browser client and test/tool compiler configurations extend the strict base. Browser checking has DOM libraries and no Node globals. All four server JS simulations and all 14 client modules are now TypeScript; both handwritten simulation declaration companions were removed. All 44 original Node tests, local/live probes and deployment tools were migrated. Workflow JavaScript now lives in checked `scripts/workflows/*.ts`; generated capability handlers come from compiled TypeScript fixtures.
- Meaningful negative cases reject incompatible assignments in tests and probes (TS2322), authored JS, and tracked/untracked orphan TS. The tracked fixture used a copied temporary index, never the owning index. An incompatible tool assignment also failed `npm run build` before tests or output generation. See [coverage negatives](evidence/server-negative-coverage.json) and [build negative](evidence/server-negative-build.json). Fixtures were removed.
- Final clean-install `npm run build` passed coverage, all three strict compilers, **155 tests, zero failures/skips**, clean ESM/declaration emission and probe handler compilation. The additional test count relative to the original 154 is the checked TCP helper's Node module entry, not a replacement for an existing assertion. Full output: [clean build](evidence/server-clean-build.txt). All 17 registered-game docs/local links passed `npm run check:docs`; final `git diff --check` passed.
- Public client package name/version remain `@rmc/multiplayer-client` / `0.9.13`; tarball remains `rmc-multiplayer-client-0.9.13.tgz`. All ten public exports have generated runtime/declaration mappings. Packing includes only generated `dist/`, README and package metadata. Artifact metadata and the complete file list: [packed client](evidence/packed-client.json).
- A clean isolated tarball installation passed strict Bundler and NodeNext contracts for every public export, five invalid-call checks, the exact TypeScript README example, and loader-free execution of compiled plain JavaScript. Useful state/action/subscription types derive from shared simulations or explicit game contracts via the compatible generic `MultiplayerClient` API. No source-checkout fallback or blanket module declarations were used.
- A separate installed-artifact consumer compiled the existing drawing, racing and private-admission integration assertions to plain JavaScript and ran them without a TS loader against an ephemeral local server. **All three passed**, covering multiple clients, authoritative rejection of forged input/other-player edits, host-only start, capacity, fresh reconnect identities, preserved seats and 15-second recovery/expiration. [Packed local artifact](evidence/packed-client-local.json), [local regression output](evidence/packed-client-local-tests.txt). This preserves existing assertions rather than substituting a smoke test.
- Local feasibility and music relays each passed with two clients; the local bounded-session probe passed with `LONG_SESSION_SECONDS=1`. These short fixtures verify renamed CLI/env contracts, not the separately authorized 240-second public-host acceptance test.
- `npm run verify:tools` passed isolated version-setting success/rejection, credential presence/health, prior-deployment empty/success/failure, release-health validation and session required-env fixtures. Mocked fetch permits GET only, output assertions reject secret values, and version writes affect temporary manifests only. Extracted hosting diagnostics preserve environment/integration metadata redaction. [Tool evidence](evidence/server-tool-fixtures.json).
- All 18 workflow YAML files parsed; each Node job has checkout/install/source/type gates in order, all TS script paths exist, no old executable `.mjs` source invocations or inline Node JS remain, and every packing job builds the client first. Fresh release publish jobs now install, check source/types, build and verify the artifact before publication. [Workflow evidence](evidence/server-workflows.json).
- Extracted hosting output construction ran locally from compiled handlers into disposable directories, producing six syntax-checked `.mjs` files and Vercel metadata with no network or deployment calls. Empty dependency fixture directories establish output construction/syntax only, not cloud behavior. [Hosting fixture evidence](evidence/hosting-output-fixture.json).
- Required Vercel Hobby configuration remains `maxDuration: 300`, with existing public probes bounded at 240 seconds. Deployment/promotion/rollback workflows remain in place. Historical Render diagnostic tools were migrated compatibly; they do not change the required active host.

## Generated project acceptance

- Disposable generation directory: `C:/Users/srive/AppData/Local/Temp/strict-generated-projects-cg3n1h9a`. These are local copies of the migrated working template for acceptance, not remotely published GitHub template generations. Each has isolated Git metadata, renamed app directory/repository metadata, compiler roots and Pages asset base.
- The non-game `verification-app` removes the Babylon implementation and dependencies, retains the reusable React shell, and implements a tested task-completion/reset flow. Clean install, full source coverage, strict compilers, **9 tests**, and production build passed. [App build](evidence/generated-app-build.txt).
- Single-player `verification-game` retains Babylon Lite WebGPU and Pixel Perfect rendering, uses a portrait default, and adds typed rules for a three-star objective, pause, win and replay with keyboard and pointer/touch controls. Clean install, full coverage, strict compilers, **23 tests**, and production build passed. [Game build](evidence/generated-game-build.txt).
- Headless Microsoft Edge (no headed windows) verified both production builds at 1280×720 and 390×844, renamed subpath URLs, responsive viewport fitting and reload. The game initialized WebGPU, accepted keyboard/emulated touch, blocked progress while the shell dialog paused it, won, and replayed. The app completed/reset a task and mounted no canvas. Zero uncaught page errors; isolated contexts, browser and preview servers closed in `finally`. The acceptance runner itself passed the same strict flags. [Browser results](evidence/generated-browser.json), [app screenshot](evidence/verification-app-1280.png), [game screenshot](evidence/verification-game-390.png). Touch is browser emulation, not physical-device testing.
- Template/generated dependency installation reports one existing high-severity advisory in the retained template dependency tree. Runtime dependency upgrades were outside this migration; no automatic audit fix was applied.

## Requirement and scenario traceability

| Requirement/scenarios | Evidence |
| --- | --- |
| Upstream authored TS inventory; workflow JS extraction | Source inventories, source-negative fixtures, all-workflow path/gate audit, generated handler fixture |
| Complete strict coverage; test/probe type errors; orphan TS | Three server/two template compiler roots, negative TS2322 cases, tracked/untracked orphan checks |
| Template consumers inherit baseline and renamed Pages paths | Renamed template check above; generated app/game build logs and headless production flows |
| Every shared export supplies runtime/types; clean TS and existing JS consumers | Packed export/file manifest, Bundler/NodeNext negative and positive contracts, compiled JS import/load checks, installed-artifact integration regressions |
| Delivery source/type failures block build/publication | Injected build failure; workflow gates and fresh publish-job install/build/verify construction |
| New strict apps/games; JS/custom starter and local-only instructions | Creation entry points and delivery/quality references require conversion of copied JS, complete compiler ownership, negative guards and local-only verification; generated local app/game evidence |
| Browser quality gate without disruptive windows | Headless Edge actual WebGPU, keyboard/emulated touch, pause/outcome/replay and screenshots |
| Exact released multiplayer artifact, legacy blocker, server-first/Hobby | Updated multiplayer skill requires verifying the selected release tarball and blocks legacy untyped assets; local exact-tarball checks demonstrate the contract. No new artifact is claimed published. |
| Staged/stable compatible version and bounded-session verification | **Conditional public scenario remains unverified**: tasks 8.1/8.2 require separate deployment/publication authorization. Local tests cannot establish public-host continuity or release status. |

## Release handoff

All local implementation/acceptance work is complete. Tasks 8.1 and 8.2 remain intentionally unchecked because no deployment, promotion, commit/push or release publication was requested. The new client artifact is local verification output; existing remote release assets are unchanged and may still lack declarations. Do not claim a new generated multiplayer game can consume a published typed release until the exact authorized release asset passes the documented gate. On authorization, use the existing staged release, exact-version/game-specific two-client checks, 240-second Hobby probe, stable verification and rollback sequence; keep stable unchanged on staging failure.

Final library checks: both creation skills passed `quick_validate.py`, scoped `git diff --check` passed, and `openspec validate modernize-typescript-creation-workflow --strict` passed. OpenSpec confirms **25/27** tasks complete; only the two explicitly conditional public rollout tasks remain.

## Approved finalization scope

The user approved separating the two public release tasks into `release-typescript-creation-workflow`. The original 25 local tasks are complete; no release task was falsely marked complete. Earlier 25/27 counts above describe the pre-separation state. The local migration now has 25/25 tasks; the follow-up retains both unchecked public tasks and does not authorize their execution.

The user's final policy request is explicit in the template AGENTS.md, README, usage checklist and coding standards: every template use and future human/AI update must retain strict TypeScript. Multiplayer AGENTS.md and README now require strict TypeScript for every contributor and change scope, including all games, shared client, tests, probes and release/deployment tooling. Existing coverage and compiler gates enforce the rule. Documentation checks and scoped whitespace validation passed after these wording changes.

The user subsequently authorized including the template's existing lowercase naming/import/doc work in its commit, and requested server deployment plus smoke tests. Deployment execution and results belong to `release-typescript-creation-workflow`; client asset publication remains separate.

## Pushed upstream revisions

- Template migration and approved existing naming work: `67d284e672a8ce17315c874f9110df98d001de22`, verified on `origin/main`.
- Multiplayer migration: `bf5c39b`; whitespace-only follow-up `d17cf381a4ed9cab0d2af27b91dbb25c10de5ff4`, verified on `origin/main`. Both owning worktrees are clean.
- Scoped path decisions are recorded in the two commit-scope evidence JSON files. Server deployment verification was dispatched separately under the user's new authorization and is tracked in `release-typescript-creation-workflow`. No client release asset was published by these commits.
