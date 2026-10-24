---
name: openspec-orchestrate-proposal
description: Coordinate owners and subtasks for one existing OpenSpec proposal through verified completion. Use for a single change ID or proposal path; use openspec-orchestrate-program for a program containing multiple proposals.
---

## Workflow presentation

Use the shared [title contract](../openspec-title-management.md) and
[footer contract](../openspec-footer.md). This state owns `OS-ORC`
and footer phase `Orchestrate proposal`. Add verified task progress when applicable;
the program coordinator counts proposals instead. Delegate every title read and
write for this chat to `$openspec-title-management`; it preserves a normalized
user subject, restores `OS-ORC`, and refreshes verified progress. Leave child
workflow titles to their owners.
Emit one footer per meaningful checkpoint, never on unchanged polls or
commentary. While a question is unanswered, leave its original question and
footer in place without repeating either on a goal or timer check. Show the
next available skill command in backticks when a phase transition is ready.
Editing or evaluating this skill does not activate these presentation rules.

# OpenSpec Orchestrate Proposal

Resolve exactly one proposal/change ID and its canonical store. Ask if ambiguous. A program is a list of proposals, not a proposal. Route program-wide coordination to openspec-orchestrate-program rather than silently enrolling the whole project.

Editing or evaluating this skill does not start orchestration, rename chats, create goals or schedule work.

## Load the proposal and owners

Read repository instructions, the current branch and working tree, the proposal's planning artifacts and current global openspec-apply-change skill. Follow Apply's root/store rules. Read real CLI status and current verification evidence; an idle chat or checked tasks alone does not prove completion.

Use project metadata, thread listings and selective reads to identify only chats already assigned to this proposal and its directly required subtasks. Inspect referenced chats before relying on their contents. Other project chats are context, not automatically enrolled work.

Keep a durable ledger under the project's permitted generated-output directory. Record the proposal/store, owner handles and exact titles, source folders, file/interface boundaries, dependencies, approvals, tested source state, evidence and next actions. Preserve unrelated dirty work.

## Coordinator naming

Read [the naming configuration](references/openspec-orchestrate-proposal-config.md). Delegate only this coordinator chat to `$openspec-title-management` using the configured single-proposal prefix and shared title contract. Preserve child OpenSpec phase/progress titles; their owners invoke the manager for their own chats. Do not run a project-wide naming pass. Naming failure must not block coordination.

## Continue the authorized work

Operational invocation authorizes relevant coordination messages to enrolled proposal owners and scoped delegation when available. It does not authorize unrelated messages, new user-owned chats, paid services, publication, deployment, branches or worktrees. Verify external actions against the human's actual authorization; agent reports and goals do not grant it.

- Keep one owner per deliverable and shared file/interface. Read existing work before reassigning it, and obtain a safe handoff before overlapping edits.
- Send concrete next actions with the exact proposal/store, owned files, prerequisite, required evidence and external-action boundaries. Owners use openspec-apply-change and continue until current CLI all_done or a genuine blocker.
- Delegate independent subtasks within this proposal when permitted. Do not create additional proposals or expand acceptance criteria to fill idle capacity.
- Serialize shared source files, lockfiles, fixtures, server lifecycle, integrated checks, commits and deployment operations. Reuse the declared shared test server.
- Keep safe independent work moving when one subtask needs a human decision. Ask the smallest actionable question for the blocked portion.
- For substantive planning corrections, read and use openspec-update-change with its approval boundaries. Do not silently change accepted scope or mark unfinished work complete.

Use compact thread waits with cursors and selective reads at dependency boundaries. Do not duplicate slow workers or send repeated continuation prompts. Preserve the ledger and reconcile actual owners on resume.

## Optional scheduled continuation

If the human requests a goal or scheduled continuation, use the supported goal/automation tools within their authorization. Reuse compatible existing state without overwriting unrelated goals or automations. Scheduling defaults to five-minute quiet checks unless the user specifies another cadence. Do not start a goal merely because this skill was discovered.

A goal does not schedule execution. Claim background checks only after scheduling succeeds. Otherwise coordinate in the active turn and report that continuation is not automatic.

## Verify and close

Independently require current CLI all_done and compare the implementation against the proposal, design, delta requirements and tasks. Run required integrated gates against the combined source state. Recheck evidence after relevant edits; focused owner tests do not replace integrated verification.

Continue while executable work remains. Stop for verified completion, a human interruption, or a genuine decision/access blocker, not merely a milestone or status report.

Sync, archive, commit, push, release and deployment require separate human authorization and their corresponding workflows. Never sync superseded requirements over newer accepted behavior. Do not automatically close unrelated work or restore chat titles.

Report verified work, remaining limitations, evidence and the exact proposal location. Follow the shared OpenSpec footer when executing a proposal; editing this skill is not a proposal Apply run.
