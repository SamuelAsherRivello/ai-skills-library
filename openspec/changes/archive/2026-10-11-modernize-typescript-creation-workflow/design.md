# Design

## Context

See `proposal.md` for motivation and scope. Read-only inspection on 2026-10-11 found:

| Surface | Observed baseline | Migration consequence |
| --- | --- | --- |
| Template | 10 `.js`, 8 `.jsx`, 2 `.mjs` files on GitHub `main`; `project-name/src`, two Node tests, `vite.config.js`; Vite build without typechecking | Convert source/config/tests and add complete compiler and CI gates |
| Multiplayer | Strict ES2022/NodeNext compiler includes only `server.ts` and `multiplayer-server/src/**/*.ts` | Add client, tests, probes, and scripts to explicit checking coverage |
| Shared client | Version 0.9.13 metadata exports JavaScript, without generated type exports | Build a browser-safe package and test the actual packed artifact |
| Server simulations | Some implementations remain `.js`; combat/Bomberman have handwritten `.d.ts` companions | Convert implementations and remove stale companion declarations instead of merely preserving wrappers |
| Server workflows | PR/release run typecheck/tests and pack the client; release also embeds JavaScript version checks and invokes `.mjs` scripts | Update invocation paths and build client artifacts before pack in every fresh job |
| Creation skills | No strict TypeScript contract; app/game mode, triage, unobtrusive browser testing, and Vercel constraints already exist | Add a compact invariant and concrete quality-gate checks without replacing those constraints |

GitHub tree identities inspected during exploration were template `49d6c20741f2aaac509f7954392d72526614aca6` and server `2de6385289f8ded695250b1e4c5599241d2d28de`. These identify trees, not commit SHAs. Revalidate actual revisions at implementation start. Local template filenames differ in capitalization from the published tree, so use the actual target checkout's paths and case.

## Goals / Non-Goals

Goals are complete first-party authoring coverage, useful public types, unchanged gameplay/network semantics, and reproducible commands from clean installs. New projects must satisfy this contract even while upstream migration remains pending.

Non-goals are migrating existing generated games/apps, changing hosting or renderer, redesigning simulation ownership, introducing persistence, upgrading every dependency to the newest release, or releasing/deploying as part of this planning request. Existing consumers are regression fixtures only.

## Decisions

### 1. Coordinate locally, execute upstream work in its owning repository

Keep this proposal and its requirements/tasks in the skills library. Template and server implementation sections name their owning checkout. Before applying either section, enter that checkout, read its instructions and OpenSpec context, and obtain the filesystem permissions required by the environment. Record its implementation evidence here without treating this library's `allowedEditRoots` as cross-repository permission. Do not initialize an upstream OpenSpec root as a side effect.

The user explicitly requested creation-skill edits in addition to a plan. Make only those instruction changes now and mark their corresponding tasks complete after validation. Upstream code tasks stay unchecked. This avoids both silently implementing the migration and postponing the expressly requested skill updates.

### 2. Define modern TypeScript through checked configuration and authoring boundaries

Use a pinned, toolchain-compatible TypeScript compiler; the server's inspected 5.9.3 is the initial compatibility baseline, not a claim about the newest version. Retain the server's Node 24 runtime. Pin template Node/tool runner versions compatible with its inspected Vite version and CI. Update lockfiles.

Use a shared compiler base per repository with `strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`, `verbatimModuleSyntax`, and consistent filename casing. Use type-only imports and `unknown` plus validation at external boundaries. Avoid blanket `any`, `@ts-nocheck`, permissive ambient module declarations, or weakening checks to silence migration errors. Narrow, documented boundary assertions are permitted; negative compile tests may use targeted `@ts-expect-error` with a concrete expected invalid call.

Template browser configuration uses ES2022, ESNext modules, Bundler resolution, DOM libraries, `react-jsx`, and no emit. A separate Node configuration checks Vite config, tests, and tools. Multiplayer server/tools use ES2022/NodeNext and Node types. Shared browser client/rules use a browser-safe configuration and a declaration-emitting build configuration. Separate environments avoid making Node APIs appear valid in browser code. Generated output and dependencies are excluded, not first-party tests or scripts. `skipLibCheck` may avoid third-party declaration checks; it must not hide first-party source or package contract checks.

JavaScript emitted by the compiler/Vite remains normal output. Existing Bash/PowerShell orchestration, JSON, YAML, HTML, and CSS retain their native formats. First-party JavaScript in YAML heredocs or inline Node commands moves into checked `.ts` files; trivial shell commands need no translation. External fixtures must have identified provenance and a specific exclusion rather than a blanket exemption.

Alternatives rejected are `checkJs` as the finished migration, file renames without compiler coverage, and handwritten declarations over unchecked JavaScript implementations. Each leaves part of the requested authoring contract unproved.

### 3. Preserve template behavior while converting source and test tooling

Convert JSX components to TSX and other modules/configuration to TS. Type props, contexts, settings/storage parsing, DOM events, canvas/WebGPU references, scene lifecycle, and sprite/camera helpers. Retain logical-resolution and Pixel Perfect semantics. Update HTML entry references, imports, documented commands, source-inspection tests, and folder-rename guidance. Use actual package exports rather than inventing broad Babylon ambient types.

