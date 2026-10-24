---
name: ai-skills-openspec-macro-finalize-sync-archive-commit-push
description: "Advance one completed OpenSpec change through each safe finalization phase: verify, sync, archive, commit scoped files, then push. Use when finalization should make the greatest safe progress rather than stop early for a later commit or push blocker."
---

## Delegated workflow presentation

Preserve the leading `*` orchestration marker, directly adjacent to the title, and pass coordinator identity
and enrollment context to the active child under the shared title contract.
Use the title manager's no-space write form so repeated Markdown rendering keeps the marker visible.

This is a wrapper/macro, not an independent thread state. Follow the shared
[title contract](../openspec-title-management.md) and
[footer contract](../openspec-footer.md). Delegate title, verified progress and
footer updates to ai-skills-openspec-sync-specs, ai-skills-openspec-archive-change and ai-skills-openspec-commit-inclusive. Read and invoke the owning child workflow
at each applicable phase. Do not prepend a macro prefix, append a second
footer, restore an old title between calls, or repeat a child's question on
an unchanged check. The active child invokes `$ai-skills-openspec-title-management` for
its own current-chat title; preserve that child's checkpoints.
Editing this skill does not execute its children.

# OpenSpec Macro: Finalize, Sync, Archive, Commit, Push



Use only when the user explicitly asks to finish one completed OpenSpec change through sync, archive, Git commit, and a normal push. This macro coordinates the applicable finalization skills in that required order: `ai-skills-openspec-sync-specs`, `ai-skills-openspec-archive-change`, and `ai-skills-openspec-commit-inclusive`, followed by a normal push. It is not a substitute for implementation, review, release, tagging, pull requests, or remote branch integration.

## Branch policy

When the user does not explicitly request a branch, pull request, worktree, or
isolated Git workflow, target the repository's default branch, `main`. Do not
create or switch to a feature branch as part of this macro. If the checkout is
not already on `main`, stop before committing and ask whether to continue on
the current branch or move the work to `main` safely.

The goal is one command after `ai-skills-openspec-apply-change` is done:

```text
verify done -> sync specs -> archive change -> commit scoped files -> push
```

Advance as far as the current state safely permits. A completed earlier phase is
durable progress even when a later phase cannot run. Never roll it back, redo
it merely to make the run look atomic, or report the whole macro as complete
until the remote commit is verified.

## Progressive execution invariant

Treat this as an ordered, resumable sequence, not an atomic transaction:

```text
readiness -> sync -> archive -> commit -> push
```

After a phase succeeds, or inspection proves it was completed by an earlier
run, immediately assess the next phase. Do not stop for a child footer, a
progress report, unrelated dirty files, an upstream change, or another blocker
that applies only to a later phase. A Sync failure blocks Archive; an Archive
failure blocks Commit; a Commit failure blocks Push. A Push failure never
changes the completed Sync, Archive, or local Commit result.

On a retry, preserve and verify prior work: recognize already-synced specs,
an already-archived change, an already-created scoped local commit, and an
already-pushed remote commit. Perform only the first unfinished safe phase.

## Hard Stops

Stop before **Sync** when any of these are true:

- More than one active change plausibly matches and the user did not name one.
- The OpenSpec change artifacts are missing, invalid, or ambiguous.
- Required tasks are unchecked or the proposal's requested behavior is not satisfied by the implementation evidence.
- Verification has not been run, failed, or is too incomplete to support completion.

The following are phase-specific blockers, not preflight stops:

| Condition | Earliest phase it blocks | Required behavior |
| --- | --- | --- |
| Checkout is not on the authorized branch | Commit | Finish Sync and Archive, then stop before staging or committing. |
| Unrelated dirty files cannot be attributed or safely separated | Commit | Finish Sync and Archive. Attempt a file-level scope table; stop only if no safe scoped commit can be selected. |
| No upstream or remote branch is unavailable | Push | Finish a safe local scoped commit, then report the exact push setup needed. |
| Upstream advanced or diverged | Push | Finish a safe local scoped commit. Do not merge, rebase, reset, or force-push; report local and remote SHAs. |

When any phase stops, report completed phases, the phase that stopped, and the
smallest safe next decision. Do not auto-create missing workflow, release,
branch-integration, or project infrastructure.

## Human-required verification

If readiness depends on a human playtest or manual browser verification, use
the project's `ai-skills-create-playtest` skill before stopping. Verify or
restart the project-owned server through that skill, provide its verified URL,
and give exact executable steps and pass/fail criteria. Do not ask the human to
playtest through an ad hoc checklist, and do not claim the human-observed
result passed. Resume this macro only after the human reports the result or the
required browser evidence is otherwise available.

## Preflight

1. Resolve exactly one OpenSpec change from the user's request or current conversation.
   - If the user names a change, use that change.
   - If no change is named, use the last change explicitly mentioned in the current chat.
   - If no single change is clear, list active changes and ask the user to choose.

2. Confirm the repository root, OpenSpec root, current branch, upstream branch, remote URL, dirty files, and current `HEAD`.

3. Fetch the current upstream branch when one exists and record its SHA. This
   is evidence for the later Push gate, not a reason to stop Sync or Archive.
   Do not reset, restore, rebase, force-push, or attempt an automatic
   merge/API merge in this workflow.

