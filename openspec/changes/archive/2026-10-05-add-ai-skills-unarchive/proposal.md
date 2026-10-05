# Proposal

## Why

Users can lose track of a Codex chat after it has been archived. The library needs a reusable, safe workflow that finds the likely chat, restores only the intended one, and makes the recovered conversation easy to reopen.

## What Changes

- Add an `ai-skills-unarchive` skill in the AI Skills Library category.
- Direct the skill to search archived Codex chats from the user's description, disambiguate plausible matches before changing state, and restore the selected chat.
- Direct the skill to open the restored chat and give the user a usable Codex link or navigation result.
- Keep the workflow limited to archive discovery and restoration; it does not edit chat contents or archive other chats.

## Capabilities

### New Capabilities

- `archived-chat-recovery`: Recover a user-selected archived Codex chat and make it accessible again.

### Modified Capabilities

- None.

## Impact

- Adds a new skill directory under `.agents/skills/ai-skills-library/` and its metadata.
- Uses Codex chat archive, restore, and navigation capabilities; no application runtime dependencies or public APIs change.
