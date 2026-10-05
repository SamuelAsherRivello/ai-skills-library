# Workflows

Reusable AI workflows turn good instructions into consistent, repeatable results.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Details](#details)
   1. [Workflow 1: Install Skills](#workflow-1-install-skills)
   2. [Workflow 2: Create a Repository](#workflow-2-create-a-repository)
   3. [Workflow 3: Create Game](#workflow-3-create-game)
      1. [Single player (2D)](#single-player-2d)
      2. [Multiplayer (2D)](#multiplayer-2d)
      3. [Single player (3D)](#single-player-3d)
      4. [Multiplayer (3D)](#multiplayer-3d)

## Getting Started

Creating your own AI workflows is important because they turn repeatable work into a
reliable process. A well-written workflow helps your AI follow the same steps and produce
consistent results. Reusable workflows also make successful instructions easier to share,
improve, and run again.

## Details

### Workflow 1: Install Skills

Use this workflow to install shared skills into your AI agent's global skills directory.

**Prompt AI:**

```text
Add these skills to your AI global skills:

- https://github.com/SamuelAsherRivello/ai-skills-library/
- https://github.com/SamuelAsherRivello/ai-skills-blender/
```

### Workflow 2: Create a Repository

Use this workflow to create a new public GitHub repository from the shared project template.

**Prompt AI:**

```text
$ai-skills-create-github-repo

- Suggested Skills:
  - -
- Repository name:
  - fun-project
- Project folder:
  - fun-project
- Project name:
  - Fun Project
- Visibility:
  - Public
```

### Workflow 3: Create Game 

Use a **template** below as inspiration for your own game.

#### Single player (2D)

**Prompt AI:**

```text
$ai-skills-create-game

- Suggested Skills:
  - -
- Title:
  - Pacman Maze Chase
- Type:
  - Single Player
- Camera:
  - Top-down orthographic
- Core loop:
  - Navigate a maze, collect pellets, avoid enemies, and clear the board
- Look and feel:
  - Black background with a bright neon-blue maze outline, white pellets, flashing power pellets, and a high-contrast HUD.
  - Saturated yellow player with a simple two-frame mouth animation and four distinct red, pink, cyan, and orange enemies with readable silhouettes.
  - Crisp pixel-inspired shapes without gradients or realistic textures, short arcade transitions, and a symmetrical cabinet-style layout readable at a glance.
- Inspiration links:
  - https://www.pacman.com/
  - https://en.wikipedia.org/wiki/Pac-Man
- Inspiration screenshots:
  - Attach reference screenshots here.
- Originality requirement:
  - Create original artwork, sounds, names, and levels; use links only as references.
```

#### Multiplayer (2D)

You must have write access to [rmc-colyseus-multiplayer-server](https://github.com/SamuelAsherRivello/rmc-colyseus-multiplayer-server) or a fork of it. The command will automatically update that repository with the multiplayer server changes required by your game. If using a fork, provide its URL in the prompt.

**Prompt AI:**

```text
$ai-skills-create-game

- Suggested Skills:
  - -
- Title:
  - Enter the Gungeon Clone
- Type:
  - Multiplayer, online cooperative, 2–4 players. All human players cooperate on the same team.
- World and camera:
  - Create one 2D level approximately twice the viewport width and twice its height, giving it about four times the area of one screen.
  - The level may be tile-based or use freely placed artwork and geometry.
  - Use a top-down orthographic camera that smoothly follows the local player and stays within the level boundaries.
- Core loop:
  - Cooperate to survive increasingly difficult enemy waves, dodge bullet patterns, collect loot, and choose weapon upgrades between waves. Defeat a boss every five waves. The run ends when the entire team is down.
- Controls:
  - WASD movement, mouse aiming, left-click shooting, and Space to dodge roll with a short cooldown and brief invulnerability.
- Cooperative mechanics:
  - Create or join a room using a shareable room code, then ready up together.
  - Revive downed teammates, share upgrade rewards, and disable friendly fire.
  - Scale enemy counts and difficulty with the number of active players.
  - Show directional indicators for teammates outside the local camera view.
- Look and feel:
  - Original pixel-art dungeon scenery with stone floors, destructible props, and readable cover.
  - Distinct player colors, expressive enemies, bright projectiles, punchy muzzle flashes, and clear hit feedback.
  - Keep enemy bullets visually distinct from friendly shots. Show player health, teammate status, current wave, remaining enemies, and dodge cooldown.
- Gameplay requirements:
  - Include three starting weapons with distinct firing patterns and meaningful upgrades.
  - Include enemies that chase, fire aimed shots, and emit radial bullet patterns.
  - Provide short breaks between waves for upgrades and a team restart option after defeat.
- Multiplayer server and smoothness:
  - Use https://github.com/SamuelAsherRivello/rmc-colyseus-multiplayer-server or my writable fork: <fork URL, if applicable>.
  - Automatically update the selected server repository with the room logic and synchronized state required by this game.
  - Make the server authoritative for movement validation, combat, enemy spawning, damage, loot, revives, and wave progression.
  - Use supported Colyseus prediction features where available, or implement suitable client-side prediction, server reconciliation, and interpolation.
  - Respond immediately to local movement and dodge inputs. Smooth reconciliation corrections and drive the camera from the predicted local character position to avoid visible jitter.
  - Interpolate remote players and enemies. Use immediate local animations, muzzle flashes, and cosmetic effects while reconciling gameplay outcomes with the server.
  - Use deterministic projectile motion or other bandwidth-efficient synchronization where appropriate.
  - Prioritize a smooth, consistent experience for every player over action density. If synchronization struggles, reduce concurrent bullets, enemies, spawn rates, and firing rates.
  - Handle disconnects and reconnects gracefully.
  - Verify with at least two browser clients, including simulated latency and jitter. Check responsive local movement, stable camera tracking, smooth remote motion, and consistent combat outcomes.
- Inspiration links:
  - https://store.steampowered.com/app/311690/Enter_the_Gungeon/
- Inspiration screenshots:
  - Attach reference screenshots here.
- Originality requirement:
  - Keep the requested project title, but create original artwork, sounds, characters, weapons, UI, and level layouts; use the reference only for gameplay and visual inspiration.
```

#### Single player (3D)

**Prompt AI:**

```text
$ai-skills-create-game

- Suggested Skills:
  - -
Create a single-player, 3D arcade off-road racing game inspired only by the gameplay presentation of Super Off Road. Do not recreate its branded cars, tracks, characters, artwork, sounds, UI, names, or level layouts.

Use these installed 3D Blender skills by name when their work is needed:
- https://github.com/SamuelAsherRivello/ai-skills-blender/

- Title:
  - Dust Circuit Rally
- Type:
  - Single Player
- Camera:
  - Fixed elevated three-quarter perspective, locked to the whole circuit; never follows, rotates with, or zooms toward the player vehicle. Frame the entire drivable course like a classic arcade off-road cabinet game.
- Core loop:
  - Drive laps around compact dirt circuits, steer around hazards and opponents, collect temporary upgrades, finish within a target position, and spend winnings to improve acceleration, handling, and top speed before the next event.
- Look and feel:
  - Chunky, readable low-poly 3D vehicles, barriers, ramps, rocks, and scenery made with original Blender assets; use warm dirt, cool shadows, bright vehicles, and high-contrast pickups.
  - An oblique near-top-down static camera with strong depth cues and every turn visible; add skid, dust, bounce, collision, and jump effects without obscuring the track.
  - Compact original quarry, canyon, and forest-clearing circuits with shortcuts and risk-reward routes; use a large legible HUD and responsive arcade handling with simple AI rivals.
- Technical requirements:
  - Use the named Blender skills to create, light, animate, optimize, and export original game-ready 3D assets.
  - Keep the camera static throughout races and ensure every circuit fits within its view at the intended aspect ratio.
  - Use performance-conscious geometry, materials, lighting, and effects suitable for browser play.
- Inspiration links:
  - https://en.wikipedia.org/wiki/Super_Off_Road
- Inspiration screenshots:
  - Attach reference screenshots here.
- Originality requirement:
  - Create original artwork, sounds, vehicles, track layouts, names, UI, and levels; use the link and screenshots only to study the fixed-camera arcade-racing genre.
```

#### Multiplayer (3D)

You must have write access to [rmc-colyseus-multiplayer-server](https://github.com/SamuelAsherRivello/rmc-colyseus-multiplayer-server) or a fork of it. The command will automatically update that repository with the multiplayer server changes required by your game. If using a fork, provide its URL in the prompt.

**Prompt AI:**

```text
$ai-skills-create-game

- Suggested Skills:
  - -
Create a 3D, online cooperative dungeon crawler inspired only by the top-down arcade action and party adventure of Gauntlet. Do not recreate its branded heroes, enemies, environments, sounds, UI, names, or level layouts.

Use these installed 3D Blender skills by name when their work is needed:
- https://github.com/SamuelAsherRivello/ai-skills-blender/

- Title:
  - Cryptkeep Vanguard
- Type:
  - Multiplayer, online cooperative, 1–4 browser players. All human players cooperate on the same team.
- World and camera:
  - Build one complete, handcrafted 3D dungeon level with a readable top-down, slightly angled perspective. The local camera follows its player smoothly while preserving a useful view of nearby enemies, teammates, objectives, and exits.
  - Create distinct rooms and corridors, including four guarded summoning altars, food pickups, treasure, a key, and a final northern gate.
- Core loop:
  - Work together to destroy the four summoning altars, survive enemy attacks, collect the key, and reach the final gate. The party wins together; the party loses when every active player is down.
- Controls:
  - WASD or arrow-key movement; hold Space to attack with automatic targeting; E for a magic burst with a visible cooldown; 1–4 and four on-screen portrait buttons to switch heroes instantly. Include a touch joystick plus Attack and Magic buttons.
- Cooperative mechanics:
  - Hot join the same public four-seat room from the game URL. Show connecting, connected, full, disconnected, and retry states; a fifth player receives a clear full-room message.
  - Offer Warrior, Valkyrie, Wizard, and Elf-style original hero roles. Allow duplicate selections, and retain a player's health percentage and ability cooldown when switching heroes.
  - Distinguish players who use the same hero with persistent unique colors, player numbers, colored ground rings, in-world labels, and health bars.
  - A local pause stops only that player's controls; it must not pause, restart, or otherwise disrupt the shared world. After victory or party defeat, only the lowest active player number can restart the run.
- Enemies and gameplay requirements:
  - Include four original enemy behaviors: a ghost that chases, a close-range grunt, a demon that shoots, and a lobber that throws visibly telegraphed bombs.
  - Make the altars the enemy-spawning objective. Food heals, treasure adds shared party gold, and the HUD shows local health, teammates, selected hero, objectives, key status, and magic cooldown.
- Look and feel:
  - Create original, stylized low-poly heroes, monsters, dungeon architecture, props, pickups, and UI with Blender assets. Use clear silhouettes, saturated player accents, moody torch-lit stone, and strong contrast for hazards and objectives.
  - Use Babylon Lite with WebGPU and performance-conscious original GLB assets, pooled instances, lighting, particles, and effects suitable for browser play.
- Multiplayer server and smoothness:
  - Use https://github.com/SamuelAsherRivello/rmc-colyseus-multiplayer-server or my writable fork: <fork URL, if applicable>.
  - Automatically update the selected server repository with an isolated game room and synchronized state required by this game.
  - Make the server authoritative for collision, combat, enemies, pickups, objectives, player switching, defeat, victory, and restart.
  - Use client-side prediction, server reconciliation, and interpolation where supported. Local movement, attacks, animations, camera tracking, and cosmetic effects must feel immediately responsive while shared outcomes remain server-authoritative.
  - Handle join, leave, disconnect, retry, room capacity, and a fresh reconnect gracefully. Clearly document that sessions are public and temporary, with no accounts, private room codes, host migration, or persistent progress.
  - Verify with at least two independent browser clients, including simulated latency and jitter. Check responsive local movement, stable camera tracking, smooth remote motion, synchronized enemy combat, hero switching, victory/defeat, restart, full-room handling, and touch controls.
- Inspiration links:
  - https://github.com/SamuelAsherRivello/babylon-lite-gauntlet-clone-3d
  - https://en.wikipedia.org/wiki/Gauntlet_(1985_video_game)
- Inspiration screenshots:
  - Attach reference screenshots here.
- Originality requirement:
  - Create original artwork, sounds, heroes, monsters, dungeon layouts, UI, names, and levels; use the links and screenshots only to study cooperative top-down dungeon-crawler gameplay and visual readability.
```
