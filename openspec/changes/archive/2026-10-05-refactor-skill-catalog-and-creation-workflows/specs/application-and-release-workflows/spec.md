# Spec Delta

## Purpose

Provides standalone workflows for creating React applications and releasing
template-compatible repositories without coupling either workflow to OpenSpec.

## ADDED Requirements

### Requirement: Users can create a non-game React application
The library SHALL provide `ai-skills-create-app` in the `ai-skills-create`
category. It SHALL create a repository from the shared repository template as
a React application and SHALL exclude game- and Babylon-specific setup unless
the user explicitly changes the requested scope.

#### Scenario: User requests an application
- **WHEN** a user invokes `ai-skills-create-app` with an application idea and
  repository identity
- **THEN** the skill prepares a React application repository from the shared
  template without game-specific implementation

#### Scenario: User requests a game
- **WHEN** a user describes gameplay, game rendering, or a game release
- **THEN** the application skill directs the request to the existing game
  creation workflow rather than silently creating a game as an application

### Requirement: Users can release without an OpenSpec project
The library SHALL provide `ai-skills-release-version` in the
`ai-skills-create` category. It SHALL release a repository without requiring
an OpenSpec root, change, or archived artifact.

#### Scenario: Template-compatible release
- **WHEN** a user explicitly requests a release for a repository with an
  existing compatible GitHub Actions release workflow and `version.txt`
- **THEN** the skill derives the established next-version rule, updates
  `version.txt`, dispatches and monitors the release workflow, and verifies
  the resulting remote tag and release

#### Scenario: Release setup is absent or incompatible
- **WHEN** the target repository lacks a compatible checked-in workflow or a
  usable `version.txt` release source
- **THEN** the skill reports the missing prerequisite and makes no release
  infrastructure, tag, or GitHub release
