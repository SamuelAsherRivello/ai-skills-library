# Spec Delta

## Purpose

Defines safe, compact lifecycle titles for OpenSpec workflows and coordinated
project chats while preserving each user's control over their conversation.

## ADDED Requirements

### Requirement: OpenSpec workflows use stable optional title formats
When title updates are supported in the active environment, each matching
OpenSpec workflow SHALL use its assigned `OS-<slug>` format: `exp`, `dec`, `dsh`,
`prp`, `rev`, `syn`, `arc`, `cmt`, `fin`, and `orc`. The apply workflows SHALL
use `OS-app: {change} ({complete:02d}/{total:02d})` and
`OS-apw: {change} ({complete:02d}/{total:02d})`.

#### Scenario: A planning workflow begins
- **WHEN** an enrolled OpenSpec workflow begins work for a recognizable change
- **THEN** it sets its current chat title to its assigned `OS-<slug>` title
  containing that change name

#### Scenario: An apply workflow advances
- **WHEN** an apply workflow confirms its task counts from OpenSpec
- **THEN** its title may show those zero-padded counts at the end of the title

### Requirement: Title automation preserves user control
OpenSpec title automation SHALL not block workflow work when title tools are
unavailable. It SHALL stop managing a chat after a user renames it or supplies
an unrelated new request, unless the user explicitly resumes title management.

#### Scenario: A user overrides a managed title
- **WHEN** the chat title no longer matches the last title confirmed by the
  automation
- **THEN** the workflow records the override and makes no further automatic
  title changes for that chat

#### Scenario: Title updates are unavailable
- **WHEN** the active environment cannot update a chat title
- **THEN** the workflow continues its authorized work and reports that title
  management was not performed

### Requirement: OpenSpec footers show coordination context
Every OpenSpec workflow footer SHALL retain its Status, Tasks, and Next lines
and SHALL add `Coordination: Standalone`, `Coordination: Orchestrator`, or
`Coordination: Managed by orchestration` according to the active chat context.

#### Scenario: A standalone workflow responds
- **WHEN** an OpenSpec workflow is not under orchestration
- **THEN** its footer includes `Coordination: Standalone`

#### Scenario: An orchestrated workflow responds
- **WHEN** an OpenSpec workflow is acting as the lead or as an enrolled agent
- **THEN** its footer identifies the matching orchestrator or managed-agent
  coordination context

### Requirement: Orchestration wraps enrolled chat titles
An orchestrator SHALL title itself `[OS-orc: {change}]`. For each enrolled
agent it controls, it SHALL preserve the agent's existing title and use only
`[{old-name}]`; it SHALL not apply a role, slug, progress value, or other
reformatting to that agent title.

#### Scenario: The orchestrator enrolls an agent
- **WHEN** an orchestrator performs an authorized initial naming pass
- **THEN** it wraps the agent's existing title in one pair of brackets without
  otherwise changing it

#### Scenario: An enrolled agent was already wrapped
- **WHEN** the agent title already equals its managed bracketed form
- **THEN** the orchestrator leaves it unchanged and does not add nested brackets
