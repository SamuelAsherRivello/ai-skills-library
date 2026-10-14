# Create

Use these explicit workflows to create a repository, build an application or
game from the shared template, or release a prepared repository. App and game
creation resolve and verify the AI organization as owner unless the user
explicitly supplies another owner. The required automation identity is the
existing user `ai-rmc-com` (the AI user); each workflow verifies that it is
authenticated and can create repositories for the resolved owner.

## User Workflows

| # | Name | Comment |
|---:|---|---|
| 1 | [ai-skills-create-app](./ai-skills-create-app/SKILL.md) | Create a non-game React application from the shared repository template after its requirements and access gate passes; client-only by default, with a verified compatible multiplayer path when requested. |
| 2 | [ai-skills-create-game](./ai-skills-create-game/SKILL.md) | Create and publish a single-player or requested multiplayer browser game. |
| 3 | [ai-skills-create-github-release](./ai-skills-create-github-release/SKILL.md) | Release a repository through its checked-in GitHub Actions version workflow. |
| 4 | [ai-skills-create-github-repo](./ai-skills-create-github-repo/SKILL.md) | Create a repository from the shared template and prepare its checkout. |
| 5 | [ai-skills-create-playtest](./ai-skills-create-playtest/SKILL.md) | Guide a human through verifying a web application before release. |
