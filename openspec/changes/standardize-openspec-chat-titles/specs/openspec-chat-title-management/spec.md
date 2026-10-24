# Spec Delta

## Purpose

Defines safe, compact lifecycle titles for OpenSpec workflows and coordinated
project chats while preserving each user's control over their conversation.

## ADDED Requirements

### Requirement: OpenSpec workflows use stable optional title formats
When title updates are supported in the active environment, each matching
OpenSpec workflow SHALL use its assigned `OS-<slug>` format. The active owner
SHALL render a verified task or proposal suffix when its workflow has
applicable tracking, and SHALL refresh that suffix whenever verified progress
changes. A workflow without trustworthy applicable tracking SHALL omit the
suffix.

#### Scenario: A planning workflow begins
- **WHEN** an enrolled OpenSpec workflow begins work for a recognizable change
- **THEN** it sets its current chat title to its assigned `OS-<slug>` title
  containing that change name

#### Scenario: A tracked workflow advances
- **WHEN** a title-owning workflow confirms applicable progress from OpenSpec
- **THEN** it renders the current verified count at the end of its title and
  replaces any prior system-owned progress suffix

### Requirement: Title automation rebuilds a user-renamed subject
OpenSpec title automation SHALL not block workflow work when title tools are
unavailable. When the active owner sees a user-renamed title, it SHALL use the
normalized title text as that owner's subject and rebuild the title with the
active owner's prefix. It SHALL remove repeated `OS-<slug>:` fragments,
normalize whitespace, and collapse only exact adjacent duplicated text. It
SHALL preserve all other subject wording, including spelling, capitalization,
and punctuation.

#### Scenario: A user removes the prefix
- **WHEN** an Explore chat titled `OS-EXP: that is fun` is renamed to
  `oops cool`
- **THEN** the next active Explore title is `OS-EXP: oops cool`, followed by a
  current verified progress suffix only when Explore has applicable tracking

#### Scenario: A user supplies another workflow prefix and duplicate text
- **WHEN** the active Proposal chat is renamed to
  `OS-PRP: oops OS-PRP: oops coolcool`
- **THEN** the next active Proposal title is `OS-PRP: oops cool`, with its
  current verified progress suffix when applicable

#### Scenario: A user changes the prefix to a different workflow
- **WHEN** an active Explore chat is renamed to `OS-PRP: oops cool`
- **THEN** the next active Explore title uses `OS-EXP: oops cool` rather than
  retaining the stale Proposal prefix

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
