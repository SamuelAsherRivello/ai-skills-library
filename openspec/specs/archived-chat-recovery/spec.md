# Archived Chat Recovery Specification

## Purpose

Enables safe recovery of an archived Codex chat from the details a user remembers.

## Requirements

### Requirement: Archived chat discovery
The library SHALL provide a skill that searches the user's archived Codex chats from a natural-language description and identifies matching conversation metadata without altering archive state.

#### Scenario: Description identifies one archived chat
- **WHEN** the user describes an archived chat and one candidate matches the available title and summary metadata
- **THEN** the skill selects that archived chat for recovery

#### Scenario: Description does not identify a chat
- **WHEN** the archived-chat search returns no credible match
- **THEN** the skill reports that no matching archived chat was found and leaves archive state unchanged

### Requirement: Ambiguous recovery confirmation
The skill SHALL obtain the user's selection before restoring a chat when multiple plausible archived-chat candidates exist or the requested chat cannot be identified with confidence.

#### Scenario: Several chats plausibly match
- **WHEN** the search returns more than one plausible archived chat
- **THEN** the skill presents concise candidate identifiers and waits for the user to choose one before restoring any chat

### Requirement: Restore and surface selected chat
After the user has selected a chat, the skill SHALL restore only that chat and make it accessible from the current Codex session through a direct link when supported or by opening the restored chat.

#### Scenario: Selected chat restores successfully
- **WHEN** the user selects an archived chat
- **THEN** the skill unarchives that chat, opens it in Codex, and tells the user how to access it from the current session

#### Scenario: Restore operation fails
- **WHEN** Codex cannot restore the selected chat
- **THEN** the skill reports the failure and does not claim that the chat was recovered
