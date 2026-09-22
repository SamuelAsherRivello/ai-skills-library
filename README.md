# ai-skills-library

Shared AI skills and agent workflow library.

This repository uses the conventional agent skills layout so it can be cloned, inspected, or wired into Codex like a normal project-level skill source:

```text
.agents/skills/<skill-name>/SKILL.md
```

Current skills:

- `.agents/skills/ai-skills-library-welcome`
- `.agents/skills/openspec-grill-me` - custom optional OpenSpec interview workflow
- OpenSpec core profile skills:
  - `.agents/skills/openspec-explore`
  - `.agents/skills/openspec-propose`
  - `.agents/skills/openspec-apply-change`
  - `.agents/skills/openspec-update-change`
  - `.agents/skills/openspec-sync-specs`
  - `.agents/skills/openspec-archive-change`

The OpenSpec core set intentionally matches the lightweight core profile: explore, propose, apply, update, sync, and archive. `openspec-grill-me` is a custom optional companion workflow, not part of OpenSpec's core profile.