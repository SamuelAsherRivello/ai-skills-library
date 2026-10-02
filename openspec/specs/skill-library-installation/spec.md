# Skill Library Installation Specification

## Purpose

Lets users discover and install selected skills from either independent skill
repository into Codex or Claude Code with the same copy-based entry point and
installation-guide format.

## Requirements

### Requirement: Users can install selected library skills for chosen agents
The library and Blender repository SHALL document `npx skills@latest add
<owner>/<repo> --copy` so users can select individual skills and target Codex
or Claude Code. Both guides SHALL recommend project-local installation by
default and document global installation as an option.

#### Scenario: User installs selected skills
- **WHEN** a user follows the library installation guide and chooses skills
  and target agents in the installer without selecting a scope
- **THEN** the selected skills are installed for the chosen agents and the
  user is told how to update those project-local installations

#### Scenario: User chooses global installation
- **WHEN** a user wants skills available across projects
- **THEN** both guides show the same global-install option using the installer

### Requirement: Categorized library skills are discoverable by the installer
Each skill SHALL remain a self-contained directory with a `SKILL.md` under one
of the documented `ai-skills-create`, `ai-skills-library`, `openspec`, or
`docker-sandbox` categories, and the documented installer SHALL discover
skills in those categories. The Blender repository SHALL remain a separate
repository with its own `skills/` source tree.

#### Scenario: User selects a skill from a category
- **WHEN** a user runs the documented installer against the library
- **THEN** skills from all four categories are available for selection by
  their skill names

### Requirement: Installation documentation distinguishes copies and updates
Both root README installation sections SHALL use the same section structure
and explain that `--copy` creates installed files at the selected agent
location. The guides SHALL identify the update command for project and global
installations. Blender-specific prerequisites and advanced installation
scripts MAY remain in linked documentation.

#### Scenario: User updates installed skills
- **WHEN** a user wants newer versions after installation
- **THEN** both guides identify the installer-supported update command for
  their selected scope

#### Scenario: User chooses Blender's advanced package installer
- **WHEN** a Blender user needs a package-specific installation workflow
- **THEN** the shared quick-install section links to the existing advanced
  Codex and Claude installers without replacing them
