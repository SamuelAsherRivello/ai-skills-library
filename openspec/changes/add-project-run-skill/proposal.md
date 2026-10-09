# Proposal

## Why

Running several local Vite projects currently makes the default development
port a source of collisions, and Windows runs can open unnecessary standalone
terminal windows. A reusable project-runner skill should provide a predictable
local URL while reusing the ChatGPT desktop terminal when it is available.

## What Changes

- Add an `ai-skills-run-project` skill for starting an existing project's
  `npm run dev` workflow.
- Select a stable preferred port per project, probe for collisions, and use a
  safe fallback within a dedicated local development range.
- Detect and reuse an already-running instance of the same project when it is
  verifiably healthy.
- When running inside the ChatGPT/Codex desktop app, open or reuse the app's
  terminal panel for the server process so Windows does not spawn a separate
  terminal window; retain a local terminal fallback when the app terminal is
  unavailable.
- Verify readiness and report the exact local URL, port, and process context.
- Add the skill and category to the library catalogs.

## Capabilities

### New Capabilities

- `project-dev-server`: Start and verify an existing local web project's
  development server with collision-safe, project-specific port selection and
  app-terminal reuse.

### Modified Capabilities

- None.

## Impact

- Adds a new skill under `.agents/skills/ai-skills-run/` and updates the root
  and category catalogs.
- Adds workflow guidance for Vite/npm development servers and ChatGPT desktop
  terminal integration; it does not change application source code or project
  Vite configuration.
- Requires the runner to inspect local listening ports and use the desktop
  terminal-panel capability when available.
