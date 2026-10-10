# Proposal

## Why

The application and game creation skills currently focus on producing a working
deliverable, but they do not require an evidence-backed standardization and
architecture baseline before reporting completion. As a result, a newly
created repository can be functional while still scoring poorly on triage
because its instructions, module boundaries, test seams, and maintenance
relationships are undocumented or inconsistent.

## What Changes

- Add a creation-time triage quality gate shared by `ai-skills-create-app` and
  `ai-skills-create-game`.
- Require a post-implementation `triage-analyze` packet and a final score for
  each generated repository.
- Apply safe, approved-by-workflow conformity improvements through
  `triage-standardize` before the final analysis.
- Require creation workflows to establish AI-readiness evidence: canonical
  instructions, command discovery, project orientation, definition of done,
  maintenance relationships, and safety boundaries.
- Require explicit architecture seams appropriate to each product type,
  including independently testable application or game rules where applicable.
- Treat `triage-rearchitect` as a conditional, deferred workflow for material
  ownership, contract, dependency-direction, state, or communication findings;
  do not run structural refactors automatically.
- Preserve existing delivery boundaries: app creation remains non-game and
  game creation retains its Babylon Lite, OpenSpec, testing, and release flow.

## Capabilities

### New Capabilities

- `creation-quality-gates`: Creation workflows produce an evidence-backed
  triage baseline and address safe standardization gaps before delivery.

### Modified Capabilities

- `application-and-release-workflows`: The application creation workflow gains
  a required triage quality gate while remaining independent of game-specific
  setup and release behavior.

## Impact

- Affected skill instructions:
  `.agents/skills/ai-skills-create/ai-skills-create-app/SKILL.md` and
  `.agents/skills/ai-skills-create/ai-skills-create-game/SKILL.md`.
- Affected documentation contracts and OpenSpec capability specifications.
- Generated repositories will contain additional orientation, verification,
  and architecture evidence and may include focused tests or documentation
  needed to satisfy the triage baseline.
- No new runtime dependency is required. `triage-rearchitect` remains an
  explicitly triggered follow-up rather than an automatic mutation step.
