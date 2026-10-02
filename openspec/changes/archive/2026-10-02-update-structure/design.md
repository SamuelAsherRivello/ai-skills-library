# Design

## Context

See `proposal.md` for the motivation and `specs/` for user-visible requirements. The current library stores skills as immediate children of `.agents/skills`; its copy helpers and documentation assume this flat layout. The OpenSpec updater currently replaces upstream skills and records release metadata globally. The Blender repository is a separate checkout with canonical skills under `skills/` and package-specific install guides and scripts.

## Goals / Non-Goals

**Goals:**

- Give skills a stable category path while retaining the existing per-skill directory format and root discovery metadata.
- Use the `skills` CLI as a shared selection-and-install entry point for Codex and Claude Code.
- Make OpenSpec refresh a repeatable three-way merge against each skill's recorded upstream baseline.

**Non-Goals:**

- Combine repository histories or make either repository depend on the other.
- Replace Blender-specific packaging, prerequisites, or PowerShell installers.
- Add native Claude marketplace packaging, automatic release/versioning, or a required setup wizard.

## Decisions

### Categorize the library under `.agents/skills/<category>/<skill>/`

Use exactly four category directories: `ai-skills-create`, `ai-skills-library`, `openspec`, and `docker-sandbox`. Keep `.agents/skills/.openspec-target` at the skills root. Move complete skill directories, including supporting files, without changing skill identifiers. Update helpers to enumerate valid skills at the category/skill depth instead of assuming immediate children. Keep skill-specific paths in docs and scripts aligned with the new locations.

For push operations, map known skill families to their category. If a valid global skill has no known mapping, ask the user to choose a category before any copy is made; for `all`, resolve every unmapped skill during preflight and make no copies until all destinations are clear. This preserves the existing all-or-nothing preflight behavior.

Alternative considered: infer category solely from naming conventions. That is ambiguous for future or personal skills, so use known mappings plus an explicit choice for unknown names.

### Install from each repo with the same `skills` CLI pattern

Document `npx skills@latest add SamuelAsherRivello/ai-skills-library --copy` for the library and the corresponding `SamuelAsherRivello/ai-skills-blender` command in Blender. Explain the interactive skill and agent selection, recommend project-local installation, show the global option, and document `npx skills update` with the appropriate scope. Keep copy installation as the default so installed files are ordinary editable files.

Use the same heading order and concise section format in both root READMEs. Update Blender's getting-started guide so its primary quick-install path agrees, while retaining its existing client guides and PowerShell installers as advanced/package-specific options. Repositories remain independently versioned and maintained.

Alternative considered: centralize the install flow in one repository and link from the other. That would create a cross-repository dependency and make one repo's entry point feel secondary; duplicate the short, matching instructions instead.

### Track OpenSpec baselines per skill and merge with Git

Record an upstream base revision for each upstream-owned OpenSpec skill. For a refresh, retrieve that skill's old baseline, the current local file, and the corresponding file from the new upstream revision, then use Git's three-way merge machinery. On a clean merge, write the merged file and advance only that skill's baseline. On a conflict, retain the current file and its baseline, report the skill and conflict, and continue processing other skills. A later run can retry that skill against the still-recorded base after a maintainer resolves or adjusts the local edits.

Migrate existing global release/revision metadata into per-skill baselines while retaining enough release information to identify the upstream snapshot. Limit discovery and writes to existing upstream-owned skills under `.agents/skills/openspec/`; do not add newly introduced upstream skills automatically or alter custom skills and other categories.

Alternative considered: replace skills wholesale or fail the entire release on one conflict. Replacement loses local adaptations; whole-release failure withholds unrelated clean updates. Per-skill merges preserve custom work and let independent updates proceed.

### Verify external CLI behavior during implementation

Before documenting the flow as supported, check that the current `skills` CLI discovers skills in the nested category layout and offers selection for both Codex and Claude Code. Validate project-local and global install/update commands on fresh fixtures, using `--copy`. If the CLI does not discover the nested layout, adjust the category layout or supported CLI invocation before completing implementation; do not claim unsupported behavior in docs.

## Risks / Trade-offs

- [The installer may change discovery or option behavior] → Verify current CLI behavior during implementation and keep examples aligned with its help output.
- [A three-way merge can produce markers or nuanced conflicts] → Use Git merge results per skill, preserve conflicted active content and baseline, and include conflict detail in the workflow summary.
- [Users may have existing flat-layout copies or custom paths] → Move tracked skill directories as complete units and audit repository references; document the resulting canonical paths.
- [The Blender checkout may not be present during library implementation] → Clone or otherwise obtain its separate repository for the scoped README edits, review its working tree first, and do not alter its source/history beyond the agreed installation guidance.

## Migration Plan

1. Move library skill directories to the four categories and update all repository path consumers.
2. Migrate OpenSpec provenance to per-skill baselines and implement/test independent three-way refresh behavior.
3. Update the library README and the separate Blender README/getting-started guide with matching install instructions; retain Blender's advanced paths.
4. Validate category discovery/copy behavior, OpenSpec merge cases, and documented CLI flows for Codex and Claude Code.

Rollback by reverting the categorized moves and corresponding path updates together; retain a copy of the prior OpenSpec provenance format in version control so the updater and metadata migration can be reverted as one change.
