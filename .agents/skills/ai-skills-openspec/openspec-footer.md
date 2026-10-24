# OpenSpec footer contract

The active workflow owns one concise footer at a meaningful user-facing
checkpoint. It is not a heartbeat, a reason to stop work, or a repeated
reminder. Read this together with [title ownership](openspec-title-management.md).

## Emit once, then stay quiet

Emit a footer after the initial substantive phase handoff, a newly asked
question requiring an answer, a genuine new blocker, verified completion, or
a material progress/phase/next-action change worth reporting. Place it last
in that checkpoint response, never on each tool result or commentary update.

Track the last emitted checkpoint using existing conversation or workflow
state: phase, target, verified counts, result/blocker, pending question ID and
next action. A new interview question is a new checkpoint even if counts are
unchanged. A timer, goal check, reconnect or unchanged CLI poll is not.

While awaiting a human answer, preserve the original question and footer as
the visible stopping point. Do not repeat either, increment the question,
re-ask, assume an answer or dispatch dependent work on an automated check.
Independent authorized work may continue silently. Resume the question only
after the human replies or explicitly requests a recap. If prior state cannot
be recovered, do not manufacture a fresh question or footer.

An explicit human status/recap request may receive one concise current
checkpoint. This is different from an unsolicited polling repetition.
Never claim that old messages can be edited or replaced without tool support.

## One format

Use exactly four bullets after the shared heading:

```markdown
**OpenSpec Flow**

- Status: <active phase>
- Tasks: <completed> of <total>, or N/A
- Coordination: <role>
- Next: <one actionable instruction>
```

For a program coordinator, replace Tasks with `Proposals: N of M`; use
`Proposals: N/A` if unverified. Do not sum child task totals into proposals.
For other states, use actual CLI counts or verified archived counts. Use N/A
when tracking is not applicable or unavailable; do not invent zero or turn
an interview budget into tasks. Preserve unfinished counts in blocked states.

Allowed phase labels match the owning workflow:
`Dashboard`, `Initialize`, `Audit`, `Explore`, `Grill`, `Propose`, `Update`, `Apply`, `Sync`,
`Archived`, `Commit`, `Orchestrate proposal`, `Orchestrate program`.
Status names the current phase, not the recommended next one. Explain
completion, failure or a blocker briefly in the response, not by relabeling
the active phase as another phase.

Roles are `Standalone`, `Orchestrator` or `Managed by orchestration`.
Use Orchestrator for a coordinating owner and Managed by orchestration for
an enrolled child. Never infer enrollment from a title alone, including the
leading `*` orchestration marker. Resolve the exact coordinator from the ledger;
the marker survives phase handoffs and is shared across orchestration groups.

## Next action

Use the actual available custom skill invocation in backticks, with the
resolved change/program argument where known. Prefer one command, not a menu.
A suggestion never invokes it or grants authority.

| Checkpoint | Typical next action |
| --- | --- |
| Dashboard inspection complete | Inspect the selected change, or `$ai-skills-openspec-explore <topic>` when discovery is requested |
| Initialization complete | Resume the explicitly requested custom OpenSpec workflow |
| Audit complete | Use the smallest applicable custom workflow named by the audit finding |
| Explore settled | `$ai-skills-openspec-propose <change>` |
| Grill waiting | Reply to Question N |
| Grill complete | Resume the actual planning phase; propose only if no change exists |
| Proposal ready | `$ai-skills-openspec-apply-change <change>` |
| Updated plan ready | `$ai-skills-openspec-apply-change <change>` |
| Apply verified complete | `$ai-skills-openspec-sync-specs <change>` when delta specs need syncing; otherwise `$ai-skills-openspec-archive-change <change>` |
| Sync verified complete | `$ai-skills-openspec-archive-change <change>` after implementation is complete |
| Archive complete | `$ai-skills-openspec-commit-inclusive <change>` if a commit is wanted |
| Commit/push verified complete | Done, or a separately requested and available release/deploy workflow |
| Program plan ready | `$ai-skills-openspec-orchestrate-program <program-id>` |
| Program Apply complete | Report integrated acceptance; suggest finalizing a specific eligible child only when appropriate |
| Blocked or awaiting approval | Name the smallest answer, access or approval needed |

These are conditional recommendations, not automatic phase transitions.
Do not suggest an unavailable skill, an invented slash command, archive before
required verification, or release/deploy without its distinct authorization.
Never recommend calling a macro merely to change the footer or title.

When ready Apply work remains, continue immediately. If progress is worth
reporting, use brief commentary without a footer; do not hand work back to the
user or end a turn at a milestone. `Next: Continue` never means the user must
reinvoke Apply.

## Macros

Only the invoked state owner emits checkpoints. Wrappers and macros do not
append a second footer, restore an earlier footer, or render one after every
child call. Preserve the last meaningful child's checkpoint. A material
post-child operation may be included in that owner's final report without
falsely repeating or re-running the child's work.

## Examples

A newly asked interview question ends once with:

```markdown
**OpenSpec Flow**

- Status: Grill
- Tasks: N/A
- Coordination: Standalone
- Next: Reply to Question 4
```

An unchanged scheduled check emits nothing.

A finished exploration ends with:

```markdown
**OpenSpec Flow**

- Status: Explore
- Tasks: N/A
- Coordination: Standalone
- Next: `$ai-skills-openspec-propose add-auth`
```
