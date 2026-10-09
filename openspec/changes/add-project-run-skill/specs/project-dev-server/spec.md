# Spec Delta

## Purpose

Provides a consistent way to run existing local web projects while keeping
development URLs stable, avoiding port collisions, and preserving the desktop
app's integrated terminal experience when available.

## ADDED Requirements

### Requirement: Run an existing project through its development command

The skill SHALL locate an existing project, verify an available `dev` script,
and start that script using the project's established package manager without
rewriting application configuration.

#### Scenario: Project has a supported development script

- **WHEN** the user asks to run an existing project with a `dev` script
- **THEN** the skill starts that script and reports the resulting local URL

#### Scenario: Development script is unavailable

- **WHEN** the project has no usable `dev` script
- **THEN** the skill reports the missing prerequisite and does not start an
  unrelated command

### Requirement: Select a stable collision-safe project port

The skill SHALL derive a stable preferred port from the project identity,
probe it immediately before startup, and choose the first available port in
the configured local development range when the preferred port is occupied.

#### Scenario: Preferred port is free

- **WHEN** the project's preferred port is available
- **THEN** the development server starts on that port

#### Scenario: Preferred port is occupied

- **WHEN** another process is listening on the preferred port
- **THEN** the skill starts on the next available port in the allowed range
  without stopping or modifying the other process

#### Scenario: No safe port is available

- **WHEN** every port in the allowed range is unavailable
- **THEN** the skill reports the conflict and does not start the server on an
  unrelated port

### Requirement: Reuse a healthy existing instance

The skill SHALL reuse a verified healthy instance of the same project instead
of starting a duplicate development server.

#### Scenario: Same project is already running

- **WHEN** the project's existing local URL responds successfully and can be
  associated with the requested project
- **THEN** the skill reports and reuses that URL

### Requirement: Prefer the integrated desktop terminal

When the ChatGPT/Codex desktop app exposes an integrated terminal, the skill
SHALL run or present the development process in that terminal and SHALL NOT
spawn a separate Windows terminal window for the project. If the integrated
terminal is unavailable, it SHALL use the normal local terminal facility.

#### Scenario: Desktop terminal is available

- **WHEN** the skill is run inside the desktop app with a usable terminal panel
- **THEN** the server process runs in or is opened in that panel and no new
  standalone terminal window is spawned

#### Scenario: Desktop terminal is unavailable

- **WHEN** no integrated terminal can be used
- **THEN** the skill falls back to a local background process and reports how to
  identify or stop the started process

### Requirement: Verify readiness and report process context

The skill SHALL verify that the selected port is listening and the application
responds before reporting success, and SHALL report the URL, port, and whether
an existing or newly started process is being used.

#### Scenario: Server becomes ready

- **WHEN** the development server responds on the selected port
- **THEN** the skill reports the verified URL and process context

#### Scenario: Server fails to become ready

- **WHEN** the process exits or never responds within the startup check
- **THEN** the skill reports the failure and includes the relevant startup
  output without claiming the server is ready
