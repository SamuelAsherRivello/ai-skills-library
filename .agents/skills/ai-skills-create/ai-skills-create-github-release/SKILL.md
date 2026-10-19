---
name: ai-skills-create-github-release
description: Publish a repository release through its existing GitHub Actions workflow and version.txt source. Use when a user asks to release a versioned GitHub repository.
---

# GitHub Release and configured Pages flow

Use this skill when the user explicitly asks to bump a repository version and publish a GitHub release.

## Readiness checks

Before changing `version.txt`, committing, pushing, or dispatching a workflow:

- Confirm the repository root, GitHub remote, releasable branch, dirty state, current `version.txt`, tags, and releases.
- Inspect `.github/workflows`, release documentation, and `version.txt` to identify the release workflow and its version rule.
- Verify that GitHub authentication can read the repository and has the permissions needed to push the release commit and dispatch the workflow.

If GitHub authentication is missing, expired, or insufficient, stop without changing the repository. Say which operation needs authorization and ask the user to grant or refresh GitHub access, then resume only after access is available.

If the repository lacks a release workflow or `version.txt`, do not create release infrastructure in this task. Inspect the accessible `github-repository-template` checkout for its `.github/workflows/release.yml` and `version.txt` pattern, report the missing pieces, and offer to set up an equivalent GitHub release workflow in a separate user-authorized change.

## Version comparison before release

Before any commit, push, tag, release, or workflow dispatch, compare the app version at the authoritative remote releasable-branch HEAD with the version actually deployed on GitHub Pages. Resolve application version and build/commit metadata from repository configuration and the rendered Pages application or its documented machine-readable metadata. Do not treat the latest successful Pages workflow as proof of the version installed there.

Report the two versions and their provenance first: source ref/SHA and version source for remote HEAD; Pages URL, observed application version/build metadata, and the deployment/run evidence that establishes its SHA when available. Keep semantic version and commit SHA distinct. Call out a same-version/different-commit result, as well as missing, stale, conflicting, or unverifiable values. Then continue the already-authorized release operation without asking again solely because the comparison was reported; stop only for a real authorization gap, required gate, or existing workflow/safety blocker.

## Release workflow

1. Fetch the authoritative remote branch and confirm the intended release commit is present there. Do not release a local-only, divergent, or stale commit.
2. Derive the next version from the repository's documented rule; never assume a patch bump. Update `version.txt` and run the documented validation when practical.
3. Commit and push only the version-source change through the repository's normal workflow, preserving unrelated user changes.
4. Confirm the target version has no existing tag or release, then dispatch the existing release workflow by its documented mechanism.
5. Monitor the run and verify the resulting tag, release, target commit, and version source. Report exact URLs or identifiers.

## GitHub Pages follow-through

A GitHub Release does not itself deploy GitHub Pages. Before releasing, inspect the checked-in Pages workflow and determine which of its existing triggers, if any, is intended to publish the approved release revision. Do not add, alter, or assume a Pages workflow as part of a release task.

- Record the immutable release SHA after the release workflow finishes; verify the tag and GitHub Release both resolve to it.
- If the Pages workflow is triggered by the release commit being pushed to the configured branch, verify that the approved SHA was pushed to that branch and identify the resulting Pages run. Do not infer that a tag or Release event triggers it.
- If the workflow has a release/tag trigger, identify and monitor the run created for the release event, confirming its checkout/ref resolves to the release SHA.
- If it supports `workflow_dispatch`, dispatch the existing Pages workflow only when the user has authorized the release task to trigger the configured publishing flow. Select the immutable release tag or another workflow-supported ref that resolves to the release SHA; do not dispatch a moving branch ref merely because it is currently at that SHA.
- If no configured trigger can deploy that SHA, or the trigger/ref semantics are unclear, stop after reporting the GitHub Release state and explain the Pages blocker. Offer a separate, authorized workflow change rather than claiming Pages was published.

For a Pages run that exists, monitor it and verify its outcome, deployment URL, and (where workflow evidence permits) checkout/build provenance against the recorded release SHA. Report the GitHub Release and Pages deployment as separate results.

## Safety

- Treat a workflow dispatch, local commit, remote push, tag, release, and Pages deployment as separate states; verify each before reporting success.
- Never force-push, rewrite history, create a duplicate release, or overwrite unrelated changes.
- Stop at the smallest concrete blocker when remote state, access, or workflow behavior is ambiguous.
