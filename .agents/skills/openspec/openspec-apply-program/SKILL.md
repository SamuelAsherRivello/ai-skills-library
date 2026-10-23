---
name: openspec-apply-program
description: Implement an existing OpenSpec program through its child proposals and integrated acceptance checks. Use when asked to apply a named program, rather than create its plans or apply one change.
---

# OpenSpec apply program

Apply a program by ID or artifact path. Creating, editing or evaluating this skill does not invoke it or authorize implementation.

## Resolve and check readiness

Read the entire program, its proposal registry, decisions and execution policy. Resolve IDs using the project's existing convention, normally openspec/programs/<program-id>/program.md. Ask if selection is ambiguous. Do not invent a native OpenSpec program command.

Read the available global openspec-orchestrate-program and openspec-apply-change skills completely. If either is unavailable, stop and report the missing dependency. Use Apply's root/store discovery and inspect each registered child's real CLI status and planning artifacts.

Distinguish incomplete planning, unresolved decisions, unmet implementation dependencies and editing conflicts. Do not dispatch a child with missing or contradictory artifacts. Explain which children can proceed independently and which are blocked. If the program requires all proposals to be planned before Apply, honor that gate. A scope change requires the user's decision, not a convenient reduction of acceptance criteria.

Every blocking investigation must have its own research proposal with a deliverable and explicit dependent IDs. Use the planning workflows to extract missing ones before dispatch. Apply ready research proposals first, concurrently where independent, while their implementation proposals remain blocked. Research completion unblocks a dependent only after its recorded evidence and decision approvals are satisfied. Do not interpret a global planning gate as permission to guess research results; surface any circular gate to the user.

An explicit operational invocation requests implementation of the selected program within its recorded scope. It authorizes proposal-thread creation, enrollment messages and readable title updates needed for that execution. It does not authorize unrelated messages, paid services, new branches/worktrees, publication or deployment. Automatic skill selection must follow the human's actual implementation request; discovering a program is not authorization.

## Execute through the orchestrator

Use openspec-orchestrate-program as the coordination workflow, keeping the caller as lead. Maintain its durable ledger, dependency scheduling, thread naming, file ownership, restart handling and evidence checks. Do not create a competing scheduler or duplicate workers.

Assign every ready child to an owner using openspec-apply-change. Run independent proposals concurrently within the program limit; serialize shared files, shared test infrastructure and integration gates. Reconcile existing working-tree changes before assigning edits. A worker must continue its task loop until CLI all_done, a genuine blocker or a user interruption.

Do not stop the program after one child's completion or a progress report while other executable work remains. Use supported thread waits to coordinate active workers, then release newly ready dependents. Resume existing assignments after interruption rather than start replacement threads without checking them.

If new planning or substantial revisions become necessary, use the relevant planning skills and respect their approval and planning-only boundaries. When one requires a fresh user request before returning to Apply, record that handoff and ask for it. This skill does not bypass those rules.

## Verify and finish

Require current CLI all_done plus reviewed implementation evidence for every active child. Run the program's integrated acceptance checks against the combined source state. Recheck evidence invalidated by later shared edits. Mark the program applied only when every required outcome and integrated gate passes; preserve blocked and superseded records honestly.

Report completed children, tested source state, remaining limitations and the program location. Stop at verified Apply completion. Syncing specs, archiving, committing, pushing, releasing and deploying remain separate authorized workflows. Do not claim background continuation unless a supported continuation mechanism actually exists.
