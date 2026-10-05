# Proposal

## Why

The library has self-contained skill directories but no category-level discovery
surface or consistent invocation guidance. Its application-creation and release
workflows are also incomplete: users can create a repository or a game, but not
a non-game React application, and releasing is incorrectly presented as an
OpenSpec-specific operation.

## What Changes

- Add concise standalone `README.md` catalogs at `.agents/skills/` and in each
  existing category. Each catalog will link to its skills, state the category's
  purpose, and distinguish explicit workflows from model-reachable helpers
  where appropriate. Catalog and skill content will not reference external
  skill repositories.
- Add `ai-skills-create-app` beside the existing game and repository creation
  skills. It will create a React application from the shared repository
  template without game or Babylon-specific setup.
- Move and rename `openspec-release-version` to
  `ai-skills-create/ai-skills-release-version`. The revised skill will not
  require OpenSpec; it will validate a template-compatible release workflow,
  update `version.txt` according to the repository's established release rule,
  run and monitor the release, and verify the remote result.
- Update category and root documentation to present the new skill organization
  and a suggested, non-mandatory OpenSpec workflow: discover and plan, apply,
  sync specifications, archive, then commit and push. The release workflow
  follows a pushed release candidate but remains separate from OpenSpec.
- Normalize skill-facing metadata and content where needed so each skill has a
  clear purpose, safe trigger boundary, and completion outcome. Do not rename
  any other skill or change the four established category roots.

## Capabilities

### New Capabilities

- `application-and-release-workflows`: Create non-game React applications from
  the shared template and release template-compatible repositories through an
  existing version workflow without requiring OpenSpec.
- `skill-catalog-navigation`: Provide standalone category catalogs that let
  users discover skills and understand their intended invocation roles.

### Modified Capabilities

- `skill-library-installation`: Categorized skills must remain discoverable as
  self-contained installable directories while category catalogs document the
  available skill inventory.

## Impact

- Affected catalog: `.agents/skills/` and its four existing category
  directories.
- Affected skills: the new `ai-skills-create-app`, the relocated and renamed
  `ai-skills-release-version`, and metadata/content updates needed to make the
  catalogs accurate.
- Affected documentation: the root README and OpenSpec command guidance.
- The copy-lifecycle script remains compatible because both new creation
  workflows use the existing `ai-skills-create-*` category convention.
