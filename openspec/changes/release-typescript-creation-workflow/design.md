# Design

## Context

Local strict TypeScript implementation and tests are recorded in the archived modernize-typescript-creation-workflow change. This follow-up retains its two unchecked public rollout tasks without representing them as complete.

## Decisions

Use existing workflows only. Before an authorized rollout, confirm pushed upstream revisions, select a new semantic version, validate exact package contents and rerun the applicable gates. Verify staged health/version, every required game-specific two-client check and the 240-second probe before promotion. Verify stable version and consumers before publication. Keep stable unchanged after a staging failure and use the existing rollback sequence after promotion failure. Never add hosts, paid plans or persistence promises.

## Authorization

The user subsequently authorized committing/pushing the repositories and deploying the multiplayer server with smoke tests. Run the existing Deploy backend release workflow for the exact pushed commit, including its staged/stable verification and rollback controls. Tags and client release publication remain unauthorized.
