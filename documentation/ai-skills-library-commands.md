# AI Skills Library Commands

Use these commands to copy or move skills between this library, your global Codex skills, and the current project's `.agents/skills` directory. They do not create or use symbolic links or junctions.

| Command | Effect |
| --- | --- |
| `$ai-skills-library-push <skill>` | Copies one skill from Codex user skills into this library, then commits and pushes it. |
| `$ai-skills-library-pull` | Copies all library skills into Codex user skills. |
| `$ai-skills-library-move-global <skill>` | Moves one skill from the current project's `.agents/skills` to Codex user skills. |
| `$ai-skills-library-move-project <skill>` | Moves one skill from Codex user skills to the current project's `.agents/skills`. |
| `$ai-skills-library-status` | Lists every library skill and the differences in Codex user and project skills. |

Your global Codex skills directory is `C:\\Users\\<your-user>\\.agents\\skills`.

Commands stop for an existing destination skill instead of overwriting it without your explicit approval.
