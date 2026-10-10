# Tasks

## 1. Update the application creation workflow

- [x] 1.1 Add a triage quality-gate section to `.agents/skills/ai-skills-create/ai-skills-create-app/SKILL.md`, including AI-readiness evidence, a final Analyze packet, and conditional Standardize/Rearchitect routing; verify the workflow still excludes game-specific setup.
- [x] 1.2 Add application architecture expectations for feature ownership, adapter boundaries, and presentation-independent tests; verify the guidance preserves valid template conventions.

## 2. Update the game creation workflow

- [x] 2.1 Add the shared triage quality gate to `.agents/skills/ai-skills-create/ai-skills-create-game/SKILL.md` after implementation and before final delivery; verify it does not weaken the existing OpenSpec, browser, WebGPU, release, or Pages requirements.
- [x] 2.2 Make independently testable game rules and explicit rendering/input/network boundaries a concrete creation acceptance criterion; verify both single-player and multiplayer paths remain covered.

## 3. Validate the workflow contract

- [x] 3.1 Validate the OpenSpec change with the installed CLI's supported strict validation command and resolve any artifact errors.
- [x] 3.2 Inspect the final skill diff for scope, safety, and product-boundary regressions; verify no unrelated files are changed.
- [x] 3.3 Archive the completed OpenSpec change, sync its capability specs, and verify the archived artifacts and main specs contain the intended requirements.
