---
name: ai-skills-openspec-audit
description: Read-only audit of OpenSpec setup, change artifacts, and workflow readiness. Use to diagnose state or select the next OpenSpec workflow; never use it to make changes.
allowed-tools: Bash(openspec:*) Bash(git:*)
---

## Workflow presentation

Preserve the leading `* ` orchestration marker and pass coordinator identity
and enrollment context to the active child under the shared title contract.

Use the shared [title contract](../openspec-title-management.md) and
[footer contract](../openspec-footer.md). This state owns `OS-AUD` and footer
phase `Audit`. Show verified task progress only for a selected change. Delegate
every title read and write for this chat to `$ai-skills-openspec-title-management`; it
preserves a normalized user subject, restores `OS-AUD`, and refreshes verified
progress. Emit a footer only for a
material result, blocker, or requested recap. Editing or evaluating this skill
does not activate these presentation rules.

# OpenSpec Audit

Diagnose the current project's OpenSpec state without changing it. This is a
read-only workflow: do not initialize a root, create or edit artifacts, copy or
migrate skills, archive, sync specs, commit, push, or repair anything. Report
facts and the smallest applicable next workflow; only that later workflow may
perform a change after its own authorization rules are satisfied.

## Scope

Accept an optional change name or program ID. If none is supplied, audit the
project and list active changes. Audit a single active change automatically only
when there is exactly one. If several active changes exist, summarize their
identifiers and ask which one to inspect rather than guessing.

Run `openspec context --json` first. Treat its resolved `root.path` and any
selected `--store <id>` as authoritative. A declared-store error is a blocking
finding, not an uninitialized project. When no root exists, inspect only setup
readiness; do not run commands that could create a root.

## Audit checks

Use the CLI's read-only JSON commands where available:

1. Inspect the root and active/archive inventory with `openspec list --json`.
   For the selected change, inspect `openspec status --change "<change>"
   --json`, its required artifacts, and current task counts. Read relevant
   artifacts only when they exist.
2. Validate a selected active change with `openspec validate --change
   "<change>"`. Report validation output as evidence; do not attempt a fix.
   For archived work, inspect retained evidence instead of treating it as an
   active change.
3. Inspect custom-suite setup without modifying it. Report missing, partial,
   duplicate, linked, or legacy copies in the canonical global
   `.agents/skills`, legacy `.codex/skills`, and project-local skill roots.
   Do not conceal a legacy conflict merely because the canonical suite works.
   When setup must be diagnosed more deeply, run the `$ai-skills-openspec-init` bootstrap
   preflight without `-Initialize`; never run its mutating form from this skill.
4. Inspect Git readiness with read-only commands such as `git status --short`,
   `git branch --show-current`, and upstream information. Separate files
   attributable to the selected change from unrelated dirty work when the
   evidence permits; otherwise say the scope cannot be determined. Git findings
   are readiness information only.

Run only checks that apply to the discovered state. A missing CLI, malformed
JSON, inaccessible path, or unsupported command is a finding with its exact
limitation, not a reason to substitute a write-capable command or infer health.

## Report

Give a compact evidence table with `Area`, `Status`, `Evidence`, and `Next`.
Use `Healthy`, `Warning`, or `Blocking`; distinguish observed facts from an
inference. Recommend exactly the smallest available custom workflow, for
example `$ai-skills-openspec-init`, `$ai-skills-openspec-propose <change>`,
`$ai-skills-openspec-update-change <change>`, `$ai-skills-openspec-apply-change <change>`,
`$ai-skills-openspec-sync-specs <change>`, or `$ai-skills-openspec-archive-change <change>`.
Recommend `$ai-skills-openspec-commit-inclusive <change>` only after archive evidence;
never recommend a macro merely to alter presentation.

If the audit is entirely healthy, say what is ready and still end without
performing the next action. If it is blocked, name the minimum missing access,
choice, or repair workflow. Do not turn an audit into permission to correct its
findings.
