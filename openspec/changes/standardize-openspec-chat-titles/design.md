# Design

## Context

OpenSpec skills are standalone instruction folders, while the orchestrator
already owns durable naming state in a project ledger. See `proposal.md` for
motivation and the accompanying delta specs for required behavior.

## Goals / Non-Goals

**Goals:**
- Give every OpenSpec skill one unambiguous three-letter `OS` slug.
- Keep optional title changes safe, observable, and subordinate to user edits.
- Preserve an orchestrated agent's title exactly except for one bracket pair.
- Keep the repository catalog canonical, then synchronize its finished skills
  to global discovery before normal repository publication.

**Non-Goals:**
- Rename user-managed chats after an override or unrelated request.
- Introduce a background title service or change unrelated skill categories.
- Infer task progress outside the two apply workflows.

## Decisions

1. Each OpenSpec skill declares or references its title slot directly, using
   `exp`, `dec`, `dsh`, `prp`, `rev`, `app`, `apw`, `syn`, `arc`, `cmt`, `fin`,
   and `orc`. This keeps titles short and avoids collision with long skill
   names. Using full skill names was rejected because it makes titles harder to
   scan.
2. Apply titles derive progress from the current OpenSpec task count rather
   than a guessed phase. This makes `(07/10)` verifiable. Other workflows omit
   progress because their lifecycle steps are not the change task list.
3. Skills use the supported thread-title capability automatically when it is
   available, and have a no-op/report fallback. Changing the existing title
   skill's explicit-user-title contract is not required.
4. The orchestrator retains its ledger-based user-override detection. Its own
   title uses `[OS-orc: {change}]`; managed agents use only `[{old-name}]`.
   Existing bracketed managed titles are treated as idempotent.
5. The shared footer has a Coordination line that says `Standalone`,
   `Orchestrator`, or `Managed by orchestration`; the established Status,
   Tasks, and Next fields retain their meanings.
6. Lifecycle commands compare differing copies for recency and observable
   quality. They take a newer copy automatically only when it is clearly
   better; an unclear or inferior newer copy remains a user decision.

## Risks / Trade-offs

- [A user edit can race a title update] → Refresh and compare the title before
  every write; record an uncertain result as an override until verified.
- [Title APIs differ by chat backend] → Use the supported title tool with the
  correct backend and skip, rather than retrying blindly, when unavailable.
- [A title lacks a recognizable change name] → Preserve the user title and
  omit the optional update instead of inventing a summary.

## Migration Plan

1. Update all OpenSpec skill instructions, naming reference, catalog, and
   catalog tests in the library.
2. Validate skill structure, catalog consistency, and OpenSpec artifacts.
3. Apply the same conflict rule to push, pull, and move lifecycle skills and
   their shared helper behavior.
4. Synchronize named changed skills only after the comparison policy selects a
   source, then verify content equality.
5. Commit and publish only the scoped repository changes through the normal
   repository workflow.

## Open Questions

None.
