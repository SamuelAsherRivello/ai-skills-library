# Quality gate and delivery

Read after the mandatory intake/access gate and before release. A game-delivery request must publish a playable public GitHub Pages game; single-player has no backend, while multiplayer also deploys and verifies its Vercel backend. Planning-only work stops at the requested artifacts and must state that it was not published. Do not offer a local-only handoff as a substitute for blocked access.

## Quality gate

Require a pinned compatible TypeScript toolchain and lockfile. Use `strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`, `verbatimModuleSyntax`, and consistent filename casing. Separate browser and Node configurations with appropriate libraries/module resolution; include game source, React components, tests, Vite configuration, and tools. Use type-only imports and validate `unknown` at external boundaries. Do not suppress migration errors with blanket `any`, `@ts-nocheck`, permissive ambient modules, or weaker settings.

Provide `npm run typecheck` that checks every authored TypeScript file and `npm run check:typescript-source` that rejects authored JS/JSX/MJS/CJS and uncovered TS/TSX. Check both tracked and untracked non-ignored first-party files, excluding only generated output, dependencies, and identified external fixtures. Convert executable JavaScript embedded in workflows to checked TypeScript scripts. Keep shell orchestration in its native language. Verify the commands reject a temporary type error and an orphan source file in disposable fixtures, then remove those fixtures.

Run source coverage, typecheck, meaningful tests, and production build before release; make applicable CI/build/delivery workflows block on failures. Vite builds and TypeScript runners alone do not typecheck. Update HTML entries, imports, npm scripts, workflow paths, and documentation when migrating a copied starter. Record commands, compiler coverage, and outcomes alongside existing verification evidence.

Run `$ai-skills-triage-analyze` and create its required packet. Check discoverable canonical instructions, verified commands, project/module map, definition of done, maintenance relationships, and safety boundaries.

Apply only bounded, behavior-preserving conformity gaps through `$ai-skills-triage-standardize`. Verify changes and rerun Analyze after standardization. Keep rules, scoring, progression, and transitions independently testable from Babylon rendering, browser input, and network transport where meaningful. Preserve single-player and multiplayer delivery paths.

Defer module ownership, public contracts, dependency direction, state ownership, and communication changes to `$ai-skills-triage-rearchitect`; do not refactor automatically. Report final packet, Standardization and Architecture scores, verification evidence, and deferred candidates.

## Documentation

Document setup, controls, gameplay, browser requirements, actual screenshots, asset sources, and known limits. Preserve useful template credits and its Original AI Prompt source link when available. Also preserve the actual request in a collapsible fenced-text block, following [Pixel Walker's presentation](https://github.com/SamuelAsherRivello/babylon-lite-pixel-walker). Label consequential follow-ups separately and keep assumptions outside the quoted request. Never fabricate a prompt URL or present an expanded brief as the original prompt. Redact private information; include timing/model metadata only when recorded.

## Release and verify

Finish the template checklist. Verify production assets under the GitHub Pages repository subpath and consistent version data from the template's source of truth. Adapt missing game-specific build/deployment wiring before invoking a release skill that expects working infrastructure.

Inspect and use checked-in GitHub Actions release and Pages workflows. Commit/push only task-related changes in game and applicable server repositories, preserving unrelated work and respecting branch instructions. Do not create a PR unless requested.

Run and monitor release; verify tag, release, and intended revision. If the release bot commit does not trigger Pages, dispatch the existing Pages workflow for that revision. Wait for deployment, then check the actual public game with the unobtrusive browser policy: startup, assets, controls, and displayed release version. A green workflow alone does not verify gameplay.

Fetch and fast-forward release-generated commits without discarding local changes. Recheck local/remote revision alignment and Git status. For authentication, workflow, permission, or remote-conflict failures, preserve work and identify the unfinished step; never force-push or claim publication.

Return playable GitHub Pages, public repository, release, and local checkout links with quality-gate results, completed checks, and unverified criteria/blockers. For multiplayer, separately include the verified Vercel backend deployment. State OpenSpec completion accurately and use the applicable finalization workflow within the request's authorization. If publication is blocked, report the blocker rather than implying delivery is complete.
