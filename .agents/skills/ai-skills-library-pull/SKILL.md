---
name: ai-skills-library-pull
description: Copy every shared library skill into Codex user skills without creating links.
---

# AI Skills Library Pull

Use this skill when the user wants the complete local AI Skills Library copied into Codex user skills.

1. Treat this repository's `.agents/skills` directory as the source and `$HOME/.agents/skills` as the destination; on this Windows machine the destination is `C:\\Users\\srive\\.agents\\skills`.
2. Confirm that every library source skill is a real directory, not a symbolic link or junction.
3. Inspect destination names before copying. If a destination is an existing link, remove it only when it resolves to the same library skill. If an existing real directory has the same name, stop and ask the user whether to overwrite it. Do not replace unrelated skills.
4. Copy every library skill directory as a physical copy. Do not create symbolic links or junctions. Verify each destination is a real directory with a `SKILL.md` file.
5. Report copied, skipped, and failed skill names separately, provide the full global directory path, and mention that Codex may need a restart if its skill catalog does not refresh automatically.

Do not modify the library checkout or remote repository as part of this command.
