---
name: ai-skills-run-project
description: Run an existing Vite project with npm run dev on a stable project-specific port that avoids conflicts with other local projects.
---

# AI Skills Run Project

Use this skill when the user asks to run, start, host, or preview an existing
local web project, especially a Vite project. It is not for creating a project,
deploying it, or replacing its development tooling.

## Workflow

1. Locate the project root and read its `AGENTS.md` or equivalent repository
   instructions before running commands. Confirm that `package.json` has a
   usable `dev` script and identify the package manager already used by the
   project.
2. Prefer a port declared by the project's scripts, Vite configuration, or
   local documentation. Otherwise derive a stable preferred port from the
   normalized project root (or repository name) within a dedicated local range,
   such as `5100-5999`.
3. Probe the preferred port and subsequent ports in that range immediately
   before startup. Treat a listening port as unavailable and choose the first
   available port. Never stop, reconfigure, or reuse another project's process.
4. Check whether a healthy instance of this same project is already running. If
   its URL responds successfully and can be associated with the requested
   project, reuse it instead of starting a duplicate.
5. Start the existing development script, passing the selected port through the
   package-manager command. For a Vite-compatible script, the normal form is:

   ```sh
   npm run dev -- --host 127.0.0.1 --port <PORT>
   ```

   Preserve the project's package manager and existing script. If the script
   does not forward CLI arguments, use its documented environment-variable or
   configuration mechanism instead of rewriting `package.json`.
6. Prefer the integrated ChatGPT/Codex desktop terminal. If the app exposes a
   terminal panel, reuse the current terminal session or open the terminal in
   the current Codex panel with the app terminal tool, then run the process
   there. Do not launch a separate Windows Terminal, PowerShell, or command
   prompt window. If the integrated terminal is unavailable, use the normal
   local background-process facility and record the process identity.
7. Keep the process running when the user asks to run or host the project.
   Capture logs in an existing project log location when documented; otherwise
   keep them in the terminal/process facility without creating unrelated files.
8. Verify that the selected port is listening and that the application returns
   a useful response before reporting success. If the app needs a browser, open
   the verified URL only after the server is ready.

## Port selection

The port must be stable for the same project but collision-safe across
projects. Use a deterministic hash of the normalized project identity to map
into the dedicated range, then probe forward with wraparound until the range
has been exhausted. Do not claim that a deterministic port is free without
probing it immediately before startup.

If the preferred range is exhausted, stop and report the conflict rather than
using an unrelated well-known port. If a project declares a required port for
callbacks, proxies, or integrations, treat that declaration as authoritative:
report a conflict for user direction instead of silently changing it.

## Verification and cleanup

- Verify both the listener and an HTTP response; an open port alone is not
  evidence that the requested application is ready.
- Report the exact URL, selected port, and whether an existing or newly started
  process is being used.
- If startup fails or times out, include relevant startup output and do not
  claim the server is ready.
- Do not install dependencies, edit project configuration, or kill processes
  unless the user explicitly asks for those actions or repository instructions
  require them.
- Record the started process identity when the execution environment supports
  it so the user can stop this instance without affecting other projects.
