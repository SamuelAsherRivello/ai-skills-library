# Design

## Context

See `proposal.md` for the motivation. The library currently contains
repository-specific run guidance, but no reusable workflow for ordinary local
Vite projects or for choosing ports across multiple projects.

## Goals / Non-Goals

**Goals:**

- Make project port selection deterministic but collision-safe.
- Preserve each project's existing package manager and `dev` script.
- Reuse a healthy same-project process where it can be identified reliably.
- Use the ChatGPT/Codex integrated terminal when the desktop capability is
  available, avoiding extra Windows terminal windows.
- Give the user a verified URL and enough process information for cleanup.

**Non-Goals:**

- Changing Vite configuration, package scripts, dependencies, or application
  source code.
- Managing production servers, deployment, or remote environments.
- Killing arbitrary processes or claiming ownership of another project's port.

## Decisions

### Stable port preference with bounded probing

Hash the normalized project root or another stable project identity into a
dedicated local port range, then probe the preferred port and subsequent ports
before startup. A bounded range makes collisions explicit and prevents a
fallback to a port that has unrelated conventions. A purely fixed port was
rejected because every Vite project would compete for it; a random port was
rejected because it makes repeatable local URLs harder to use.

### Pass the port at invocation time

For Vite-compatible scripts, pass `--host 127.0.0.1 --port <PORT>` through
`npm run dev -- ...`. If a script does not forward arguments, follow its
documented configuration mechanism. Editing project configuration was rejected
because the runner should remain non-invasive.

### Prefer the app terminal, with a process fallback

Use the desktop app's terminal/session capability when present and expose that
terminal in the current Codex panel. If it is not available, use the execution
environment's background-process facility and report its identity. Spawning a
new Windows terminal is not a normal fallback because it creates avoidable
window clutter and weakens process ownership.

### Verify before reporting success

Check both listener availability and an HTTP response, with a short bounded
startup wait. An open TCP port alone was rejected as insufficient because the
process may be a stale or unrelated service.

## Risks / Trade-offs

- [Port identity collisions] → Probe and increment within the bounded range;
  report exhaustion instead of selecting an unrelated port.
- [Same-project detection may be ambiguous] → Reuse only when the process can
  be associated with the requested project and its URL responds successfully.
- [Desktop terminal capability differs by host] → Keep integrated-terminal use
  conditional and retain a documented local-process fallback.
- [CLI argument forwarding differs across scripts] → Detect the script shape
  and use only an existing documented configuration path when forwarding fails.

## Migration Plan

Add the new skill and catalog links. No existing project configuration or
running process is migrated. Existing repository-specific run skills remain
valid and take precedence when they define required ports or startup order.
