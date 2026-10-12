---
name: ai-skills-create-github-release
description: Publish a repository release through its existing GitHub Actions workflow and version.txt source. Use when a user asks to release a versioned GitHub repository.
---

# GitHub Release

Use this skill when the user explicitly asks to bump a repository version and publish a GitHub release.

## Readiness checks

Before changing `version.txt`, committing, pushing, or dispatching a workflow:

- Confirm the repository root, GitHub remote, releasable branch, dirty state, current `version.txt`, tags, and releases.
- Inspect `.github/workflows`, release documentation, and `version.txt` to identify the release workflow and its version rule.
- Verify that GitHub authentication can read the repository and has the permissions needed to push the release commit and dispatch the workflow.

If GitHub authentication is missing, expired, or insufficient, stop without changing the repository. Say which operation needs authorization and ask the user to grant or refresh GitHub access, then resume only after access is available.

If the repository lacks a release workflow or `version.txt`, do not create release infrastructure in this task. Inspect the accessible `github-repository-template` checkout for its `.github/workflows/release.yml` and `version.txt` pattern, report the missing pieces, and offer to set up an equivalent GitHub release workflow in a separate user-authorized change.

## Release workflow

1. Fetch the authoritative remote branch and confirm the intended release commit is present there. Do not release a local-only, divergent, or stale commit.
2. Derive the next version from the repository's documented rule; never assume a patch bump. Update `version.txt` and run the documented validation when practical.
3. Commit and push only the version-source change through the repository's normal workflow, preserving unrelated user changes.
4. Confirm the target version has no existing tag or release, then dispatch the existing release workflow by its documented mechanism.
5. Monitor the run and verify the resulting tag, release, target commit, and version source. Report exact URLs or identifiers.

## Safety

- Treat a workflow dispatch, local commit, remote push, tag, and release as separate states; verify each before reporting success.
- Never force-push, rewrite history, create a duplicate release, or overwrite unrelated changes.
- Stop at the smallest concrete blocker when remote state, access, or workflow behavior is ambiguous.
