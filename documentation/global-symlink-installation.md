# Global Symlink Installation

Use this optional workflow only when you want these skills available globally to Codex. The default installation method is [Manual Copy](../README.md#getting-started), which installs skills only in the chosen repository.

## Ask Your AI

Tell your AI:

> Install this AI Skills Library globally using symlinks. Link only skill folders that do not already exist in my global skills directory. Do not remove, replace, or overwrite any existing global skills.

## Windows Details

The global Codex skills directory is `C:\Users\<your-user>\.agents\skills`. Each skill should be linked individually from this repository's `.agents\skills` directory. Linking individual folders lets existing global skills take priority and leaves them untouched.

On Windows, an AI can use directory junctions, which provide the desired link behavior without requiring administrator privileges in typical configurations. If it uses symbolic links instead, Windows may require Developer Mode or an elevated terminal.

After links are created, restart Codex so it discovers the newly available global skills.

## Safety Rules

- This workflow is opt-in; do not use it unless you explicitly ask your AI to do so.
- Keep the cloned library on disk. The global links depend on it.
- Never replace, delete, or modify an existing global skill to install a library skill.
- To stop using a linked skill later, remove only that link; do not delete the source skill from this library.
