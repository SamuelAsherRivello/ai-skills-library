# Deployment verification

The user authorized multiplayer deployment and smoke tests after the three-repository migration commits. Client release publication remains separate.

- Initial selected source: d17cf381a4ed9cab0d2af27b91dbb25c10de5ff4 on origin/main.
- Existing workflow: Deploy backend release, deploy.yml.
- Run: https://github.com/SamuelAsherRivello/rmc-colyseus-multiplayer-server/actions/runs/38140373555
- Initial run: cancelled before promotion after identifying the build environment issue below. The stable deployment was unchanged.

## Pre-deployment baseline

The stable health endpoint reported status ok and version 0.9.12 before promotion. The selected migration source declares 0.9.13, so exact-version checks distinguish it from the prior production deployment. The existing template Pages workflow independently completed successfully for 67d284e672a8ce17315c874f9110df98d001de22: https://github.com/SamuelAsherRivello/github-repository-template/actions/runs/38140382936.

## Local test isolation during the Vercel build

The initial workflow passed all 155 tests before staging. During `vercel build --prod`, the build ran the same tests with `VERCEL` inherited. The server intentionally suppresses its local listener in Vercel mode; local test fixtures therefore timed out. This was reproduced locally with `VERCEL=1` against the Garden test before changing the code.

Commit 315aa594d6716eb5cd019376d76ea9abd84365a6 adds a strict TypeScript local-test runner for the root build. It removes `VERCEL`, `SERVER_URL`, `ASTEROIDS_ONLY`, `MUSIC_ONLY` and `BLOB_READ_WRITE_TOKEN` only from the spawned local test process. Runtime configuration and the public workflow tests retain their existing environment semantics. The full source, type, documentation and test gates remain in the build.

Source coverage (136 compiler files), strict type checking, documentation checks and whitespace checks passed. Two new isolation tests plus the Garden regression passed with all five environment variables deliberately populated, including an invalid public endpoint. The original environment was preserved.

The replacement deployment uses exactly that pushed commit:
https://github.com/SamuelAsherRivello/rmc-colyseus-multiplayer-server/actions/runs/38141541561

That replacement run passed all 157 tests in CI and again inside the Vercel production build. It then failed in Vercel function compilation with TS2550 for `Object.hasOwn`; no deployment was promoted.

## Explicit server library for hosting compilation

The server configuration inherited an ES2022 target but did not explicitly select its standard library. Lowering the compiler target to ES2020 locally reproduced the missing `Object.hasOwn` and `replaceAll` types. Commit 72aea673a1c7531a000e04ce69ff344ee8a1aa55 explicitly selects `lib: ["ES2022"]` for the Node server, retaining the existing strict options and Node 24 runtime. The lowered-target reproduction, all three strict compiler configurations, source coverage and documentation checks pass after this change.

The next deployment selects exactly that pushed commit:
https://github.com/SamuelAsherRivello/rmc-colyseus-multiplayer-server/actions/runs/38142336920

The Vercel production build and exact staged-version health check passed on this revision. All local regression tests passed before staging and during the production build. The subsequent public game/session checks and promotion outcomes are recorded below.

The exact revision also passed `npm run build:client` and `npm run verify:client-package` under Node 24. All public exports load without a TypeScript loader, and package consumer type checks passed. No client artifact or tag has been published.

## Staged registered-game checks

The first public attempt passed 156 of 157 tests. The Asteroids fixed-host probe failed waiting for departed guests to release seats (`Guest drops did not release extra seats`). The existing single bounded retry reran that failed test with unchanged assertions and passed; the other 156 results were retained from the first attempt. Both logs are retained in `evidence/staged-game-first.log` and `evidence/staged-game-rerun.log`. This is not represented as 157 fresh tests passing on the retry.

The additional private Tetris gameplay/recovery gate passed. The subsequent long-session and stable outcomes are recorded below.

## Public session gates and production outcome

Run 38142336920 passed the 240-second relay session, 240-second Space Invaders session with host migration, and 600-second Asteroids continuity with four renewals, guest recovery and terminal host loss. It promoted deployment `dpl_AdDCjVdhrPEP1LRfWycFnFLSbfJy` (`https://rmc-colyseus-multiplayer-server-rkvamoz5k.vercel.app`) from source 72aea673a1c7531a000e04ce69ff344ee8a1aa55. Stable health reported the expected version 0.9.13 and all 17 registered games.

The initial stable two-client probe failed with `seat reservation expired`. The workflow invoked its default rollback command, which returned success but selected that same deployment. This did not restore the pre-rollout 0.9.12 deployment. The run remains failed; it is not presented as a successful end-to-end workflow.

The unchanged `npm run probe` was then rerun manually against the stable endpoint under Node 24. It exited successfully: two peers shared a feasibility room and echoed the same server instance, and the music relay passed its two-client epoch/absolute-step checks. The remaining stable Combat integration test passed (one test, including recovery, authority, populations and isolation). The stable Asteroids eight-second probe passed with guest recovery and terminal host loss. Public health still reports 0.9.13.

Deployment workflow correction ecd7e348f68671aa1227faaee39e5c8ec58b9046 captures the exact stable deployment ID before staging and uses it explicitly for rollback. It also permits exactly one retry of the unchanged stable probe while retaining both attempt logs. YAML parsing, every shell block's syntax, rollback output wiring, and isolated retry fixtures (first success, retry success, two failures) passed. This workflow-only change is pushed; it has not been exercised in another full public rollout. The deployed runtime remains the exact tested 72aea67 revision.

Task 1.1 is complete from the staged source/type/test/package and public-session evidence. Task 1.2 remains open: client artifact publication is not authorized, and the corrected rollback path has not been exercised in a real failure. No client artifact or tag was published.
