# Design

## Context

The library contains narrowly scoped, user-invoked skills grouped by domain. See [proposal.md](proposal.md) for motivation and [the archived-chat recovery delta](specs/archived-chat-recovery/spec.md) for required behavior. Codex already exposes archive listing, archive-state updates, and chat navigation; this change packages their safe use as a discoverable library skill.

## Goals / Non-Goals

**Goals:**

- Provide a concise instruction set for finding and restoring one archived Codex chat.
- Separate read-only discovery from the archive-state change and user-visible hand-off.
- Preserve enough candidate metadata for an informed user choice when the description is ambiguous.

**Non-Goals:**

- Reconstructing deleted chats, changing chat contents, or restoring multiple chats in one request.
- Inventing an undocumented Codex URL format when native navigation is available.
- Altering sidebar organization, read state, or unrelated archive state.

## Decisions

### Use archive listing as the discovery source

The skill will use the archived-chat listing capability, following pagination when the initial results do not provide a confident match. It will compare the user's remembered details with returned titles, summaries, and timestamps. This keeps discovery read-only and avoids inspecting unrelated active chats. Searching all chats first was rejected because it broadens access and may return noisy active results.

### Require explicit selection unless the match is unambiguous

When more than one archived chat plausibly fits, the skill will present compact identifying details and wait for the user to select a candidate. It will restore only the selected chat. Automatically choosing the newest or title-nearest candidate was rejected because summaries can be incomplete and restoration changes state.

### Restore, then use native navigation for the hand-off

After restoration succeeds, the skill will open the chat with Codex's navigation capability and report the resulting access path. It may provide a direct link only when the environment returns or documents a supported chat link; otherwise it must not fabricate one. A markdown-only hand-off was rejected because it can leave the user in the original chat without opening the recovered one.

## Risks / Trade-offs

- [Archive metadata is insufficient to distinguish candidates] -> Present the viable candidates and ask the user for a choice rather than restoring speculatively.
- [A chat is beyond the first archive-list page] -> Continue pagination while credible matches remain possible; report the search limitation if no match can be found.
- [Restore or navigation fails after selection] -> Report the failed operation accurately and do not claim the chat is recovered or linked.
- [A native deep link is unsupported] -> Treat successfully opening the restored chat as the hand-off and explain that it is now available in the sidebar.

## Migration Plan

1. Add the skill and its standard metadata in the existing AI Skills Library category.
2. Validate the skill structure and run the repository's relevant checks.
3. Roll back by removing only the new skill directory if validation or review identifies an issue; existing skills and chats are unaffected.
