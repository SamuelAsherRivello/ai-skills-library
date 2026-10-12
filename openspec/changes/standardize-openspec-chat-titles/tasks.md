# Tasks

## 1. Define shared OpenSpec title behavior

- [x] 1.1 Add automatic, user-override-safe title-management guidance to every catalogued OpenSpec skill, assigning `exp`, `dec`, `dsh`, `prp`, `rev`, `app`, `apw`, `syn`, `arc`, `cmt`, `fin`, and `orc`; verify each format matches the title-management spec.
- [x] 1.2 Update the two apply workflows to derive zero-padded task progress from verified OpenSpec task counts and render it at the title end; verify titles use `OS-app` and `OS-apw` with `(07/10)`-style counts.
- [x] 1.3 Document the supported-title-tool fallback and user-override/unrelated-request opt-out for title-managing workflows; verify no workflow treats a title failure as task failure.
- [x] 1.4 Update the shared OpenSpec footer and affected skill instructions with the `Coordination` line; verify standalone, orchestrator, and managed-agent outputs remain unambiguous.

## 2. Align orchestration behavior

- [x] 2.1 Update orchestration instructions and naming configuration to use `[OS-orc: {change}]` for the lead; verify prior role prefixes remain safely migratable.
- [x] 2.2 Update managed-agent naming to use only `[{old-name}]`, including idempotence and durable user-override handling; verify no managed agent receives a role, slug, or progress suffix.

## 3. Complete library integration

- [x] 3.1 Register and document `openspec-orchestrate` in the OpenSpec catalog and suggested-flow guidance; verify catalog tests include every physical OpenSpec skill exactly once.
- [x] 3.2 Add or update focused tests for title format mapping, apply progress placement, and orchestration bracket behavior; verify the relevant test suite passes.
- [x] 3.3 Validate each changed skill structure, catalog consistency, OpenSpec delta specs, and whitespace; verify the validation commands report success.

## 4. Synchronize and publish scoped skills

- [x] 4.1 Update push, pull, and move lifecycle skill instructions and shared helper behavior to compare conflicts by quality and recency; verify a clearly better newer copy is selected automatically and an unclear or inferior one requests user direction.
- [x] 4.2 Copy validated changed skill directories to global discovery only after the comparison policy selects their source, and verify physical-directory content equality.
- [x] 4.3 Commit only the scoped library and OpenSpec change files, then publish through the repository's normal authorized Git workflow; verify the remote commit contains the validated changes.
