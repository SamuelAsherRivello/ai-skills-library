# Proposal

## Why

The library currently documents an optional global junction installation, which
causes a working checkout edit to change globally available skills immediately.
Skill authors need an explicit, reviewable copy lifecycle between a project,
the global Codex skills directory, and the shared Git library instead.

## What Changes

- **BREAKING** Replace junction and symbolic-link-based global installation
  with explicit copy workflows; existing link-based installation guidance is
  retired.
- Add `ai-skills-library-push <skill|all>` to copy one named global skill, or
  an explicitly requested complete set, into the local library checkout. It
  preflights the whole request and reports a clear no-change message when the
  user cannot write to that checkout.
- Add `ai-skills-library-pull <skill|all>` to copy one named library skill, or
  an explicitly requested complete set, into the global Codex skills directory.
- Add `ai-skills-library-promote <skill>` to copy one named project-local
  skill into global skills for cross-project testing, and
  `ai-skills-library-demote <skill>` to copy one named global skill into a
  project's local skill directory for project-scoped editing.
- Require each command to copy rather than move, reject unapproved replacement
  conflicts, validate sources before copying, and report changed, skipped, and
  failed skills separately.
- Update the existing library update/welcome guidance and README documentation
  to describe this lifecycle. The copy commands do not fetch, commit, or push
  Git history; normal Git operations remain deliberate user actions.

## Capabilities

### New Capabilities
- `skill-copy-lifecycle`: Explicit, safe skill-copy commands between project,
  global Codex, and local library locations without filesystem links.

### Modified Capabilities

- None.

## Impact

- Affected skills: `ai-skills-library-update`, `ai-skills-library-welcome`,
  and four new lifecycle skills.
- Affected documentation: README and the global-installation guide.
- Affected user locations: project `.agents/skills`, the local library
  checkout, and the user's global Codex skills directory.
- No automatic remote Git, GitHub, junction, symbolic-link, deletion, or
  replacement operation is introduced.
