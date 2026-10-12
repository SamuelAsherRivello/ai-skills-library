---
name: ai-skills-project-run-status
description: Inspect the current project's development server, ownership, port, route health, and browser reachability without changing anything.
---

# Project Run Status

Status is strictly read-only: never start, stop, kill, install, or reconfigure.

1. Read `AGENTS.md`, `package.json`, and
   `BIS/scripts/project-run-config.mjs`, and the reusable Run reference
   `references/run-configuration.md` when available. Read
   `.agents/project-run-configuration.md` when present. Read
   `output/run-state/project-run.json` when present, then validate every PID,
   port, and route against live observations. A stale record is evidence of a
   previous run, not proof that a server exists.
2. Inspect Windows process command lines and parent/child relationships, plus
   listeners on the preferred and fallback ports. Match ownership by project
   root/command context or a validated run record. Never classify a port as
   this project merely because it is the preferred port.
3. Report `none running` when no confirmed project-owned development server is
   present. Otherwise report each confirmed tree's launcher PID, descendant
   PIDs, port, command, start time when available, and whether it is the one
   allowed project server or a duplicate.
4. For every declared route, perform a listener check and HTTP request. Require
   a successful response and the configured application title/marker. Classify
   the server as one of: `healthy`, `process-only`, `listener-only`, `duplicate`,
   `route-unhealthy`, or `host-verification-pending`.
5. When browser access is available, open each route and confirm the expected
   application identity. Report browser URLs only with their actual observed
   state; never invent tab names. If browser attachment or loopback access is
   blocked, say exactly which evidence is unavailable and preserve the process
   and HTTP evidence separately.

For a requested all-projects view, report one row per verified project root
with: root, declaration path or missing, effective range, preferred port,
active port, ownership evidence, route state, and any overlapping declaration
or occupied candidate. Separate active port collisions from declarations that
merely overlap. Keep this inspection read-only.

When conflicts are actionable, present a reconciliation plan before editing:
name every project document, proposed range, and reason. One approval may
authorize the complete named set for that reconciliation only. After approval,
re-read and validate every named document; without approval, leave all files
unchanged and report the conflicts for manual resolution.

## Optional all-projects view

If the user asks for all Vite servers, enumerate listeners and process trees
across projects, group them by normalized project root, and clearly separate
this project from unrelated projects. For each root, read its optional
`.agents/project-run-configuration.md` and report the effective range, active
port, missing declarations, occupied candidates, and overlapping ranges. Keep
this view read-only; a reconciliation plan must name proposed files and ranges
before asking for one approval covering that identified set.
