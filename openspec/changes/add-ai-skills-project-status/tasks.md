# Tasks

## 1. Skill contract and metadata

- [x] 1.1 Create `.agents/skills/ai-skills-library/ai-skills-project-status/SKILL.md` with the read-only current-project chat discovery workflow and verify it references the project-chat-status requirements
- [x] 1.2 Add the skill's `agents/openai.yaml` display metadata and verify the skill is discoverable with the repository's existing skill layout
- [x] 1.3 Document the six-column output contract (`#`, `Name`, `Status`, `OpenSpec`, `Close?`, `Comment`), supported chat links, close-readiness markers, and one-to-five-word comments in the skill instructions and verify the examples match the contract

## 2. Chat and OpenSpec reporting behavior

- [x] 2.1 Implement current-project scoping across pinned and unpinned chats with id-based deduplication and verify unrelated project chats are excluded
- [x] 2.2 Implement linked name rendering and source-order table numbering, with a truthful limitation when no supported direct chat link is available, and verify no chat mutation tools are called
- [x] 2.3 Implement OpenSpec classification as `N/A`, `Explore`, `Propose`, `Apply (completed/total)`, or `Archive`, and verify apply counts come from the relevant OpenSpec state
- [x] 2.4 Implement one-to-five-word comment generation with truthful fallbacks and verify every row satisfies the word limit
- [x] 2.5 Implement conservative `Close?` markers using explicit completion/archive evidence or verified completed OpenSpec tasks, and verify ambiguous or incomplete chats receive `❌`

## 3. Validation

- [x] 3.1 Run repository skill validation or an equivalent read-only inspection and verify the new skill files, links, table headings, phase labels, and read-only boundaries are present
- [x] 3.2 Exercise the skill against a project containing mixed OpenSpec and non-OpenSpec chats and verify the resulting Markdown table has clickable names, correct `OpenSpec` values, and conservative `Close?` markers
