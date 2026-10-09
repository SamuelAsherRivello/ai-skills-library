# Repository Agent Instructions

## Git Branch Policy

- Prefer committing directly to the repository's default branch, `main`, for
  ordinary requested changes.
- Do not create, switch to, or use a feature branch or worktree unless the user
  explicitly requests a branch, pull request, worktree, or other isolated Git
  workflow.
- If a requested commit or push is scoped to this repository and the checkout
  is already on `main`, keep that branch and commit only the requested files.
- If the checkout is not on `main` and the user did not request a branch, do
  not silently publish there; report the current branch and ask whether to
  continue on it or move the work to `main` safely.
- Preserve unrelated working-tree changes and never include them in a commit.
