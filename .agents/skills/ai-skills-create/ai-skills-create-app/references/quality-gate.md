# Creation quality gate

Read before final handoff or requested delivery.

Require a pinned compatible TypeScript toolchain and lockfile, with `strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`, `verbatimModuleSyntax`, and consistent filename casing. Separate browser and Node compiler environments; cover application source, React components, tests, configuration, and tools. Use type-only imports and validated `unknown` boundaries. Never hide migration errors behind blanket `any`, `@ts-nocheck`, permissive ambient modules, or weaker settings.

Provide `npm run typecheck` for all authored TypeScript and `npm run check:typescript-source` to reject authored JS/JSX/MJS/CJS or uncovered TS/TSX. Inventory tracked and untracked non-ignored files, excluding only generated artifacts, dependencies, and identified external fixtures. Move executable workflow JavaScript into checked TypeScript scripts; native shell orchestration retains its language. Verify failure on a temporary type error and an orphan file in disposable fixtures, then remove the fixtures.

Run source coverage, typecheck, meaningful tests, and production build before local handoff or requested delivery; applicable CI/build/delivery workflows must block on failures. A Vite build or TypeScript runner does not replace typechecking. Update entries, imports, npm/workflow paths, and documentation when converting the copied starter. Report compiler coverage and command outcomes.

- Run `$ai-skills-triage-analyze` against the generated repository and create its required packet.
- Check canonical agent instructions, discoverable verified build/test/lint/typecheck commands, project/module map, definition of done, maintenance relationships, and safety boundaries.
- Apply only bounded, behavior-preserving conformity gaps through `$ai-skills-triage-standardize`. Verify changes and rerun Analyze after standardization.
- Keep application behavior independently testable from React presentation and external adapters where meaningful. Preserve valid template conventions rather than forcing a generic source tree.
- Defer module ownership, public contracts, dependency direction, state ownership, and inter-module communication findings to `$ai-skills-triage-rearchitect`; do not refactor automatically.
- Report the final packet, Standardization and Architecture scores, verification evidence, and deferred candidates before claiming completion.
