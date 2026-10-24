# Design

## Context

OpenSpec skills are standalone instruction folders, while the orchestrator
already owns durable naming state in a project ledger. See `proposal.md` for
motivation and the accompanying delta specs for required behavior.

## Goals / Non-Goals

**Goals:**
- Give every OpenSpec skill one unambiguous three-letter `OS` slug.
- Keep optional title changes safe, observable, and responsive to user-edited
  subjects.
- Preserve an orchestrated agent's title exactly except for one bracket pair.
- Keep the repository catalog canonical, then synchronize its finished skills
  to global discovery before normal repository publication.

**Non-Goals:**
- Correct user spelling, punctuation, capitalization, or subjective wording.
- Introduce a background title service or change unrelated skill categories.
- Infer task progress outside the two apply workflows.

## Decisions

1. Each OpenSpec skill declares or references its title slot directly, using
   `exp`, `dec`, `dsh`, `prp`, `rev`, `app`, `apw`, `syn`, `arc`, `cmt`, `fin`,
   and `orc`. This keeps titles short and avoids collision with long skill
   names. Using full skill names was rejected because it makes titles harder to
   scan.
2. Every owner derives an applicable task or proposal suffix from current
   verified OpenSpec progress rather than a guessed phase. It rebuilds that
   suffix at every meaningful title update and after observed progress changes.
   An owner without trustworthy applicable tracking omits the suffix instead of
   inventing a count.
3. Skills use the supported thread-title capability automatically when it is
   available, and have a no-op/report fallback. The active owner reads the
   current title before each write. A changed title supplies a user subject:
   remove repeated `OS-<slug>:` fragments, normalize whitespace, and collapse
   only exact adjacent repeated text (including an exact repeated final word or
   phrase). The active owner then renders its own prefix and current verified
   suffix. It does not correct spelling, punctuation, capitalization, or other
   subjective wording.
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
  every write; use the latest title as the user subject, then verify the
  normalized rebuilt title before retrying.
- [Title APIs differ by chat backend] → Use the supported title tool with the
  correct backend and skip, rather than retrying blindly, when unavailable.
- [A title lacks a recognizable change name] → Preserve its normalized text as
  the subject and omit only an unverified progress suffix.

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
