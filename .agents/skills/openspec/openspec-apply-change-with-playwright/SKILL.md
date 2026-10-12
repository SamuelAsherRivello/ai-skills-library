---
name: openspec-apply-change-with-playwright
description: Implement an OpenSpec change and validate the resulting browser experience with Playwright when the playwright-cli skill is installed.
allowed-tools: Bash(openspec:*) Bash(playwright-cli:*) Bash(npx playwright:*) Bash(npx --no-install playwright:*)
license: MIT
metadata:
  author: openspec
  version: "1.0"
---

# Apply OpenSpec Change With Playwright

## Chat title

Follow the shared [chat title contract](../openspec-title-management.md). This
workflow uses `OS-apw: {change} ({complete:02d}/{total:02d})`, with counts
confirmed by the wrapped apply workflow, and renders the shared footer.

This skill is a wrapper around `$openspec-apply-change`. It adds browser
validation without changing the behavior or instructions of that skill.

## Workflow

1. Confirm that `$playwright-cli` is installed and can be loaded.
2. If `$playwright-cli` is unavailable, stop and tell the user to invoke
   `$openspec-apply-change` instead.
3. Invoke `$openspec-apply-change` and follow it exactly for change selection,
   status, context files, task implementation, checkbox updates, pause states,
   and completion reporting.
4. After the implementation tasks are complete, use `$playwright-cli` to start
   or connect to the application and exercise the requested user-facing flows.
   Use the repository's documented start command and local URL.
5. Inspect snapshots and relevant console or request output. If validation
   reveals a defect, handle it within the OpenSpec workflow and rerun the
   affected validation before reporting completion.
6. Report both the OpenSpec progress and the Playwright validation result. Do
   not report completion while a required browser flow is failing.

Do not modify `$openspec-apply-change`, create unrelated OpenSpec artifacts, or
infer deployment or publishing work from this skill.
