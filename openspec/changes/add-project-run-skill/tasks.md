# Tasks

## 1. Skill and terminal workflow

- [x] 1.1 Add `.agents/skills/ai-skills-run/ai-skills-run-project/SKILL.md` and its UI metadata, covering project discovery, existing `dev` scripts, package-manager preservation, and non-invasive startup; verify the skill passes the repository skill validator.
- [x] 1.2 Define stable project-port derivation, bounded availability probing, same-project process reuse, and failure behavior; verify the instructions include occupied-port, exhausted-range, and healthy-existing-instance scenarios.
- [x] 1.3 Document integrated ChatGPT/Codex terminal reuse with a local fallback and process-identification guidance; verify the workflow does not instruct Windows users to spawn a separate terminal window when the app terminal is available.

## 2. Catalog and workflow documentation

- [x] 2.1 Add the run category catalog and link `ai-skills-run-project`; verify both catalogs describe the skill's scope and invocation role.
- [x] 2.2 Update the root library catalog with the new category; verify every added catalog link resolves to an existing file.

## 3. Validation

- [x] 3.1 Run OpenSpec validation for `add-project-run-skill` and verify all proposal, capability, design, and task artifacts are complete and consistent.
- [x] 3.2 Perform a read-only review of the final skill against the project catalogs and existing run-specific skills; verify no existing files outside the requested skill and catalog scope are modified.
