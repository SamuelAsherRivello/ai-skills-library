---
name: ai-skills-openspec-create-program
description: Turn a multi-part initiative into a durable program artifact and multiple coordinated OpenSpec proposals. Use when asked to plan a program of related changes, dependencies, and parallel workstreams.
---

## Delegated workflow presentation

Preserve the leading `* ` orchestration marker and pass coordinator identity
and enrollment context to the active child under the shared title contract.
Use the title manager's escaped write form so Markdown rendering keeps the marker visible.

This is a wrapper/macro, not an independent thread state. Follow the shared
[title contract](../openspec-title-management.md) and
[footer contract](../openspec-footer.md). Delegate title, verified progress and
footer updates to ai-skills-openspec-propose. Read and invoke the owning child workflow
at each applicable phase. Do not prepend a macro prefix, append a second
footer, restore an old title between calls, or repeat a child's question on
an unchanged check. The active child invokes `$ai-skills-openspec-title-management` for
its own current-chat title; preserve that child's checkpoints.
Editing this skill does not execute its children.

# OpenSpec create program

Create a program and its child proposals. This plans work only. It does not start implementation, create threads, or authorize publication.

## Establish scope

Read the user's requirements and applicable project instructions. Read the available global ai-skills-openspec-propose skill completely before creating changes. Use its project-root and store discovery rules. Preserve the selected store on subsequent OpenSpec commands. Do not initialize OpenSpec or invent CLI support for programs.

Inspect existing changes before creating new ones. Reuse related approved work rather than duplicate it. Treat a program as a maintained workflow convention, not a native OpenSpec schema object.

Front-load blocking questions before generating affected proposals. Follow the underlying proposal workflow's interview format and question budget. Separate confirmed decisions from research tasks and unresolved choices. Research proposals may produce evidence and recommendations without authorizing the implementation they investigate. Independent proposals may proceed when a question blocks only part of the program.

## Decompose the work

Choose proposal boundaries by independently verifiable outcomes and ownership, not an arbitrary thread count. Identify hard prerequisites, research decisions, shared interfaces, overlapping files, integration gates, and operations that must run serially. Keep a single owner for each shared editing scope. A logical dependency and an editing conflict are different constraints; record both.

Extract every blocking research question into a dedicated research proposal before its dependent implementation. Reuse a suitable existing research proposal; combine questions only when they share an investigation and deliverable. Record the question, owner, evidence deliverable, completion criteria, decision approver, dependent proposal IDs and exact unblock conditions. Pure research may skip runtime specs only through the selected schema's supported mechanism.

Front-load all ready research dependencies, concurrently where independent. Do not bury research inside implementation tasks or require research-dependent implementation plans to be complete before research can start. Mark those plans provisional and blocked. Research findings and any required user approval must precede implementation readiness; an inconclusive result is not an automatic unblock.

Explain the proposed split and any material tradeoffs. Preserve the user's requested scope. Do not silently omit requirements or expand deployment, billing, repository, or messaging authority.

## Write the program

Use the project's existing program convention if present. Otherwise use a human-authored program.md outside CLI change directories, normally openspec/programs/<program-id>/program.md under the confirmed planning root. Check root permissions and repository rules before writing. Use a lowercase hyphenated program ID.

Include these sections:

- Identity: program ID, readable title, version, planning root/store, source repositories, objective, scope exclusions, and completion criteria.
- Decisions: confirmed choices, open questions, decision owner, and which proposals each question blocks.
- Proposal registry: exact change ID, readable title, artifact link, intended outcome, state, hard prerequisites, editing conflicts, owned files/interfaces, verification, and acceptance owner.
- Execution policy: concurrency limit, shared-checkout restrictions, integration owner, and separately authorized external operations. Record actual user authorization, not assumed permission.
- Dependency plan: execution waves or a dependency tree with no cycles or missing references.
- Coordination ledger: thread reference and exact last-applied title, owner, next action, blocker, evidence tied to a source snapshot, and timestamps when useful. Leave unassigned values explicit.
- Revisions: reasons for splits, combinations, supersession, and scope decisions. Preserve traceability from every original requirement to an active proposal.

The program tracks coordination. Child task artifacts remain authoritative for implementation progress. Do not duplicate all child checkboxes into the program. Give each confirmed requirement a stable ID and map it to child acceptance criteria, so later splits cannot lose requirements. Use explicit planning, ready, running, blocked, applied, and superseded states; archive state remains separate.

## Create and verify proposals

Use ai-skills-openspec-propose for each selected change, reading and following its current instructions and CLI artifact rules. Produce the complete schema-required artifacts, not just names or brief outlines. Record exact IDs and links in the program. Existing proposals retain their identity unless a justified revision requires a split or combination.

Validate each child through supported OpenSpec commands. Check dependency references, ownership conflicts, requirement coverage, and completion criteria. A child is ready only when its required artifacts and blocking decisions are resolved. Report incomplete or blocked planning honestly.

Finish with the program location, proposal inventory, execution order, and questions still needing the user. Offer ai-skills-openspec-orchestrate-program with the program ID or path as the next step. Do not launch it implicitly.
