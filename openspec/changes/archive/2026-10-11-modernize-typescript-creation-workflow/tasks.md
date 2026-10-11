# Tasks

## 1. Creation instructions in ai-skills-library

- [x] 1.1 Add mandatory strict TypeScript authoring to both creation skill entry points, including tests/config/tooling and copied JavaScript starters; verify both skills pass `quick_validate.py` and retain existing mode/delivery boundaries.
- [x] 1.2 Add full compiler/source-coverage and blocking CI/build checks to game delivery and app quality-gate references; verify each requires `npm run typecheck`, `npm run check:typescript-source`, tests, build, and negative coverage checks without blanket suppressions.
- [x] 1.3 Add exact-artifact shared-client declaration verification to the multiplayer reference; verify typed-consumer checks, legacy artifact blockers, compatibility, Vercel Hobby, and headless/minimized browser constraints remain explicit.
- [x] 1.4 Review skill references and the full plan for consistency with existing creation quality specs; verify relative links resolve, `git diff --check` passes for scoped files, and `openspec validate modernize-typescript-creation-workflow --strict` succeeds.

## 2. Template compiler coverage in github-repository-template

- [x] 2.1 Enter the template's owning checkout, read its instructions/OpenSpec context, and record current revision, working-tree changes, runtime/toolchain and executable-file inventory; verify the recorded baseline includes source, tests, config, workflows and script entry points without modifying unrelated work.
- [x] 2.2 Add pinned compiler, React/Node types, `tsx`, strict base and browser/Node configs with complete includes; verify clean `npm ci`, configuration parsing and a disposable test/config type-error case that fails as expected; record remaining migration diagnostics for group 3 rather than weakening checks.
- [x] 2.3 Add checked `check:typescript-source` tooling with generated/dependency/external-fixture exclusions; verify it rejects authored JS and tracked or untracked orphan TS without excluding first-party tests/tools, and document the commands/exclusions.

## 3. Template source, tests and delivery commands

- [x] 3.1 Convert React contexts/components and application modules to TS/TSX, preserving storage, input, canvas/WebGPU and Pixel Perfect behavior; verify typecheck and relevant lifecycle/settings/rendering regressions pass.
- [x] 3.2 Convert Vite configuration, Node tests and executable JavaScript tooling, update imports/HTML entries and source-inspection assertions; verify inventory has no authored JS and test assertions still cover behavior rather than only filename changes.
- [x] 3.3 Wire source coverage/typecheck/tests into production build and applicable CI/Pages/release checks; verify a fixture type error blocks build/delivery and a clean production build retains repository-subpath assets.
- [x] 3.4 Update `AGENTS.md`, template checklist and README commands/rename guidance; verify a disposable renamed template copy runs documented coverage, typecheck, tests and build successfully and inspect layout/gameplay with headless or minimized automation.

## 4. Multiplayer compiler coverage and server source

- [x] 4.1 Enter the server's owning checkout and record current instructions/OpenSpec context, revision, working-tree changes, export inventory and all script/workflow callers; verify the inventory covers every registered game, simulation, client module, test and probe.
- [x] 4.2 Extend strict compiler coverage across server, browser client/rules, tests and tools using separate Node/browser configurations, and add source-coverage tooling; verify error injection in a probe/test and orphan-file cases fail the documented checks, and document compiler ownership.
- [x] 4.3 Convert JavaScript simulations and shared rule implementations to TypeScript and remove replaced handwritten declaration companions; verify existing rule, serialization and registered-game regressions pass without changing protocols or authority semantics.

## 5. Typed shared-client build and packaging

- [x] 5.1 Convert shared client lifecycle/helpers to TypeScript with useful per-game state/action/subscription types while preserving generic API and recovery behavior; verify lifecycle/admission/rule regressions and positive/negative contract tests.
- [x] 5.2 Add clean ESM/declaration output, root types metadata and per-export type/runtime mappings; verify all supported imports resolve from packed output with unchanged package/tarball naming and no source-checkout or Node-only browser dependencies.
- [x] 5.3 Add clean tarball consumer fixtures for Bundler and NodeNext typing plus generated plain-JavaScript runtime consumers; verify every supported export and required declaration dependency, invalid-call rejection and loader-free JavaScript execution.
- [x] 5.4 Update client README/API documentation and package installation examples; verify documented imports/commands against the packed artifact and existing consumer import patterns without publishing it.

## 6. Multiplayer tests, scripts and workflows

- [x] 6.1 Convert all remaining Node tests and local/live probes to checked TypeScript and update npm invocations; verify full local regressions and safe local probe fixtures preserve env/CLI contracts, outputs and failure codes, and document renamed commands.
- [x] 6.2 Convert credential-presence, documentation, version-setting and deployment-selection tools; extract inline workflow JavaScript into checked TS; verify fixture/dry-run tests preserve secret redaction and side-effect boundaries, and document tool entry points.
- [x] 6.3 Update all affected PR, release, feasibility, diagnostics and game-specific deployment workflow paths and gates; verify source/type failures block delivery, each clean packaging job builds declarations before pack, and fresh publish-job artifact construction works without deployment/publication.
- [x] 6.4 Update server instructions, docs and release recovery guidance; verify source coverage, strict typecheck, full tests, client build and tarball-consumer checks from a clean install while retaining Hobby configuration and bounded-session semantics.

## 7. Cross-repository acceptance and handoff

- [x] 7.1 Generate disposable non-game app and single-player game projects from the migrated template using updated creation instructions; verify complete TS coverage, strict typecheck, tests, build, renamed paths and relevant headless/minimized browser flows without publishing.
- [x] 7.2 Install the packed shared client in a typed multiplayer consumer fixture and exercise a local two-client game flow, reconnect/expiration and supported authority behavior; verify compatible types/runtime behavior and document any unverified public-host behavior separately.
- [x] 7.3 Record upstream revisions, full compiler/source inventories, commands, tarball contents and consumer regression evidence in this change; verify every requirement/scenario has matching evidence and report any unfinished upstream work without claiming migration complete.

## Release follow-up

The user approved moving the two unchecked public rollout tasks to `release-typescript-creation-workflow`. All 25 local implementation tasks are complete; release actions remain unauthorized and unperformed.
