---
name: ai-skills-project-run-start
description: Restart one owned development server for the current project, prove it is stable, and report only verified application routes.
---

# Project Run Start

Use this skill when the user asks to run, start, host, or preview the current
web project.

## Non-negotiable contract

- The project has zero or one project-owned development server after startup.
- Ownership is established from project-root command context or the persisted
  run record, never from a port number alone.
- A startup banner, a process, or a listening socket is not success. Success
  requires the listener, every configured route, and the expected HTML identity
  to remain healthy across repeated checks.
- If process inspection or browser access is unavailable, keep a live candidate
  when possible and report it as unverified. Never turn missing evidence into a
  claim that a URL works.

## Workflow

1. Read `AGENTS.md`, `package.json`, the reusable Run reference at
   `references/run-configuration.md`, and `BIS/scripts/project-run-config.mjs`.
   Read `.agents/project-run-configuration.md` when present. Treat the current
   run config and effective declaration as authoritative for the command,
   topology, preferred port, routes, and bounded port range. Do not invent one
   server per package.
2. Inspect the persisted record at `output/run-state/project-run.json`, process
   command lines/parents, working-directory evidence when available, and every
   candidate in the effective range. Reconcile only processes proven to belong
   to this project. Preserve unrelated listeners.
3. Invoke the sibling `run-project.ps1` once with `-ProjectRoot`, `-Port`, and
   the config routes JSON. Pass `-DisableHmr` only when the user requests a
   stable manual-testing session. The helper resolves the optional declaration,
   owns cleanup, race-safe range-bounded fallback selection, strict-port launch,
   optional sidecar fallback, stable route checks, and the run record. Do not
   run a second Vite command around it.
4. Treat the helper as successful only when it returns route JSON and writes a
   fresh run record containing the selected port, effective range,
   configuration provenance, launcher/listener PIDs, route titles, and start
   time. If it fails, inspect its log and preserve any unrelated listener; do
   not advertise a guessed port.
5. After helper success, re-read the run record and re-scan processes/listener
   ownership. A duplicate project server is a reconciliation failure: stop only
   the extra confirmed project tree and re-verify the retained one.
6. Verify every configured route over HTTP against the selected port, checking
   successful status plus the expected title/marker. Then verify every reported
   URL in the available real browser context. Browser verification is required
   for the word "verified"; if unavailable, label the route host-verified or
   browser-unverified instead.
7. Keep the server running. Report the actual selected port and one line per
   route using its configured application label and URL. Include sidecar state
   separately; an optional faucet conflict does not invalidate the main Vite
   server when the configured routes are healthy.

Never use `taskkill` globally, never kill by port alone, never trust the Vite
startup log as readiness, and never claim a URL is working without listener and
route evidence. Preserve unrelated listeners. Do not install dependencies or
change project configuration.
