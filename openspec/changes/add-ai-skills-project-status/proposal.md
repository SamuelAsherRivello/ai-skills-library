# Proposal

## Why

The project currently has no single read-only skill that summarizes the
project's Codex chats, making it difficult to scan active work and jump to the
right conversation. A compact, linked status table would provide a durable
project-level index for quickly orienting in ongoing work.

## What Changes

- Add a new `ai-skills-project-status` skill.
- Inspect all chats associated with the current project using the available
  Codex project/thread listing capabilities.
- Return every discovered chat in a Markdown table with the columns `#`,
  `Name`, `Status`, `OpenSpec`, `Close?`, and `Comment`.
- Render each chat name as a clickable link to that chat.
- Mark the `OpenSpec` column `N/A` for non-OpenSpec chats. For OpenSpec chats,
  report the phase as `Explore`, `Propose`, `Apply (completed/total)`, or
  `Archive`.
- Mark `Close?` with a green checkmark (`✅`) only when available metadata makes
  the chat likely ready to close; otherwise mark it with a red x (`❌`).
- Keep the row order arbitrary and suitable for reference rather than implying
  priority or chronology.
- Generate a concise 1–5 word comment for each chat.
- Keep the operation read-only: do not modify, archive, rename, or reorder
  chats.

## Capabilities

### New Capabilities

- `project-chat-status`: Read-only discovery, OpenSpec phase classification,
  close-readiness indication, and tabular linking of all chats belonging to the
  current project.

### Modified Capabilities

<!-- No existing capability requirements are modified. -->

## Impact

- Adds `.agents/skills/ai-skills-library/ai-skills-project-status/SKILL.md` and
  its agent metadata/configuration as required by the repository's skill
  conventions.
- Depends on the Codex app's project/thread listing and chat-link capabilities.
- Produces Markdown output only; it does not change project files or chat state
  when invoked.
