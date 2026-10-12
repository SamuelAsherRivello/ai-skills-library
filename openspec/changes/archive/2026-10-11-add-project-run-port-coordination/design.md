# Design

## Context

The reusable Run Start skill already performs bounded probing, process-tree
ownership checks, route verification, and run-record persistence. The current
contract does not give projects a durable, agent-agnostic way to declare a
preferred range or give Status enough structure to reconcile several project
roots. See `proposal.md` for the motivation.

## Goals / Non-Goals

**Goals:**

- Keep the shared policy in the skill's `references/` directory, following the
  Standards skill pattern.
- Let each repository optionally declare a valid preferred range in a
  human-editable, agent-agnostic file.
- Keep Start bounded to the effective range and make Status useful across all
  visible local projects.
- Make proposed cross-project edits reviewable and bounded by one explicit
  approval for the identified reconciliation set.
- Preserve the existing ownership, verification, and one-server invariants.

**Non-Goals:**

- Creating a central daemon, registry service, or lock server.
- Automatically changing another repository without user approval.
- Replacing project-specific launcher configuration or application Vite files.
- Treating overlapping declarations as an automatic reason to stop healthy
  servers; overlap is reported, while active port collisions remain the
  operational failure condition.

## Decisions

### Keep policy and project data separate

Add the normative explanation and examples at
`.agents/skills/ai-skills-run/references/run-configuration.md`. Store an
individual repository's declaration at `.agents/project-run-configuration.md`.
The first is shipped with the skill; the second is checked into the project
and is readable by any agent that follows the `.agents/` convention. This
avoids treating a shared skill reference as mutable per-project state.

### Use a broad but bounded default

The reference will define a default development pool of `4000–10000`, with
inclusive integer bounds and validation against TCP ports `1–65535`. Projects
may choose narrower non-overlapping blocks inside that pool. Ports below 1024
are discouraged as privileged/system ports, and the dynamic range above 49151
is discouraged for ordinary development stability.

### Prefer declarations, then explicit launcher configuration

The effective configuration is resolved in this order: valid project-local
declaration, authoritative existing project launcher configuration, then the
shared default policy. Existing launcher values remain authoritative when they
express a deliberate fixed port, but Start must still report any conflict and
must not silently escape a declared range.

### Reconcile by observation, not by port number

Status enumerates candidate listeners and process trees, associates them with
verified project roots, reads declarations when available, and presents a
cross-project table. It distinguishes active collisions from merely
overlapping declarations. Start uses the same evidence before selecting a
candidate; Stop continues to terminate only confirmed project-owned trees.

### Make approval bounded to an identified set

When conflicts are found, the workflow can propose a concrete set of files and
range edits. One approval authorizes only that named set during the current
reconciliation. It is not a permanent global permission and does not authorize
future projects or unrelated files.

### Preserve compatibility with both Run skill surfaces

The reusable `ai-skills-run` Start/Status/Stop trio owns the coordination
behavior. The project-specific `ai-skills-library/ai-skills-project-run-start`
skill receives compatibility guidance so it delegates to or follows the same
reference instead of defining a second port policy.

## Risks / Trade-offs

- [A project may not follow the declaration convention] -> Keep the file
  optional, use the documented default, and report the missing declaration.
- [Human-started servers may not expose reliable project-root evidence] ->
  classify the listener as ownership-uncertain and never stop it by port alone.
- [Overlapping ranges can remain after a user declines edits] -> Report the
  overlap and active ports; range-bounded startup still prevents silent escape.
- [Markdown parsing can be ambiguous] -> Define a deliberately small,
  line-oriented schema in the reference and validate all required values before
  using them.
- [A broad default can still be crowded] -> Probe only its bounded candidates,
  report exhaustion, and recommend explicit project blocks.

## Migration Plan

1. Add the shared reference and parser/validation guidance.
2. Update the three reusable skills and helper tests to consume effective
   ranges and report cross-project observations.
3. Add optional declarations to representative projects only when the user
   approves specific files and ranges.
4. Roll back by removing the optional declarations and reverting the skill
   behavior; existing fixed-port project configurations remain usable.

## Open Questions

None for the proposed scope. The exact line-oriented Markdown syntax should be
fixed in implementation tests from the reference document before rollout.