Keep the Node test runner and add a pinned `tsx` runner for tests/tools, matching the server's current runner approach. Transpilation does not replace `tsc`. Audit source-string tests that hardcode `.jsx` or `.js` and update them while retaining meaningful behavioral assertions. Typecheck both tests and fixtures that represent first-party code.

Add `npm run check:typescript-source`, itself checked TypeScript, which compares tracked and untracked non-ignored first-party executable files with each compiler program's included files. Fail on remaining authored JS/JSX/MJS/CJS and orphan TS/TSX; use explicit generated/dependency/external-fixture exclusions. `npm run typecheck` checks every compiler configuration. This catches gaps that a passing `tsc` alone misses.

### 4. Convert shared server and client contracts without protocol changes

Convert JavaScript simulations and shared rules/client implementations to TypeScript; remove obsolete declaration companions when implementations generate their declarations. Retain game identifiers, action validation, room/seat/reconnect semantics, serialization fields, timers, and public supported imports. Type network boundaries without trusting wire data through casts.

Use per-game state/action contracts and typed subscription/send APIs while retaining existing generic/legacy call shapes and behavior. Preserve all supported package export specifiers and browser compatibility. Emit ESM `.js` and `.d.ts` into a clean `dist` directory; package metadata maps each supported export to matching `types` and runtime entries, with root types metadata. Include relative declaration dependencies and any required public compatibility entry files discovered in consumer imports. Keep package name and tarball basename unchanged.

Tests install a newly packed tarball into clean fixtures. A fixture authored in TypeScript and compiled to plain JavaScript loads every supported runtime export without `tsx`; the emitted JavaScript is a generated-output exclusion, not an authored-JavaScript exception. Browser Bundler and NodeNext TypeScript fixtures import each supported export and check useful valid/invalid API calls. Runtime comparison tests exercise serialization and shared rules to detect behavior changes. Tarball content inspection must reject missing declarations, source-checkout imports, and Node-only dependencies reachable by browser entries.

Alternatives rejected are publishing raw `.ts` files as the only runtime entry and preserving stale handwritten declaration facades. They respectively break JavaScript consumers or allow types and implementation to disagree.

### 5. Convert scripts and enforce checks before building or packaging

Migrate all first-party `.mjs`/`.js` tests and root scripts, including documentation, credential-presence, version-setting, deployment selection, live probes, and game/session checks. Preserve command intent and outputs, CLI/env contracts, exit codes, secret redaction, and recovery behavior. Run safe fixtures/dry runs for mutating tools rather than changing real versions, aliases, credentials, or deployments during local tests.

Update PR, Pages, release, feasibility, diagnostics, and game-specific deployment workflows that invoke renamed paths. Each clean job that packs the shared client must build it first, including the release's fresh publish checkout. Gate template production build/Pages and server packaging/deployment on source coverage, complete typecheck, and meaningful regressions; Vite and `tsx` alone are insufficient.

When deployment is separately authorized, preserve staged verification, exact-version stable checks, game-specific two-client checks, the current 240-second probe below the configured 300-second limit, and rollback before publication. Do not change the fixed Vercel Hobby requirement or claim new persistence/renewal behavior.

### 6. Enforce the baseline in both creation skills immediately

State the mandatory TypeScript contract in each entry point. Put detailed compiler/coverage checks in each skill's existing delivery or quality-gate reference. A JavaScript shared or custom template is migrated in the copied project before handoff, without modifying upstream as a creation side effect. Verify all authored runtime, tests, and tools, plus `npm run typecheck`, tests, and build. Multiplayer also verifies useful declarations in the exact released client artifact and routes an untyped artifact through the existing server-first workflow rather than adding blanket local stubs.

## Risks / Trade-offs

- Stronger index/optional checks reveal real nullable states. Fix semantics deliberately and retain regression tests rather than mass-asserting non-null values.
- Renaming files can break case-sensitive Linux CI and source-inspection tests. Audit every import, HTML entry, npm command, and workflow path.
- A passing development checkout can hide a broken package. Clean tarball install tests run without source checkout or TS runtime loaders.
- Declaration builds add work to release jobs. Rebuild from the exact verified revision in each fresh packaging job.
- Existing exported APIs are broad and game-specific. Add accurate types without changing accepted runtime messages or claiming unsupported durability.
- Strict source inventory requires maintained exclusions. Verify exclusions cannot hide first-party implementations and test orphan-file detection.

## Migration Plan

1. Complete and validate local creation-skill edits. Existing unfinished upstream code remains explicitly recorded.
2. Implement and verify the template conversion in its own checkout, preserving behavior and documenting consumer customization steps.
3. Implement server/client conversion and comprehensive tool/test coverage in its own checkout; package and test fresh artifacts without publishing.
4. Run local full regressions and generate disposable single-player game and non-game app fixtures from the migrated template. Verify copied-project paths, coverage, strict typecheck, tests, build, and headless/minimized behavior checks. Install the packed client in a typed multiplayer fixture and verify the used contracts.
5. Record exact revisions, commands, source coverage, tarball contents, and fixture results. Only when separately authorized, run existing upstream release/deployment workflows and public checks; verify rollback controls first.
6. If a conversion fails, keep the previous published template revision/client package and deployment. Revert only migration-owned changes when necessary, preserve unrelated work, and never weaken the TypeScript requirement to claim completion. Existing consumers can remain pinned to their previous release during repair.
