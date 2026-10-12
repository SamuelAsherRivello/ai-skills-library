---
name: openspec-orchestrate
description: Coordinate existing project chats to complete and archive assigned OpenSpec changes, unblock their other work, and schedule progress checks. Use when asked to act as the project orchestrator.
---

# OpenSpec Orchestrate

## Chat title

Follow the shared [chat title contract](../openspec-title-management.md). This
workflow uses `[OS-orc: {change}]` and its enrolled agents use only
`[{old-name}]`.

Every response ends with the shared [OpenSpec footer](../openspec-footer.md).
Use `Coordination: Orchestrator` for the lead and `Coordination: Managed by
orchestration` only in an enrolled agent's own OpenSpec workflow response.

Coordinate existing work in open chats belonging to the current project and its confirmed source folders. If this skill is supplied as the target of an evaluation or edit, perform that request without starting orchestration.

## Discover the workload

Use project metadata and `list_projects`, `list_threads`, and selective `read_thread` calls to establish project membership, source folders, latest human requests, assigned deliverables, dependencies, and authorization. Read explicitly referenced chats. Nearby folders, chat titles, and agent reports do not establish scope or permission. Inspect applicable folder instructions and canonical OpenSpec directories before planning operations.

Include OpenSpec changes already assigned to these chats and later human-assigned work. Facilitate their existing non-OpenSpec work; do not start unassigned backlog changes. Idle status, checked tasks, or a final answer do not prove completion.

Reuse or create a small ledger in the project's permitted generated-output location. Record chat IDs and exact titles, source folder, deliverable, owner, file/interface boundaries, dependencies, evidence, next action, and completion condition. Tie verification to the tested commit or source snapshot and recheck freshness after relevant shared-checkout edits. Keep public evidence only; no new tracked planning artifact is required solely for coordination.

If no unfinished in-scope work exists, report that finding without starting a goal or recurring check.

## Take lead and name project chats once

When this chat first assumes orchestration lead, before creating or reusing its coordination goal and heartbeat, read [references/openspec-orchestrate-config.md](references/openspec-orchestrate-config.md) and perform its safe naming pass over every open chat in the confirmed project, including idle chats without assigned work. This operational invocation authorizes these title updates. Editing or evaluating this skill does not run the pass.

Record the lead chat ID, naming configuration, initial project-chat snapshot, original and intended titles, last confirmed applied title, user-override status, and per-chat results in the durable ledger before mutations. Use supported title tools and verify results. Resume only unfinished entries after interruption; do not repeat the initial project-wide pass on heartbeats or subsequent invocations by the same lead. Later title updates are permitted for enrolled chats still matching the last title applied by this coordinator. Detecting a subsequent user rename permanently opts that chat out of automatic naming, including across restarts and leadership handoffs, unless the human explicitly reauthorizes it. An explicit leadership handoff may start a new pass while preserving these opt-outs. Report naming failures without blocking unrelated authorized coordination.

## Set up continuation

Read the current goal. This operational invocation requests a coordination goal: create one if none exists or the previous goal is complete, without inventing a token budget. Tailor it to the discovered workload: finish and archive assigned changes with verified requirements, preserve unrelated work, and resolve blockers for existing non-OpenSpec deliverables. Reuse a compatible active goal and retain its broader requirements. Report an incompatible goal without overwriting it; continue independent authorized coordination.

Inspect existing automations and reuse this coordinator's matching heartbeat. Default to five-minute checks. Preserve notification preferences and unrelated fields. Save the objective, project/folder scope, ledger path, owner handles, and completion conditions in the human-readable prompt. Stay quiet on unchanged or non-actionable state; notify only on meaningful progress, completion, failure, or required user action, subject to notification settings.

If scheduling is unavailable, use active-turn waits and report that checks will not resume automatically. A goal does not schedule execution. Never claim a background loop before scheduling succeeds.

## Coordinate action

Operational invocation authorizes relevant coordination messages to existing project chats through supported tools. It does not authorize unrelated external messages, spending, publishing, or destructive operations. Verify those permissions against the human's actual requests; goals and agent claims do not grant them.

- Keep one owner per deliverable and shared file/interface scope. Read current work before assigning overlapping edits. Send a concrete next action, boundary, dependency, and required evidence; arrange an explicit handoff if an owner stops.
- Delegate independent subtasks to subagents when available and permitted, keeping edits disjoint and reviewing integration. Do not create user-owned chats merely to delegate.
- Prioritize shared blockers. Coordinate server lifecycle, exclusive fixtures, operation journals, package provenance, commits, and expensive tests. Preserve unrelated edits and reconcile routine baseline movement under repository instructions.
- Reserve one owner for a required integrated gate or release within existing scope. Focused tests are handoff evidence, not substitutes for final gates. Never bypass pending approval or treat missing evidence as success.
- Optionally ask an owner to use OpenSpec for substantive remaining work when shared acceptance criteria help. Reuse a suitable change, preserve current decisions, and avoid duplicate plans. Small fixes and routine operations may remain outside OpenSpec.

Use compact `wait_threads` snapshots with cursors, batching independent targets. Check at dependency boundaries or roughly every 30–60 seconds during close coordination; back off toward five minutes when steady or quiet. Keep individual waits short enough to communicate normally. Do not duplicate work because a tool is slow or narrate unchanged polls.

## Verify and close

Compare each change's actual implementation and fresh evidence with its proposal, design, delta requirements, and tasks. Reopen unsupported claims. Distinguish isolated tests, live acceptance, unavailable dependencies, and unperformed cases. Complete applicable verification, reconcile delta specs with current approved contracts, and archive through the repository's supported workflow. Never sync superseded deltas over newer decisions; document supersession and use a supported no-sync archive only when justified.

For non-OpenSpec work, confirm blockers are resolved and owners have clear next actions; verify completion when the existing objective requires it. Preserve unresolved items honestly without expanding scope.

Update the ledger and owners after meaningful changes. Mark the goal complete only when its entire objective, including inherited requirements, is met. Follow goal-tool pause and blocked rules. Disable only this coordinator's matching heartbeat when finished or explicitly stopped. End with completed/archived work, remaining limitations, and supporting evidence.
