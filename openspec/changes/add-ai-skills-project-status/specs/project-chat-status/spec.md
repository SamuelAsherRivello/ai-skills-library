# Spec Delta

## Purpose

Provides a read-only project-wide index of Codex chats so users can quickly
understand current work and open the relevant conversation directly.

## ADDED Requirements

### Requirement: Discover current-project chats

The skill SHALL enumerate all chats associated with the current project,
including pinned and unpinned project chats, without including chats from other
projects or unrelated global recents.

#### Scenario: Project has chats

- **WHEN** the skill runs in a project with one or more associated chats
- **THEN** the result contains one row for every discovered project chat

#### Scenario: Project has no chats

- **WHEN** the project has no associated chats
- **THEN** the result reports that no project chats were found and does not
  fabricate rows

### Requirement: Render a linked status table

The skill SHALL render the discovered chats in a Markdown table with columns
`#`, `Name`, `Status`, `OpenSpec`, `Close?`, and `Comment`, and each chat name
SHALL link directly to that chat using a platform-supported Codex chat link.

#### Scenario: Chat inventory is available

- **WHEN** one or more project chats are discovered
- **THEN** the output contains the requested six columns and every name cell
  is a clickable link to its corresponding chat

#### Scenario: Chat has no usable direct link

- **WHEN** the platform does not provide a supported direct link for a
  discovered chat
- **THEN** the skill reports the limitation instead of inventing a URL

### Requirement: Indicate likely close readiness

The skill SHALL set `Close?` to `✅` only when available metadata supports that
the chat is likely ready to close, and SHALL set it to `❌` for all other chats,
including chats with insufficient evidence.

#### Scenario: Chat is likely complete

- **WHEN** a chat is archived, explicitly complete, or its OpenSpec apply tasks
  are verified complete
- **THEN** its `Close?` cell is `✅`

#### Scenario: Chat is not demonstrably complete

- **WHEN** a chat is active, blocked, still has incomplete tasks, or lacks
  reliable completion evidence
- **THEN** its `Close?` cell is `❌`

### Requirement: Classify OpenSpec phase

The skill SHALL set the `OpenSpec` cell to `N/A` for chats that are not
OpenSpec-related and SHALL identify OpenSpec chats as `Explore`, `Propose`,
`Apply (completed/total)`, or `Archive` using available chat and change state.

#### Scenario: Non-OpenSpec chat

- **WHEN** a project chat does not contain or represent an OpenSpec workflow
- **THEN** its `OpenSpec` cell is exactly `N/A`

#### Scenario: OpenSpec chat with tasks

- **WHEN** a project chat is in the OpenSpec apply phase and task counts are
  available
- **THEN** its `OpenSpec` cell is `Apply (completed/total)` using verified
  counts such as `Apply (0/3)`

#### Scenario: OpenSpec chat without applicable tasks

- **WHEN** a project chat is in the Explore, Propose, or Archive phase
- **THEN** its `OpenSpec` cell contains the corresponding phase label without
  inventing a task count

### Requirement: Summarize each chat concisely

The skill SHALL use the chat's available title and status data and produce a
human-readable comment of one to five words for each row.

#### Scenario: Chat metadata is available

- **WHEN** a chat has a title, status, or summary available
- **THEN** the row uses that metadata to produce a relevant one-to-five-word
  comment and reports the chat status in the `Status` column

#### Scenario: Chat metadata is incomplete

- **WHEN** a chat lacks a useful summary or status field
- **THEN** the skill uses a truthful fallback such as `No summary available`
  without exceeding five words for the comment

### Requirement: Preserve read-only behavior

The skill SHALL inspect and report chat metadata without modifying, archiving,
renaming, reordering, or sending messages to any chat.

#### Scenario: Status report completes

- **WHEN** the skill finishes generating the table
- **THEN** chat state and project organization remain unchanged

#### Scenario: Listing fails

- **WHEN** project chat discovery fails or returns incomplete data
- **THEN** the skill reports the concrete limitation and does not attempt a
  mutating workaround
