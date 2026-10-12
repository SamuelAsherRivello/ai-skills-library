---
name: ai-skills-project-run-stop
description: Stop only the current project's development server and prove that its process tree and listener are gone.
---

# Project Run Stop

Use this skill when the user asks to stop, shut down, or kill the current
project's development server.

1. Read `AGENTS.md`, `package.json`, the reusable Run reference
   `references/run-configuration.md` when available, and the current project
   run config. Read
   `.agents/project-run-configuration.md` when present. Read
   `output/run-state/project-run.json` if present, but treat it as a hint that
   must be revalidated rather than as authority.
2. Inspect the recorded launcher/listener PIDs, their command lines and parent
   trees, and all project-root development processes. Confirm ownership from
   project-root command context or matching run-record identity. Never infer
   ownership from a port alone.
3. If no confirmed project-owned server exists, report `none running` and do
   not issue a termination command. A stale run record by itself is not a
   running server.
4. For each confirmed project server, report its PID/tree/port, then terminate
   only its root process tree with scoped Windows process control such as
   `taskkill /PID <confirmed-pid> /T /F`. Do not kill all `node`, `npm`, or Vite
   processes and do not touch another project's listener.
5. Re-scan both process inventory and TCP listeners after termination, with a
   bounded wait for child processes. If either remains, report the exact PID,
   port, and evidence; do not broaden the kill. Remove the run record only when
   no confirmed project process or listener remains. If inspection is blocked,
   retain the record and report that shutdown is unconfirmed.
