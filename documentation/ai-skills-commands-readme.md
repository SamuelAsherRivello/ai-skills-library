# AI Skills Library Commands

Use these commands to install, update, and manage skills between this library, your global Codex skills, and a project's `.agents/skills` directory.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Details](#details)

## Getting Started

Use these three steps to install the library, keep it current, and choose the command you need.

### 1. Install Commands

Tell your AI agent:

```
Add all skills from https://github.com/SamuelAsherRivello/ai-skills-library to my global Codex skills.
```

### 2. Update Commands

Over time the library may change with new features. Run:

```
$ai-skills-library-pull all
```

### 3. Choose a Library Command

Use the command list below to copy or move skills between the library, your global Codex skills, and a project.

## Details

### Library Commands

| # | Name | Comment |
| --- | --- | --- |
| 1 | `$ai-skills-library-push <skill>` | Copies one skill from Codex user skills into this library, then commits and pushes it. |
| 2 | `$ai-skills-library-pull` | Copies all library skills into Codex user skills. |
| 3 | `$ai-skills-library-move-global <skill>` | Moves one skill from the current project's `.agents/skills` to Codex user skills. |
| 4 | `$ai-skills-library-move-project <skill>` | Moves one skill from Codex user skills to the current project's `.agents/skills`. |
| 5 | `$ai-skills-library-status` | Lists every library skill and the differences in Codex user and project skills. |

Your global Codex skills directory is `C:\\Users\\<your-user>\\.agents\\skills`.

Commands stop for an existing destination skill instead of overwriting it without your explicit approval.
