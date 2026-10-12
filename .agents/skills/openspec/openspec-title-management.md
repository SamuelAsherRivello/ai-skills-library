# OpenSpec Chat Title Contract

Use this contract only when the active environment supports safe thread-title
updates. Set a matching workflow's title when it begins work, then update it
only while the current title still equals the last title that workflow
confirmed. If the user renames the chat or gives an unrelated request, stop
managing the title until the user explicitly resumes it. A title-tool failure
must not block the requested OpenSpec work.

| Workflow | Title |
| --- | --- |
| `openspec-explore` | `OS-exp: {topic}` |
| `openspec-grill-me` | `OS-dec: {change}` |
| `openspec-dashboard` | `OS-dsh: {change}` |
| `openspec-propose` | `OS-prp: {change}` |
| `openspec-update-change` | `OS-rev: {change}` |
| `openspec-apply-change` | `OS-app: {change} ({complete:02d}/{total:02d})` |
| `openspec-apply-change-with-playwright` | `OS-apw: {change} ({complete:02d}/{total:02d})` |
| `openspec-sync-specs` | `OS-syn: {change}` |
| `openspec-archive-change` | `OS-arc: {change}` |
| `openspec-commit-inclusive` | `OS-cmt: {change}` |
| `openspec-macro-finalize-sync-archive-commit-push` | `OS-fin: {change}` |
| `openspec-orchestrate` | `[OS-orc: {change}]` |

The orchestrator wraps an enrolled agent title as `[{old-name}]` only. It
does not assign that agent a slug, role prefix, or progress suffix. Avoid
nested brackets by treating an already managed bracketed title as unchanged.
