---
name: ai-skills-project-run-start
description: Use when starting or restarting a local Vite/npm web project and you need one verified, collision-safe development server without opening browser windows.
---

# Project Run Start

Start exactly one development server for the current project, keep unrelated
projects untouched, and report only routes that were verified over HTTP.

For port policy, follow the reusable Run reference at
`../ai-skills-run/references/run-configuration.md` when this skill is installed
from the library checkout. The project-local declaration, when present, is
`.agents/project-run-configuration.md`; this skill must not define a competing
port-range policy.

## Workflow

1. Read `AGENTS.md`, the package manifest, and any authoritative launcher
   config. Preserve the project's package manager and `dev` script. Prefer
   `BIS/scripts/project-run-config.mjs` when present; validate its mode,
   preferred port, and routes.
2. Inspect command lines, parent/child relationships, working directories, and
   listeners. Establish ownership from the project root or command context,
   never from a port number alone. Stop only exact project-owned trees, wait
   for them to disappear, and refuse to replace a tree that cannot be stopped.
3. Invoke the sibling `run-project.ps1` once with `-ProjectRoot`, `-Port`, and
   the routes JSON. Pass `-DisableHmr` only when the user requests a stable
   manual-testing session. The helper probes the bounded dedicated port range,
   binds to loopback, launches `npm run dev -- --host 127.0.0.1 --port ...`,
   captures launcher diagnostics, and returns compact verification JSON.
4. If the helper fails, report its captured diagnostics and stop. Do not start
   a second server manually, silently accept Vite's fallback port, install
   dependencies, or edit project configuration.
5. Verify every configured route with listener state, HTTP status, and the
   response identity (title or configured application marker). In `shared`
   mode use one server for all routes; in `single` mode verify the one entry
   point. A healthy existing server may be reused only when ownership and all
   route checks are established.
6. Do not open browser windows. Report `<application identity> — <verified
   URL>` for each route, include the selected port/process context, and keep
   the verified server running. If a terminal panel cannot attach, say so
   while retaining the live process and its identity.

The one-Vite-per-project invariant applies to every command in this workflow:
never batch-launch servers, reuse an unverifiable process, kill an unrelated
process, or claim a URL without listener and HTTP verification. Stop on missing
config, ambiguous ownership, an unkillable project tree, exhausted ports,
launcher timeout/error, wrong bind/selected port, non-200 or wrong-identity
routes, or unverifiable loopback access; report evidence instead of guessing.
