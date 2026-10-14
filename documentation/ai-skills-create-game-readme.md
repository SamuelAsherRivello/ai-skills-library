# AI Skills Create Game

Use `$ai-skills-create-game` to turn a game idea into a tested browser game with a public GitHub Pages demo. Single player is the default; multiplayer requests use the shared Colyseus server and a verified Vercel backend.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Arguments](#arguments)
3. [Singleplayer vs Multiplayer](#singleplayer-vs-multiplayer)
4. [Workflows](#workflows)

## Getting Started

Install the library's skills using the [library setup instructions](../README.md#getting-started), then invoke the skill in Codex:

```text
$ai-skills-create-game
game: A one-screen arcade game where a robot redirects falling sparks into matching batteries before they overflow.
name: Spark Sorter
art: Chunky toy-like machinery, dark navy metal, warm orange sparks, readable silhouettes.
requirements: A 90-second score challenge with keyboard and touch controls.
```

A short natural-language request also works:

```text
$ai-skills-create-game Create a single-player maze game where a tiny robot collects batteries before time runs out.
```

The workflow uses the required [repository template](https://github.com/SamuelAsherRivello/github-repository-template), this skills library, Babylon Lite with WebGPU, and the in-scope global OpenSpec workflow. A game-delivery request creates a public GitHub repository from the template and carries the request through implementation, release, and playable GitHub Pages deployment. Multiplayer additionally deploys and verifies its Vercel backend. Planning-only is supported when explicitly requested; local-only is not a substitute for unavailable required access.

## Intake and access gate

Before implementation, the skill asks only for essential missing choices: 2D or 3D, single-player or multiplayer, art source (user-supplied, AI-generated, or online assets with provenance and rights), and required services or credentials. It then reports readiness for GitHub, the template, GitHub Pages, multiplayer Vercel/server access when applicable, the global OpenSpec skills, Playwright CLI by default, and any prompt-specific service.

Missing required access, credentials, or global OpenSpec skills pauses the work before implementation. The skill does not install alternatives, create repository-local OpenSpec skills, or quietly return a local-only game. Playwright CLI is optional; when available it is the default browser-verification route. The required OpenSpec sequence is Explore, Propose, optional Update if the plan changes, then Apply.

## Arguments

These are prompt inputs, not command-line flags. Only `game` is required.

| Input | Purpose | Default |
| --- | --- | --- |
| `game` | Core idea, player actions, and objective. | Required. |
| `mode` | `single-player` or `multiplayer`; natural-language multiplayer requests also select multiplayer. | `single-player` |
| `name` | Display name and/or repository slug. | Derived from the idea; repository slug `babylon-lite-<game-slug>`. |
| `art` | Visual direction, palette, mood, and supplied assets. | Original, cohesive artwork suited to the mechanics. |
| `references` | URLs, files, or named games, with their role and whether to follow them faithfully or use them as inspiration. | No required reference. |
| `requirements` | Must-haves, exclusions, controls, camera, aspect ratio, repository owner, destination, or delivery scope. | Skill defaults apply. |

Defaults include a responsive 9:16 portrait play area, keyboard and touch controls, a complete replayable loop, and clear recovery states. Explicit requirements override these defaults. The workflow resolves and verifies the AI organization as the default GitHub repository owner unless the user explicitly supplies another owner; it does not invent an organization slug. Its required automation identity is the existing user `ai-rmc-com` (the AI user). Naming either does not establish authentication or permission to create/publish for the resolved owner, so the workflow verifies those facts first.

## Singleplayer vs Multiplayer

| Aspect | Singleplayer | Multiplayer |
| --- | --- | --- |
| Players | One local player. | Multiple connected players; cooperative or competitive, as requested. |
| Selection | Default mode; use `mode: single-player` explicitly if desired. | Use `mode: multiplayer` or describe multiplayer in your request. |
| Backend | No backend. | Uses the shared [RMC Colyseus Multiplayer Server](https://github.com/SamuelAsherRivello/rmc-colyseus-multiplayer-server) deployed and verified on Vercel. |
| Repository access | Requires GitHub permission to create a public repository from the template and publish it to Pages. | Also requires write access to the server repository (or a provided writable fork) and its Vercel project. |
| Server updates | No server changes or backend release required. | The command automatically updates the selected server repository with the game-specific multiplayer logic. |
| Verification | Verify the playable public GitHub Pages game and its gameplay loop and controls. | Also verify the Vercel backend, synchronization, and gameplay across multiple connected clients. |

## Workflows

Use these example workflows as starting points for your own game prompts.

- [Game creation workflows](workflows-readme.md#workflow-3-create-game)
