# Tasks

## 1. Archived-chat recovery skill

- [x] 1.1 Create `.agents/skills/ai-skills-library/ai-skills-unarchive/SKILL.md` with discovery, ambiguity handling, selected-chat restoration, and native navigation instructions; verify it satisfies every scenario in `archived-chat-recovery`.
- [x] 1.2 Add `ai-skills-unarchive/agents/openai.yaml` with library-consistent UI metadata; verify the metadata names the skill and its recovery purpose accurately.

## 2. Library integration and validation

- [x] 2.1 Add the new skill to `.agents/skills/ai-skills-library/README.md`; verify the README link resolves to the new `SKILL.md`.
- [x] 2.2 Run the Skill Creator quick validator for the new skill and review the instructions against the no-guess restoration and native-navigation decisions; verify validation passes with no unfinished scaffolding.
