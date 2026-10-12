# Design

## Context

The repository already contains read-only status skills for comparing skill
files and inspecting Vite servers, but no skill for Codex chat inventory. The
new skill must operate on the current project scope and use the Codex app's
supported thread/project metadata and link mechanisms. See `proposal.md` for
the motivation and `specs/project-chat-status/spec.md` for the behavior
contract.

## Goals / Non-Goals

**Goals:**

- Resolve the current project and enumerate both pinned and unpinned chats
  belonging to it.
- Normalize each chat into a stable table row containing its number, linked
  name, reported status, OpenSpec classification, close-readiness marker, and
  a one-to-five-word comment.
- Preserve source-provided names and statuses, using concise summaries only
  for the comment field.
- Keep discovery strictly read-only and make limitations explicit.

**Non-Goals:**

- Sorting chats by recency, priority, status, or user-defined order.
- Opening, archiving, renaming, reordering, or messaging chats as part of the
  report.
- Reconstructing links when the Codex app does not expose a supported direct
  chat-link format.

## Decisions

- **Use the current project as the scope boundary.** This prevents the report
  from becoming a global recent-chats list and matches the user's request for
  the current project. Project identity should come from the active Codex
  project context rather than a hardcoded project name.
- **Combine pinned and unpinned project chat collections, then deduplicate by
  chat id.** This gives complete coverage while avoiding duplicate rows when a
  chat appears in both collections.
- **Use source order without imposing a semantic sort.** The requested order is
  arbitrary for reference, so preserving the connector's order minimizes
  judgment and keeps the report deterministic for one invocation.
- **Link only with a supported platform mechanism.** The implementation should
  use a direct link returned or documented by the Codex app; it must not guess
  a URI scheme from a chat id. If no supported link exists, it reports that
  limitation plainly.
- **Generate comments from title/status/summary with a five-word cap.** The
  comment is a scanning aid, not a second transcript. A deterministic fallback
  keeps rows valid when metadata is sparse.
- **Use `N/A` as the non-OpenSpec sentinel.** For OpenSpec chats, infer the
  phase from available workflow markers and use verified task counts only for
  `Apply`, formatted as `Apply (completed/total)`. Do not label a chat
  OpenSpec solely because its title happens to contain the word "spec".
- **Use a conservative close-readiness marker.** Emit `✅` only for explicit
  completion/archive evidence or verified completion of all OpenSpec apply
  tasks. Emit `❌` for active, blocked, incomplete, or ambiguous chats so the
  report does not encourage premature closure.

## Risks / Trade-offs

- [Project context unavailable] → Report the missing context and stop without
  falling back to all global chats.
- [Chat list changes during inspection] → Treat the returned snapshot as the
  report source and avoid claiming stronger consistency than the connector
  provides.
- [Unsupported direct links] → Keep the chat name unlinked and explain the
  limitation rather than emitting a guessed or broken URL.
- [Long or ambiguous summaries] → Condense to one-to-five words while keeping
  the wording factual and non-speculative.

## Migration Plan

Add the new skill and its agent metadata under the repository's existing
`.agents/skills` conventions. No existing skill or chat state requires
migration. Removal is a file deletion if the skill is later retired.
