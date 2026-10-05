---
name: tiled-ai-setup
description: Set up and verify the rpgjs Tiled AI MCP bridge for a local Tiled editor. Use when the bridge, extension, Codex MCP entry, or live editor connection is missing or needs an end-to-end check.
---

# Tiled AI Setup

Prepare the local `rpgjs/tiled-ai` bridge and prove that an open Tiled editor
is reachable from the `tiled-ai` MCP. A setup passes only when every check
below passes. Stop at the first failed check, identify it, and give the
smallest corrective action; do not call a partial setup successful.

## 1. Check the local prerequisites

1. Confirm Node.js is available and Tiled is installed.
2. Locate the cloned `rpgjs/tiled-ai` checkout. If it is absent, ask before
   cloning the public repository and installing its dependencies.
3. In that checkout, run `npm ci`, `npm run build`, then
   `node dist/cli.mjs init` and `node dist/cli.mjs doctor`. Stop on a build or
   doctor failure and report its diagnostics.

## 2. Install the extension and register the MCP

1. Install the extension with
   `node dist/cli.mjs install --extensions <Tiled extensions directory>`.
   On Windows the usual directory is `%LOCALAPPDATA%\Tiled\extensions`; prefer
   Tiled's Preferences path if it differs.
2. Register a global Codex MCP named `tiled-ai` that runs
   `node <bridge checkout>/dist/cli.mjs serve`, then verify the registration
   with `codex mcp get tiled-ai`.
3. Start or reuse the shared bridge with `node dist/cli.mjs bridge-start`.

Do not overwrite an existing MCP entry, configuration, or extension without
showing the conflict and obtaining authorization.

## 3. Connect Tiled manually

1. Restart Tiled if the extension was just installed.
2. Open any map in Tiled.
3. Choose **Map → Tiled AI: Connect**. This action may be silent; use
   **Map → Tiled AI: Status** to confirm the connection.

If the menu entry is missing, the extension is not loaded: recheck the
extensions directory, restart Tiled, and inspect the Tiled extension console.
If Status does not report a connection, re-run `doctor`, start the bridge, and
connect again before proceeding.

## 4. Prove the live MCP session

Call `get_editor_state` through the `tiled-ai` MCP. Pass only when it returns
a session ID and the map opened in Tiled appears in its documents. Do not make
a map edit merely to test connectivity. Report the active document and tell the
user that `$tiled-ai-add-sample-level` is the next end-to-end authoring test.

## Result format

List each check as pass or fail. On failure, report the exact missing item, the
command or manual Tiled action that fixes it, and the point at which to resume.
