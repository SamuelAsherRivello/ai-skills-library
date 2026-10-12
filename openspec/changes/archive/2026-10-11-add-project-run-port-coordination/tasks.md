# Tasks

## 1. Configuration reference and declaration contract

- [x] 1.1 Add `.agents/skills/ai-skills-run/references/run-configuration.md` with the agent-agnostic declaration schema, `4000–10000` default pool, TCP validation rules, examples, missing/invalid behavior, and bounded approval policy; verify the document contains every contract named by `project-run-port-coordination/spec.md`.
- [x] 1.2 Define and implement parsing/validation for `.agents/project-run-configuration.md` while preserving existing launcher configuration compatibility; verify valid, missing, malformed, reversed, and out-of-bounds declarations with focused tests.
- [x] 1.3 Document the project-specific Start skill's delegation to the reusable port-coordination reference; verify the compatibility guidance points to the canonical reference and does not introduce a second policy.

## 2. Range-bounded startup and lifecycle safety

- [x] 2.1 Update `ai-skills-project-run-start` and its helper to resolve an effective range and select only the preferred port or fallback candidates inside that range; verify occupied-port fallback and exhausted-range tests preserve unrelated listeners.
- [x] 2.2 Preserve and extend run-record data with the effective range, selected port, and declaration provenance where available; verify Start writes a re-readable record and still enforces the one-project-server invariant.
- [x] 2.3 Update Stop guidance and implementation checks so range metadata never replaces project-root/process ownership evidence; verify an unrelated listener on a candidate port is never terminated.

## 3. Cross-project status and reconciliation

- [x] 3.1 Extend Status guidance and supporting inspection logic with an all-projects view grouped by verified project root, including active ports, declarations, missing declarations, occupied candidates, and overlapping ranges; verify output distinguishes active collisions from declaration overlap.
- [x] 3.2 Add reconciliation-plan behavior that names affected project documents and proposed ranges, applies one approval only to that identified set, and revalidates each edited declaration; verify declined approval leaves every document unchanged.
- [x] 3.3 Add fixtures covering multiple projects with disjoint ranges, overlapping ranges, undeclared projects, unrelated listeners, and ambiguous ownership; verify the report remains read-only unless the user-approved reconciliation path is explicitly selected.

## 4. Catalog and integration verification

- [x] 4.1 Update the Run skill catalog and any generated skill-copy metadata so the shared reference is distributed with the reusable Start/Status/Stop skills; verify catalog and copy-lifecycle checks pass.
- [x] 4.2 Run the focused Run-skill tests and OpenSpec validation, then inspect the final diff for unrelated changes; verify all declared routes/ownership behaviors remain covered and report any environment-limited checks.
