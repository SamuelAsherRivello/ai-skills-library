# Design

## Context

The existing creation skills already discover repository instructions, run
project checks, and (for games) require substantial browser and release
verification. The triage skills add a repository-wide evidence model: Analyze
is read-only, Standardize handles bounded conformity, and Rearchitect handles
selected structural refactors with an approval gate. This change connects
those workflows without changing the product-specific creation boundaries.

## Goals / Non-Goals

**Goals:**

- Make triage readiness an explicit completion criterion for both creation
  commands.
- Produce a final Analyze packet after safe improvements.
- Generate architecture and documentation evidence proportionate to the app or
  game being created.
- Keep structural refactoring conditional and user-controlled.

**Non-Goals:**

- Do not force one universal source tree onto React apps or Babylon games.
- Do not run `ai-skills-triage-rearchitect` automatically.
- Do not require `.aiignore` when repository-specific evidence does not justify
  it.
- Do not replace existing build, browser, release, or OpenSpec verification.
- Do not add a runtime package or alter the triage scoring weights.

## Decisions

### 1. Use Analyze as the final quality gate

The creation workflow runs Analyze after implementation and safe conformity
work. This makes the reported score evidence-based and keeps Analyze's
read-only boundary intact. A preliminary checklist may guide implementation,
but only the final packet is reported as the completion result.

### 2. Use Standardize only for safe gaps

The workflow may address missing instructions, command documentation, module
orientation, naming, and other behavior-preserving gaps. Findings involving
ownership, contracts, dependency direction, state, or communication are
recorded as candidates for Rearchitect instead of being auto-fixed.

### 3. Use product-specific seams

Application creation should keep feature/application behavior testable apart
from React presentation and external adapters. Game creation should keep game
rules and state transitions testable apart from Babylon rendering, browser
input, and network transport. The skills describe these as outcomes and let
the generated project preserve valid template conventions.

### 4. Keep the gate inside each creation skill

The app and game commands have different delivery and verification flows. A
shared conceptual gate is specified, but each skill owns its invocation order,
scope, and final report so the game workflow can retain its browser, WebGPU,
GitHub Pages, and multiplayer requirements.

## Risks / Trade-offs

- [Risk] Creation takes longer because a full triage packet is generated. →
  Mitigation: run only after implementation and reuse already discovered
  verification evidence.
- [Risk] Agents overfit to the generic standards tree. → Mitigation: require
  preservation of valid framework conventions and treat the standards tree as
  a decision aid, not a mandate.
- [Risk] A high score encourages superficial documentation. → Mitigation:
  require evidence links, actual command results, meaningful test seams, and
  explicit limitations; never treat documentation or builds as behavioral
  proof.
- [Risk] Automatic rearchitecture causes unintended behavior changes. →
  Mitigation: make Rearchitect a deferred, explicitly triggered follow-up with
  its existing advisor and approval workflow.

## Migration Plan

1. Update both creation skill files with the shared gate and product-specific
   architecture expectations.
2. Validate the skill text and OpenSpec artifacts.
3. On the next invocation of each creation command, use the gate for new
   repositories only; existing repositories remain unchanged until explicitly
   triaged.
4. If the first real run exposes an overly strict or ambiguous rule, revise
   the skill and capability spec through a follow-up change.