4. Inspect OpenSpec state using the installed CLI and repository conventions:
   - `openspec list --json`
   - `openspec status --change "<name>" --json`, when supported
   - `openspec show "<name>"`, when needed
   - project `.openspec/` or `openspec/` files directly, when CLI output is insufficient

   Use JSON fields such as artifact paths when available, but do not assume specific field names across OpenSpec versions. If a field such as `artifactPaths.specs.existingOutputPaths` is absent, inspect the change directory and schema/config instead of inventing paths.

   Also run `openspec instructions apply --change "<name>" --json`. Read every
   returned `contextFiles` path and use its aggregated `taskTrackingConfigured`,
   `tasks`, and `progress` fields as the task-tracking evidence. Treat an
   `all_done` state as a status result, not proof that the proposal behavior was
   implemented. If tracking files are unavailable or the reported task evidence
   is incomplete, stop rather than treating an empty list as completion.

5. Read the proposal, design if present, task list, delta specs, and relevant implementation diff. Build a completion candidate:
   - change id/name
   - proposal behavior to satisfy
   - tasks and whether each is checked off
   - delta specs to sync
   - implementation/test/doc files expected in the commit
   - verification evidence found
   - target branch and upstream branch

6. Stop only if the completion candidate itself is ambiguous or incomplete.
   Record unrelated dirty files separately from the change's candidate file
   list; they are assessed at Commit, after safe planning finalization has run.

## Readiness Verification

Before syncing or archiving:

1. Confirm every required task is checked off using the apply instruction's returned task source paths and lines, not an assumed `tasks.md` location. If task tracking is configured but any tracking file is unavailable or progress is incomplete, stop and list the affected tasks. Do not silently mark tasks complete unless the user explicitly requested that and the staged scope is otherwise clear.
2. Compare the proposal's requested behavior and impact against the scoped implementation diff and verification evidence.
3. Run or confirm the repository's relevant validation commands. Prefer commands already documented by the project, OpenSpec change, or package scripts. If validation is impractical, report the limitation and stop unless the user explicitly asked to proceed without that validation.
4. Run strict OpenSpec validation for the active change using the repository-supported command. If the CLI syntax differs, inspect help and use the supported equivalent.

## Sync Specs

1. Read `artifactPaths.specs.existingOutputPaths`. If it is empty or the spec artifact is intentionally skipped, record "No delta specs" as a successful no-op. If selected deltas already match their main specs, record "Already synced" as a successful no-op. Otherwise sync every selected delta spec into its owning main spec before archive.
2. Read both the delta spec and target main spec before editing.
3. Preserve main-spec content unrelated to the delta.
4. Keep added, modified, and removed requirements coherent with the accepted change.
5. Validate the synced specs using the repository-supported OpenSpec command, such as `openspec validate --specs` or the current equivalent.
6. Re-read the synced main specs and selected deltas to confirm they match the intended change.

If Sync succeeds or is a verified no-op, immediately continue to Archive. If
it cannot establish a valid sync state, stop before Archive and preserve the
unarchived change for the next run.

## Archive

Archive only after:

- implementation readiness is confirmed,
- sync verification passes,
- and strict validation for the active change passes.

Archive through the repository's OpenSpec workflow or CLI. Do not manually move files unless the project's workflow requires it and the file operations are clearly scoped.

If the resolved archive already contains this change and its required
validation passes, record "Already archived" and continue. If Archive cannot
complete, stop before Commit; do not stage implementation files around an
active change merely to bypass the archive gate.

## Stage, Commit, Push

1. Inspect `git status` after Archive. Unrelated dirty files are expected input
   here, not a reason to undo or withhold Sync/Archive progress.
2. Stage only:
   - implementation files attributable to the completed proposal,
   - tests/docs/assets attributable to the completed proposal,
   - synced main specs,
   - archived OpenSpec change files.
3. Build a file-level attribution table. Do not stage unrelated dirty files.
   A large unrelated set is reportable but is not itself a blocker. If a
   related file contains inseparable unrelated changes, or the candidate names
   cannot be safely attributed, stop **at Commit** with Sync and Archive
   recorded as complete.
4. Review the staged diff before committing. Use `git diff --cached --name-status`, `git diff --cached --check`, and a focused cached diff review.
5. If the checkout is on the authorized branch, make the safe scoped local
   commit with the repository-approved identity when one is defined. Invoke
   `ai-skills-openspec-commit-inclusive` as the Commit phase owner with explicit macro
   context. In that context, do not let an upstream change or missing upstream
   suppress this local commit; those are Push gates in this macro. If the
   branch is unauthorized, stop here before staging or committing.
6. Fetch the upstream branch again immediately before pushing. If it advanced,
   diverged, or is missing, stop **after** reporting the local commit SHA and
   remote state.
7. Push with an ordinary non-force push only when the upstream is unchanged and
   fast-forward-safe.
8. Fetch once more and verify that `origin/<branch>` resolves to the pushed commit or a descendant containing it.

## Final Audit

Finish with a concise phase audit:

- OpenSpec change name and each phase's state: completed, verified no-op,
  blocked, or not reached.
- Synced specs and archive path when completed.
- Scoped local commit SHA when completed, even if Push is blocked.
- Pushed branch and verified remote SHA only when Push succeeds.
- Validation commands run, results, and the first blocking condition.

If any step stopped, do not present the workflow as complete. Preserve the
completed prefix and list the smallest safe next step.

## Boundaries

- The user must explicitly authorize this macro because it commits and pushes.
- Do not create a release, tag, pull request, release workflow, or branch-integration branch unless separately requested.
- Do not use provider merge APIs in this workflow.
- Preserve the normal OpenSpec sync-before-archive ordering.
- Do not treat the macro as atomic or make an earlier safe phase wait for a
  later Commit or Push condition.
- Never use destructive Git operations, force pushes, rebases, resets, restores, or broad cleanups.
- Never sweep unrelated dirty files into the commit.
- Never claim that a rejected push succeeded.
- A pre-existing unrelated test failure must be reported and kept outside the commit; do not conceal it or rewrite its test.
