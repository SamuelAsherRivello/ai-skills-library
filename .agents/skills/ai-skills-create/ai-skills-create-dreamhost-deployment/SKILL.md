---
name: ai-skills-create-dreamhost-deployment
description: Deploy an approved GitHub Pages or release build to a repository's configured DreamHost production target. Use when repository context provides its Pages and DreamHost deployment setup.
---

# DreamHost deployment from an approved immutable build

Use this skill only when the user explicitly authorizes a production DreamHost deployment. Treat a GitHub release/tag, a GitHub Pages preview, and DreamHost production as distinct outputs; do not silently substitute one for another.

## Version comparison before deployment

Before dispatching a production workflow or otherwise mutating a target, compare the GitHub Pages app release with the app currently rendered by DreamHost. Resolve each application's semantic version and build/commit metadata from its rendered output or documented machine-readable metadata, then corroborate the Pages side with deployment/run evidence when available. Do not infer either installed version solely from a latest successful workflow, and never use the Pages site as a deployable artifact.

Report the comparison first, including each URL, observed version, build/commit metadata, and provenance confidence. Keep version and SHA separate; explicitly identify same-version/different-commit drift and unknown, unavailable, inconsistent, or unverifiable values. After reporting, continue the already-authorized deployment without a redundant approval request. A missing comparison value is information to report, not a reason to silently substitute targets; stop only where it exposes a real required approval, provenance, target-safety, or workflow blocker.

## Establish the approved source

Before dispatching or changing anything, inspect the repository's release, Pages, and DreamHost workflow configuration plus relevant deployment documentation.

- Resolve the approved source to one immutable commit SHA. A configured GitHub Release/tag is useful evidence when present, but is not a universal prerequisite. A verified GitHub Pages deployment may instead identify the source when its deployment/run and rendered build metadata establish the same immutable SHA.
- Determine how the DreamHost workflow obtains content: a build from its checkout, a retained workflow artifact, or another explicit artifact source. Record the artifact/run/SHA provenance.
- Never scrape a published Pages or production site to obtain deployable content. A green CI run is not by itself proof of the intended source or a successful deployment.
- Compare base-path requirements. Pages may be built for a repository subpath while DreamHost is served at a domain root. Reuse a Pages artifact only when its provenance and base-path compatibility are explicit. Otherwise build the exact approved SHA using the target-specific base configuration, without moving or releasing current HEAD.

If there is no verified immutable source, no configured DreamHost target, unclear provenance, or an unknown target path/host/user, stop and report the concrete missing configuration. Do not guess values or replace DreamHost with Pages.

## Use the configured production workflow

Use the repository's existing DreamHost deployment workflow, its declared trigger, and its required confirmation/approval process. Use its supported mechanism to pin the approved SHA: an immutable tag/release ref, a workflow input checked out at that SHA, or a dispatch ref whose resulting run records that SHA. Do not use a moving branch name as a substitute for pinning. If the configured workflow cannot deploy the verified SHA without a moving ref, stop and report that workflow limitation; do not create or edit deployment infrastructure as part of the deployment.

Confirm authentication can read the repository and invoke the workflow. Reuse the workflow's configured secret-backed credentials and host-key controls; never print, copy, export, or ask the user to paste secrets into logs or prompts. If credentials, environment approvals, or protected-environment authorization are unavailable, stop and state which operation is blocked.

Before deployment, confirm the workflow has safeguards appropriate to its configuration: it validates the remote identity and expected webroot, rejects unsafe/symlinked or unknown targets, stages output, and preserves a usable backup or rollback location. Honor its concurrency and approval gates. Do not bypass confirmations, force a deploy, or manually SSH/upload around the workflow unless the user separately authorizes a different operation.

## Verify and report

Monitor the exact deployment run. Verify the configured production URL renders the expected application, including critical assets and representative client-side routes, rather than only checking HTTP status or a successful CI conclusion. Correlate the verified output and workflow checkout/artifact evidence to the approved SHA. If assets fail to load, treat deployment verification as failed and report the observed paths/base-path evidence; do not claim a successful production deployment.

Report separately:

- approved source (release/tag when configured, or verified Pages deployment) and immutable SHA;
- artifact or build provenance and any target-specific rebuild;
- workflow run, approval result, target URL, and verification evidence;
- backup/rollback reference when produced; and
- actionable network, authentication, workflow, approval, target-safety, or rendering blockers.

Authorization for one deployment is not standing permission for future production deployments.
