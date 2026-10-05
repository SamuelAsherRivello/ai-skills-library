# Design

## Context

The library already stores installable skills beneath four category roots in
`.agents/skills`. The installer and copy-lifecycle helper rely on those roots
and on the existing skill folder names. See `proposal.md` for the motivation
and the accompanying spec deltas for the required outcomes.

## Goals / Non-Goals

**Goals:**

- Make the library navigable from category-level catalogs without changing
  installer discovery.
- Add a bounded non-game application workflow and make version release a
  standalone creation workflow.
- Publish a suggested OpenSpec sequence that accurately reflects existing
  skill prerequisites.

**Non-Goals:**

- Rename any existing skill other than the requested release-skill move.
- Add, remove, or rename category roots.
- Copy external skill text, names, links, or repository references.
- Change the copy-lifecycle operation or add release infrastructure to target
  repositories.

## Decisions

### Preserve the physical catalog; add documentation indexes

Keep `.agents/skills/<category>/<skill>/SKILL.md` as the only installable
skill layout. Add a root catalog plus one `README.md` per existing category;
these files are documentation only and do not alter installer selection.

The root catalog links to the four categories. Each category catalog contains
original one-line descriptions and direct relative links to its skills. It
labels invocation role only where it helps users choose safely; it does not
invent a new policy for every existing skill.

Alternative considered: move the catalog to a new top-level `skills/` tree.
This was rejected because it would break the established installer and
copy-lifecycle paths.

### Make the creation category own concrete repository outcomes

Add `ai-skills-create-app` beside the existing repository and game creation
skills. Its instructions will use the shared repository template, accept the
same practical repository identity inputs as the repository creator, choose an
application configuration, and reject accidental game scope rather than
silently adding game tooling.

Move the existing release skill to
`ai-skills-create/ai-skills-release-version`, changing its frontmatter name,
UI metadata, and prose so OpenSpec is neither a prerequisite nor a routing
condition. Retain its remote-state, workflow, and verification safeguards.
There will be one release skill after the move, not two competing copies.

Alternative considered: retain a thin OpenSpec release wrapper. This was
rejected because release eligibility depends on repository workflow state, not
on the presence of planning artifacts.

### Treat the repository workflow as authoritative for releases

The relocated release skill first inspects the target repository's checked-in
workflow and `version.txt`. It derives the next version from that existing
rule, writes the version source before dispatching, and stops if the workflow
is absent or incompatible. It never creates workflow infrastructure or claims
success before confirming the remote tag and release.

Alternative considered: mandate a fixed patch-bump implementation. This was
rejected because compatible repositories may encode their established version
rule differently.

### Describe the OpenSpec flow as guidance, not a gate

The OpenSpec catalog will show these lanes:

```text
Optional: dashboard | explore | grill-me
Plan:     propose <-> update-change
Build:    apply-change
Close:    sync-specs -> archive-change -> commit-inclusive (commit + push)
Release:  ai-skills-release-version, after a remote commit exists
```

`openspec-dashboard` remains usable at any stage. The finalization macro is a
shortcut for the close lane, not an additional stage. The catalog will avoid
suggesting a second push because `openspec-commit-inclusive` already verifies
a normal push.

## Risks / Trade-offs

- [Catalogs become stale as skills change] → Add structural tests that compare
  each category README's linked skill directories with the actual catalog.
- [The application skill grows into a second game creator] → State the
  non-game boundary in its description and route game requests to the existing
  game workflow.
- [A release workflow behaves differently from the template] → Inspect the
  checked-in workflow and stop rather than guessing or retrofitting it.
- [Existing installation behavior regresses] → Preserve category roots and
  names, then run installer and lifecycle tests after documentation changes.

## Migration Plan

1. Add the catalogs and create the new application skill with UI metadata.
2. Move the release skill directory, update its identity and instructions, and
   remove the old OpenSpec path as part of that single move.
3. Update root and OpenSpec documentation, then add/adjust structural tests.
4. Run focused skill validation, lifecycle tests, and OpenSpec validation.

Rollback is a normal Git revert: the change contains only repository skill
files, documentation, and tests; it does not migrate user installations.
