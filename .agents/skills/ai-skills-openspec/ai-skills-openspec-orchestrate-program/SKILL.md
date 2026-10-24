---
name: ai-skills-openspec-orchestrate-program
description: Execute a named program of OpenSpec proposals through coordinated concurrent proposal threads and verified Apply completion. Use when asked to orchestrate an existing program by its ID or artifact path.
---

## Workflow presentation

Preserve the leading `* ` orchestration marker and pass coordinator identity
and enrollment context to the active child under the shared title contract.

Use the shared [title contract](../openspec-title-management.md) and
[footer contract](../openspec-footer.md). This state owns `OS-ORP`
and footer phase `Orchestrate program`. Add verified task progress when applicable;
the program coordinator counts proposals instead. Delegate every title read and
write for this chat to `$ai-skills-openspec-title-management`; it preserves a normalized
user subject, restores `OS-ORP`, and refreshes verified progress. Leave child
workflow titles to their owners.
Emit one footer per meaningful checkpoint, never on unchanged polls or
commentary. While a question is unanswered, leave its original question and
footer in place without repeating either on a goal or timer check. Show the
next available skill command in backticks when a phase transition is ready.
Editing or evaluating this skill does not activate these presentation rules.

# OpenSpec orchestrate program

Resolve the input program ID or path using the project's convention, normally openspec/programs/<program-id>/program.md. Ask if ambiguous.

## Load and assess

Read the program, child planning artifacts and current global ai-skills-openspec-apply-change skill. Follow its root/store rules. CLI child task state is authoritative; the program is only a coordination index.

Read repository instructions, current branch and working-tree state, and existing project threads. Establish the permitted source folders, existing owners, shared test server, and user-authorized actions. This skill invocation authorizes creating proposal threads, relevant coordination messages to enrolled threads, and naming those threads. It does not authorize unrelated chat changes, paid usage, publication, branch/worktree creation, or deployments.

## Improve the plan before dispatch

Review the split for independent outcomes, excessive handoffs, shared-file conflicts, and missing prerequisites. Update planning with the available global ai-skills-openspec-update-change skill when needed, reading it before use. For new proposals use ai-skills-openspec-propose. Follow their approval requirements and planning-only boundaries. If a planning workflow requires a new user request before Apply, complete the planning pass, record the pending handoff, and request that transition rather than dispatching implementation in the same turn.

Combine or divide proposals only when the outcome and accepted requirements remain covered. Record old-to-new mappings, rationale, task migration, dependency changes, and evidence in the program. For already-started work, obtain affected owners' state before any reassignment. Stop affected workers before changing their contracts. Never delete existing implementation or mark unfinished tasks complete through migration. Preserve superseded artifacts and record replacement relationships using supported project conventions.

Ask the user about material scope changes, removed acceptance criteria, or decisions outside existing authority. Keep independent work moving when a question blocks only part of the program. After any split or combination, recheck requirement coverage, unresolved decisions, missing dependency references, cycles, and editing conflicts before dispatch.

When research blocks work, read [research dependency rules](references/research-dependencies.md) before planning or dispatch.

## Enroll proposal threads

Keep this thread as the coordinator. Reuse a suitable existing owner thread when appropriate; otherwise create one thread per assignable proposal through supported app tools. Use project discovery for the exact repository. Do not create worktrees or feature branches without explicit authorization.

Use `* OS-ORP:` for this coordinator and the shared leading `* ` for all enrolled
proposal, research and subtask chats under the [title contract](../openspec-title-management.md).
Record coordinator/root thread IDs, exact enrolled IDs, marker ownership and
observed titles in the ledger. New enrolled chats may start with marked temporary
titles. Delegate scoped marker-only updates for enrolled chats, including idle
owners, to `$ai-skills-openspec-title-management`. Child owners exclusively rebuild
their own phase, subject and progress. Do not overwrite or restore those fields.
Pass coordinator identity and membership through assignments and nested proposal
coordinators; nested owners retain one marker. Reconcile on enrollment/resume and
membership changes. Pause/completion retain markers; detachment follows the shared
contract. These rules also apply through ai-skills-openspec-apply-program.

Each assignment must give the program and proposal paths, exact change ID/store, outcome, file and interface ownership, prerequisites, required verification, and allowed external actions. Direct the owner to use ai-skills-openspec-apply-change and continue until its CLI reports all_done or a genuine blocker requires a decision. Tell owners where to record evidence. Reports do not authorize messages back to other chats; the coordinator can poll them.

Announce successful dispatches with the target title and outcome. If thread tools are unavailable, offer sequential execution or a manual dispatch list.

## Schedule and maintain progress

Start ready proposals whose prerequisites and editing constraints permit concurrency, within the program's concurrency limit. Run research and disjoint edits concurrently. Serialize shared files, lockfile changes, fixture changes, test-server lifecycle, integrated gates, commits, and deployment operations. Coordinate existing dirty work; never assume it belongs to an enrolled proposal.


Use thread waits and selective reads to check progress and blockers. Verify original evidence before accepting reports. Do not repeat continuation messages or duplicate slow workers. Update the ledger after meaningful transitions; on resume, reconcile recorded owners with actual thread state before dispatch. On user pause or cancellation, stop assigning work and ask active owners to pause safely, preserving changes.

Continue coordinating while executable work remains. A progress update or completed child is not a reason to stop. At a genuine blocker, request the smallest needed user decision and identify which work is affected. Distinguish blocked children from independent ready children.

If the user asks for scheduled continuation, use the product's supported automation mechanism and verify scheduling succeeds. An active goal or an ordinary response does not provide background execution. Do not promise unattended continuation without a supported mechanism.

## Verify Apply completion

For each proposal, independently read current apply instructions and require all_done. Compare implementation and verification with all specified requirements. Checked boxes or an owner's final answer alone are insufficient. Record tested source snapshots and invalidate stale evidence after relevant integration changes. Resolve regressions through the owning proposal or an approved planning update.

Run the program's integrated acceptance checks after dependent work lands. The program is complete only when all active child proposals have verified Apply completion, all program acceptance criteria pass, and no required decision or dependency remains unresolved. Preserve honest blocked, failed, and superseded states.

Stop at Apply completion. Do not automatically sync specifications, archive, commit, push, release, or deploy. Perform those only under separate explicit authorization and the corresponding workflows. Leave unrelated threads and files untouched.

Finish with completed proposals, evidence, limitations and the program location. Record exact resume actions on a pause.
