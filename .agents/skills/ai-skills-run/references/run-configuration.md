# Run Configuration

This reference defines the optional, agent-agnostic project declaration used
by the Start, Status, and Stop skills. It is policy documentation shipped with
the reusable Run skill; it is not a runtime lock file or a central registry.

## Project declaration

Create this file at the project root when the project wants an explicit local
development-port preference:

```text
.agents/project-run-configuration.md
```

Use this deliberately small line-oriented format:

```text
# Project Run Configuration
preferredPort: 7000
portRange: 7000-7099
```

The recognized keys are:

- `preferredPort`: one integer TCP port inside `portRange`.
- `portRange`: an inclusive `min-max` range.

Blank lines and lines beginning with `#` are ignored. Unknown keys are ignored
for forward compatibility. A malformed, reversed, out-of-bounds, or internally
inconsistent declaration is invalid; the runner reports the error and does not
widen or reinterpret it.

## Defaults and valid ports

When no declaration exists, the shared default development pool is:

```text
4000-10000
```

The valid TCP-port domain is `1-65535`. Ports below `1024` are discouraged
because they are traditionally privileged. Ports above `49151` are discouraged
for ordinary development because operating systems commonly use them for
dynamic or ephemeral connections. Projects may declare a narrower range inside
the default pool, such as `7000-7099`, to make several projects easy to keep
apart.

Existing authoritative launcher configuration may supply the preferred port
when no project declaration exists. It must still be reconciled with the
effective range and must never cause Start to silently escape that range.

## Start behavior

Start probes the preferred port first, then available candidates within the
effective inclusive range. It preserves listeners that cannot be proven to
belong to the current project. If every candidate is unavailable or unsafe, it
reports range exhaustion instead of selecting an unrelated port.

The selected port, effective range, and declaration provenance belong in the
run record so Status and Stop can revalidate them. A range is a selection
boundary, not ownership evidence: process-root and command-context checks still
control cleanup.

## Status and reconciliation

Status may enumerate visible development processes, group them by verified
project root, read declarations, and report:

- active port and process ownership;
- occupied candidate ports;
- overlapping declarations;
- projects with no declaration; and
- ownership or inspection uncertainty.

Overlapping declarations are a coordination warning, not permission to stop a
healthy process. Status remains read-only.

When a reconciliation plan identifies concrete project files and proposed
non-overlapping ranges, one user approval authorizes edits to that named set
for that reconciliation only. It does not authorize future projects,
unrelated files, or automatic termination of listeners. A declined plan leaves
all project declarations unchanged.
