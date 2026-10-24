---
name: ai-skills-openspec-apply-change-with-playwright
description: Implement an OpenSpec change and validate the resulting browser experience with Playwright when the playwright-cli skill is installed.
allowed-tools: Bash(openspec:*) Bash(playwright-cli:*) Bash(npx playwright:*) Bash(npx --no-install playwright:*)
license: MIT
metadata:
  author: openspec
  version: "1.0"
---

## Delegated workflow presentation

Preserve the leading `* ` orchestration marker and pass coordinator identity
and enrollment context to the active child under the shared title contract.
Use the title manager's escaped write form so Markdown rendering keeps the marker visible.

This is a wrapper/macro, not an independent thread state. Follow the shared
[title contract](../openspec-title-management.md) and
[footer contract](../openspec-footer.md). Delegate title, verified progress and
footer updates to ai-skills-openspec-apply-change. Read and invoke the owning child workflow
at each applicable phase. Do not prepend a macro prefix, append a second
footer, restore an old title between calls, or repeat a child's question on
an unchanged check. The active child invokes `$ai-skills-openspec-title-management` for
its own current-chat title; preserve that child's checkpoints.
Editing this skill does not execute its children.

# Apply OpenSpec Change With Playwright



This skill is a wrapper around `$ai-skills-openspec-apply-change`. It adds browser
validation without changing the behavior or instructions of that skill.

## Continuation invariant

This wrapper inherits the apply skill's continuation invariant. While the
underlying change is `ready` and has remaining tasks, immediately continue
to the next pending task. Do not end a response for a task milestone, test
result, status update, or footer.

Browser validation is the final validation phase after implementation tasks are
complete. If it reveals a defect, return to the relevant OpenSpec task, fix it,
and continue the task loop; do not report a final outcome until the required
browser flow passes or a genuine blocker requires the user's decision.

## Workflow

1. Confirm that `$playwright-cli` is installed and can be loaded.
2. If `$playwright-cli` is unavailable, stop and tell the user to invoke
   `$ai-skills-openspec-apply-change` instead.
3. Invoke `$ai-skills-openspec-apply-change` and follow it exactly for change selection,
   status, context files, task implementation, checkbox updates, pause states,
   and completion reporting. Do not issue an interim final response while its
   ready task loop has remaining work.
4. After the implementation tasks are complete, use `$playwright-cli` to start
   or connect to the application and exercise the requested user-facing flows.
   Use the repository's documented start command and local URL.
5. Inspect snapshots and relevant console or request output. If validation
   reveals a defect, handle it within the OpenSpec workflow and rerun the
   affected validation before reporting completion.
6. Report both the OpenSpec progress and the Playwright validation result only
   after all required tasks and the required browser flow pass, or when a
   genuine blocker requires the user's decision. Do not report completion while
   a required browser flow is failing.

Do not modify `$ai-skills-openspec-apply-change`, create unrelated OpenSpec artifacts, or
infer deployment or publishing work from this skill.
