---
name: openspec-init
description: Safely bootstrap an OpenSpec planning root with the custom global workflow suite. Use for an explicit setup request or before an explicit custom OpenSpec workflow in a project without a root; never installs official project-local skills.
allowed-tools: Bash(openspec:*)
---

## Workflow presentation

Use the shared [title contract](../openspec-title-management.md) and
[footer contract](../openspec-footer.md). This state owns `OS-INI` and footer
phase `Initialize`. There is no task count until a change exists. Own only this
chat's title, preserve human overrides, and leave child workflow titles to their
owners. Emit a footer only at a meaningful checkpoint; never repeat a pending
question or footer on an unchanged check. Editing this skill does not initialize
a project.

# OpenSpec Initialize

This is an explicit-only bootstrap. It separates planning-root initialization
from skill installation: it never creates, copies, deletes, or overwrites a
project skill. Read [bootstrap policy](references/bootstrap-policy.md) before
using it.

Run `scripts/bootstrap.ps1` first without `-Initialize`. It verifies the CLI,
the canonical global custom suite, project and legacy skill roots, symlinks,
and declared OpenSpec stores. Treat every result other than `ReadyToInitialize`
as a stopping condition and report its exact remedy.

Only an explicit `$openspec-init` invocation, or an explicit custom
`$openspec-*` workflow that delegated here, authorizes the second command:

```powershell
scripts/bootstrap.ps1 -ProjectDirectory "<project>" -Initialize
```

The script runs exactly `openspec init --tools none` in the selected project,
then verifies a usable planning root. It must not use `--profile custom`,
`--tools codex`, `.openspec-target`, or any official generator. After success,
resume the originally requested custom workflow. A natural-language mention of
OpenSpec still needs the user's explicit initialization approval.

For a missing or partial global suite, report a trusted library checkout or
repository link requirement. Use `$ai-skills-library-pull` only after the user
authorizes global installation; do not make a project-local copy as a shortcut.
