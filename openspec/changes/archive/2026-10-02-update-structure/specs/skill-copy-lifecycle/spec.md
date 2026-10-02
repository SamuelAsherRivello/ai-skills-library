# Spec Delta

## MODIFIED Requirements

### Requirement: Push copies global skills into the library checkout
The library SHALL provide `ai-skills-library-push <skill|all>`. A named
invocation SHALL copy the named valid global skill into the local library
checkout. An explicitly requested `all` invocation SHALL consider every valid
top-level global skill. The library destination SHALL be resolved within its
category directory. The command SHALL preserve source files, SHALL not perform
remote Git operations, and SHALL preflight every selected destination before
changing any file.

#### Scenario: Push one global skill
- **WHEN** a user invokes push with the name of a valid global skill and its
  categorized library destination has no conflict
- **THEN** the library checkout receives a copy under the appropriate category
  and the global source remains unchanged

#### Scenario: Push all has a preflight failure
- **WHEN** a user invokes push with `all` and any selected destination is
  invalid or has an unapproved conflict
- **THEN** the command SHALL make no copies and report the blocking skill or
  skills

#### Scenario: Push cannot write to the library
- **WHEN** a user invokes push but cannot write to the local library checkout
- **THEN** the command SHALL make no file changes and explain that a library
  maintainer must import the skill or the user can promote it only to global
  skills

### Requirement: Pull copies library skills into global skills
The library SHALL provide `ai-skills-library-pull <skill|all>`. A named
invocation SHALL copy the named valid library skill into global Codex skills.
An explicitly requested `all` invocation SHALL consider every valid skill
under the library's category directories, including skills outside the three
named product families. The command SHALL preserve library sources, SHALL not
perform remote Git operations, and SHALL preflight every selected destination
before changing any file.

#### Scenario: Pull one library skill
- **WHEN** a user invokes pull with the name of a valid library skill and its
  global destination has no conflict
- **THEN** global skills receives a copy of that skill and the categorized
  library source remains unchanged

#### Scenario: Pull all succeeds
- **WHEN** a user invokes pull with `all` and every selected global destination
  passes preflight
- **THEN** each selected library skill is copied and the report separates
  changed and skipped skills
