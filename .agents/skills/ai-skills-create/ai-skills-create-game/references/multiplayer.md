# Multiplayer workflow

Read before planning requested multiplayer. Common template, renderer, browser-testing, and delivery requirements still apply.

## Contract and required hosting

Use [the shared Colyseus server](https://github.com/SamuelAsherRivello/rmc-colyseus-multiplayer-server). Reuse a suitable checkout, preserving unrelated work. The mandatory intake/access gate must confirm GitHub write access to the selected server repository and Vercel access to its project and required credentials before server or client implementation. Inspect its current default branch, `AGENTS.md`, README, `multiplayer-server/documentation/games.md`, `multiplayer-server/packages/client/README.md`, source, tests, and release/deployment workflows. Discover paths again if the layout changes.

Vercel's existing free Hobby account is a fixed constraint. Use its current configuration and documented limits, including the 300-second function limit where configured. Do not suggest alternative hosts, upgrades, third-party services, or mandatory Redis. Do not introduce a shared-state migration merely to create a game. Inspect credential availability and deployment identifiers without displaying secret values; automate routine setup with trusted credentials. If access is missing, report the exact credential or permission needed. If functionality cannot fit the free plan, explain that specific limitation without recommending another provider or plan.

Define game identifier, capacity, authority, state/actions, join/leave, pause, completion, and restart. Reuse shared client lifecycle features and document game-specific recovery semantics. In-memory rooms may end on function expiry, deployment, or routing to another instance. Reconnect does not guarantee room or state continuity. Design bounded play and visible retry/room recreation within these limits; no silent offline replacement or duplicate room creation during failed joins.

## Extend and verify before the client

1. Track server work through its OpenSpec workflow when applicable. Register the game, isolate its rooms/state, validate actions, bounds and ownership, and preserve existing protocols. Put reusable lifecycle additions in the shared client.
2. Update registry, feature catalog, demo lists, and client documentation. Test two-client synchronization, late join, capacity, departure, supported recovery, isolation, game rules, and affected existing consumers. Run documented checks and client packaging.
3. Inspect and use the actual release workflow. Stage the intended revision before changing the stable endpoint; verify exact version, game-specific two-client WebSocket actions, affected consumer regressions, and the repository's sustained-session probe. For the current bounded hosting contract, run its 240-second probe below the configured 300-second limit. Health checks alone do not prove multiplayer works.
4. Exercise connection loss and room expiration, checking visible recovery without falsely promising cross-instance persistence. Test authority transfer only where the game supports it. Simulated expiry tests and a 240-second probe do not establish continuity past function expiry.
5. Promote the verified deployment and recheck stable endpoint version and shared actions. On failure, follow documented rollback and stop publication. Publish the compatible client tarball/tag/release only after required checks pass, preserving established artifact names. Do not repeatedly publish versions to retry a failed deployment.

## Client and delivery

Record verified server release, exact client tarball/version, endpoint, revision, and probe evidence. Synchronize release-generated server commits without discarding changes. Then create the public game repository from the shared template, install the exact released shared client, and commit its lockfile. Discover compatible SDK versions rather than copying stale examples. Publish the game to GitHub Pages and verify both the public game and Vercel backend together; neither deployment alone completes multiplayer delivery.

Author server extensions, shared client/rules, tests, probes, and executable JavaScript tools in strict TypeScript under the owning repository's full compiler coverage. Verify the exact released tarball contains compiled browser-safe JavaScript and generated declarations for every public export used by the game. Compile a clean typed consumer against that artifact and check useful valid/invalid calls; source-checkout types do not prove the release is typed. If a legacy artifact lacks declarations, complete compatible upstream typing/release work in the server-first workflow or report its blocker. Never add blanket local module stubs or weaken strictness to bypass it. Preserve existing JavaScript consumers, public imports, protocols, and tarball names.

Configure the verified secure backend URL for production and document local overrides in `.env.example`. Keep credentials out of browser code. Show connecting, connected, full, disconnected, expired-room, and retry/error states as applicable. A local pause must neutralize input without pausing or resetting everyone.

Play a full loop with two independent headless or minimized browser sessions. Cover shared actions, late join, leave/reconnect, completion/replay, and desktop/mobile controls. Repeat the two-client smoke test against the released public game and backend. Add reusable game-specific probes to deployment verification where needed.

Document player limits, hosting duration and state-loss behavior, controls, recovery, and pinned releases. Complete the common delivery workflow and report game/server repositories, releases, local paths, and verification separately if either is blocked.
