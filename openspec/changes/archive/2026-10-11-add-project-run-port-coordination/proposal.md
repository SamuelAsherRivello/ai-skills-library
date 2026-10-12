# Proposal

## Why

Running several local Vite projects at once can make a familiar localhost URL
serve the wrong application when projects compete for default ports or use
undocumented fallback behavior. The Run skills need a shared, agent-agnostic
configuration reference and cross-project reconciliation contract so each
project stays inside an intentional port range and conflicts become visible
before they cause misleading previews.

## What Changes

- Add a reusable Run-skill reference at
  `.agents/skills/ai-skills-run/references/run-configuration.md` describing
  the project declaration format, supported TCP-port bounds, defaults, and
  reconciliation rules.
- Extend the Start, Status, and Stop skills to discover an optional
  project-local declaration under an agent-agnostic `.agents/` path, while
  preserving compatibility with existing project launcher configuration.
- Make Start choose and verify ports only within the active project's declared
  range; projects without a declaration retain a documented default range and
  receive a recommendation to declare one.
- Make Status provide an all-projects view that groups development processes by
  verified project root, reports occupied ports, overlapping declarations, and
  projects lacking a declaration.
- Permit one user approval to update the identified projects' range documents
  during a single reconciliation, while keeping unrelated projects and
  listeners untouched.
- Add tests and fixtures for parsing, range allocation, overlap reporting,
  exhausted ranges, missing declarations, and bounded approval-driven updates.

## Capabilities

### New Capabilities

- `project-run-port-coordination`: Coordinates declared development-port
  ranges, live listener ownership, cross-project overlap reporting, and safe
  range-bounded startup for the Run skills.

### Modified Capabilities

- None.

## Impact

- Updates the reusable Start, Status, and Stop skills under
  `.agents/skills/ai-skills-run/` and adds their shared reference document.
- Adds or updates the supporting launcher helper and its tests without
  changing application code, package managers, or production server behavior.
- Adds an explicit compatibility note to the project-specific Run Start skill.
- Introduces no new runtime dependency; the behavior relies on existing
  process, listener, project-root, and HTTP verification checks.
