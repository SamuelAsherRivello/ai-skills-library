---
name: openspec-dashboard
description: Open, set up, or inspect the local OpenSpecUI dashboard for an OpenSpec project. Check required CLI dependencies first, install or initialize missing pieces when authorized, and keep the dashboard read-only unless the user explicitly requests an action.
---

## Workflow presentation

Use the shared [title contract](../openspec-title-management.md) and
[footer contract](../openspec-footer.md). This state owns `OS-DSH`
and footer phase `Dashboard`. Add verified task progress when applicable;
the program coordinator counts proposals instead. Delegate every title read and
write for this chat to `$openspec-title-management`; it preserves a normalized
user subject, restores `OS-DSH`, and refreshes verified progress. Leave child
workflow titles to their owners.
Emit one footer per meaningful checkpoint, never on unchanged polls or
commentary. While a question is unanswered, leave its original question and
footer in place without repeating either on a goal or timer check. Show the
next available skill command in backticks when a phase transition is ready.
Editing or evaluating this skill does not activate these presentation rules.

# OpenSpec Dashboard



Use this skill when the user asks to open, inspect, repair, or use the local OpenSpecUI dashboard for an OpenSpec project.

This skill is a local dashboard launcher and inspector. It does not call an AI service, delegate work to another agent, or invent a separate dashboard. When invoked for a dashboard request, use the terminal before replying; do not only print commands for the user to run.

When the request also concerns the project's Vite preview server, use the
project lifecycle skills as needed:

- `ai-skills-project-run-start` for starting or restarting the project's Vite
  server and verifying its application routes.
- `ai-skills-project-run-status` for read-only project-server/process/route
  status.
- `ai-skills-project-run-stop` for stopping only the current project's Vite
  server.

Resolve the installed canonical global skills first. Use a project's local
copy only when it is a confirmed intentional private fork; never merge the two
sources or create a duplicate as a fallback. Do not use the Vite lifecycle skills to
start, stop, or inspect the OpenSpecUI server itself. Keep the dashboard and
project preview as separate servers, and preserve each skill's ownership and
one-server invariants.

## Dependency And Project Setup

Before launching the dashboard, check the current project and required CLIs.

1. Resolve the project path from the user's request or the current working directory.
2. Resolve the OpenSpec root with `openspec context --json` (or `openspec list --json` when that is the supported compatibility path). Use the returned `root.path` as canonical rather than inferring a `.openspec/` or `openspec/` folder. A null root means initialization would be a planning write: explain that and wait for explicit approval. If a declared store cannot be resolved, stop and report the CLI's concrete error instead of treating the project as uninitialized.
3. Check CLI availability with read-only commands:
   - `openspec --version`
   - `openspecui --help`
4. If OpenSpec is missing, inspect the project documentation for its expected install command. If no project-specific command exists, ask for approval before installing the OpenSpec CLI globally with npm.
5. If OpenSpecUI is missing, ask for approval before installing the dashboard CLI globally with npm.
6. If the project is not initialized for OpenSpec, use `$openspec-init` for source and duplicate preflight. It may initialize planning data only with `openspec init --tools none` after an explicit custom workflow invocation; otherwise ask for setup authorization.
7. If setup or installation fails, report the exact failing command and concrete error. Do not claim the dashboard is unavailable without first attempting the relevant check or setup path.

Prefer existing local commands and project scripts over global installs. Never ask the user to paste secrets. Do not modify implementation code as part of dashboard setup.

## Launch

Use browser-safe port `6001` by default; Chromium blocks port `6000` as unsafe.

For a project path:

```powershell
openspecui serve "<project-path>" --web --port 6001 --no-open
```

If port `6001` is already in use, choose the next available safe localhost port and report the actual URL.

The dashboard URL is usually:

```text
http://localhost:6001
```

Leave the server running for the preview session. If browser control is available, open or focus the dashboard and inspect the visible page before reporting completion.

If the user asks to run the project preview alongside the dashboard, invoke
`ai-skills-project-run-start` for the Vite server after the dashboard is
available, then report both URLs and clearly label which server each URL uses.
Do not open project routes merely because the dashboard was launched.

If the user asks whether the project is running while using the dashboard,
invoke `ai-skills-project-run-status` and report its read-only findings. If the
user asks to stop the project preview, invoke `ai-skills-project-run-stop`.
Stopping the project preview must not stop OpenSpecUI unless the user
explicitly asks to stop the dashboard too.

For the native application surface, use only when the user asks for it:

```powershell
openspecui --app
```

Use `openspecui --help` when the user asks about available modes or when the launch command fails.

## Read-Only Inspection

Treat the dashboard as a view by default.

When the user asks to look at the dashboard, summarize the actual visible state: active changes, artifact/task progress, blocked or ready work, and repository scope. Do not summarize the product marketing page when the project dashboard is what the user requested.

Do not click workflow actions such as Apply, Archive, Continue, Fast-forward, Verify, or destructive/irreversible controls unless the user explicitly asks for that action.

## Configure Custom OpenSpec Workflows

Do not use OpenSpecUI's Agent Integrations generator for the custom suite:
`--profile custom` means OpenSpec's profile, not this library. For an explicit
custom setup request, run `$openspec-init` and retain the globally installed
custom suite. It creates planning data with `openspec init --tools none` only;
it never generates project-local skills or `.openspec-target`. Reload the
dashboard after initialization and verify the resolved planning root.

## Windows CLI-Runner Recovery

If the dashboard reports `where.exe EPERM`, `spawn EPERM`, or cannot locate the OpenSpec runner:

1. Verify `where.exe openspec`, `where.exe openspecui`, and `node --version`.
2. Find the installed OpenSpec JavaScript runner without printing secrets. Common npm global locations are under `%APPDATA%\npm\node_modules\@fission-ai\openspec\bin\openspec.js`.
3. If the dashboard has an Execute Path setting, set it to the direct Node invocation for the discovered runner, for example:

```text
"C:\Program Files\nodejs\node.exe" "C:\Users\<user>\AppData\Roaming\npm\node_modules\@fission-ai\openspec\bin\openspec.js"
```

4. Restart the dashboard from a terminal with permission to spawn child processes.
5. Reload the dashboard and confirm the CLI error is gone before reporting success.

If elevated execution is required, request approval for the specific command instead of silently changing permissions or substituting another dashboard.
