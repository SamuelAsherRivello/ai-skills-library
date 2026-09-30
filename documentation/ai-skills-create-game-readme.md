# AI Skills Create Game

Use `$ai-skills-create-game` to turn a game idea into a tested browser game with a public GitHub Pages demo. Single player is the default; multiplayer requests use the shared Colyseus server.

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

The workflow uses the required [repository template](https://github.com/SamuelAsherRivello/github-repository-template), this skills library, Babylon Lite with WebGPU, and OpenSpec. By default, it carries the request through implementation, release, and GitHub Pages deployment. Specify planning-only or local-only work when that is the intended scope.

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

Defaults include a responsive 9:16 portrait play area, keyboard and touch controls, a complete replayable loop, and clear recovery states. Explicit requirements override these defaults. The default GitHub owner is `SamuelAsherRivello`; publishing requires access to the selected account and repositories.

## Singleplayer vs Multiplayer

| Aspect | Singleplayer | Multiplayer |
| --- | --- | --- |
| Players | One local player. | Multiple connected players; cooperative or competitive, as requested. |
| Selection | Default mode; use `mode: single-player` explicitly if desired. | Use `mode: multiplayer` or describe multiplayer in your request. |
| Backend | No multiplayer server required. | Uses the shared [RMC Colyseus Multiplayer Server](https://github.com/SamuelAsherRivello/rmc-colyseus-multiplayer-server). |
| Repository access | Requires access to the game repository for publishing. | Also requires write access to the server repository, or you can fork it and provide your writable fork's URL. |
| Server updates | No server changes or backend release required. | The command automatically updates the selected server repository with the game-specific multiplayer logic. |
| Verification | Test the local gameplay loop and controls. | Also test synchronization and gameplay across multiple connected clients. |

## Workflows

Use these example workflows as starting points for your own game prompts.

- [Game creation workflows](workflows-readme.md#workflow-3-create-game)
