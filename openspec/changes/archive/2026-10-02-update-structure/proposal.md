# Proposal

## Why

The library has grown beyond a convenient flat skill list, and its current
manual installation guidance does not give users a clear way to select skills
and target agents. Its OpenSpec updater also replaces upstream-owned skill
files wholesale, which can discard useful local adaptations.

## What Changes

- Organize skills into `.agents/skills/ai-skills-create/`,
  `.agents/skills/ai-skills-library/`, `.agents/skills/openspec/`, and
  `.agents/skills/docker-sandbox/`, while keeping each individual skill in its
  own directory with a `SKILL.md` and retaining root-level discovery metadata.
- Update skill-copy scripts, tests, the OpenSpec update workflow, documentation,
  and references to discover and use the categorized paths.
- Make `npx skills@latest add <owner>/<repo> --copy` the primary quick-install
  entry point for both Codex and Claude Code. Recommend project-local
  installation, document global installation and updates, and use the same
  installation section format in this repository and the separate
  `ai-skills-blender` repository.
- Keep Blender's existing package-specific PowerShell installers and detailed
  client guides as advanced options; do not merge the repositories or add a
  native Claude plugin.
- Update OpenSpec refresh behavior to merge upstream changes with local
  adaptations per skill, preserving non-conflicting edits and reporting
  conflicts for review without silently overwriting either side.
- Keep manual skill copy commands available. Do not add release/version
  automation, a mandatory repository setup wizard, or unrelated security
  hardening in this change.

## Capabilities

### New Capabilities

- `skill-library-installation`: Install selected library skills for chosen
  agents from either separate repository through a shared install entry point
  and README section format.
- `openspec-upstream-maintenance`: Refresh upstream-derived OpenSpec skills
  while preserving local adaptations and surfacing merge conflicts.

### Modified Capabilities

- `skill-copy-lifecycle`: Discover and copy skills from the categorized
  library structure while preserving the existing copy and conflict safeguards.

## Impact

- Skill directories under `.agents/skills/`, including their supporting files.
- Skill-copy helper scripts and tests.
- `scripts/update_openspec_skills.py`, its tests, the OpenSpec updater workflow,
  and upstream provenance data.
- README and installation/copy command documentation, diagrams, and path
  references.
- The separate `ai-skills-blender` repository's README and getting-started
  installation guidance; its history, source tree, and advanced installers
  remain independent.
- Users installing selected skills into Codex or Claude Code.
