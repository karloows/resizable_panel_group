---
name: git-workflow
description: Use when branch, commit, push, PR, merge, or branch-cleanup workflow is part of the task. Follow this public package repo's branch, commit, PR, merge, and publishing constraints without pushing directly to main.
---

# Git Workflow

Use this skill when the task includes creating a branch, committing, pushing,
opening a PR, merging a PR, or cleaning up a branch after merge.

## Branches

- Use `<type>/<short-kebab-description>`.
- Keep the description to two or three words.
- Base the name on the actual diff, not the ticket title.
- Do not commit or push directly to `main` unless the user explicitly asks.

## Commits

- Use `<type>(<scope>): <summary>`.
- Use the narrowest real scope such as `api`, `layout`, `a11y`, `tests`,
  `docs`, or `deps`.
- Include a short body explaining why.
- Mention likely release impact when user-facing behavior changed.

## Pull Requests

- Use the same title format as commits.
- Keep the existing PR title when it still explains the whole branch. Update it
  only when the branch scope changed enough that the current title no longer
  fits.
- Keep the PR description short and public-safe.
- Call out breaking changes explicitly.

## Trigger words

When the user says **"ship"**, run without asking for confirmation:
0. Check `git branch --show-current` first. If it's `main`, create and switch
   to the feature branch before touching `git add` or `git commit`.
1. If the current branch is `main`, run
   `git checkout -b <type>/<short-kebab-description>`. Otherwise, continue on
   the current branch and do not create a nested branch.
2. Commit relevant changes per the Commits section above.
3. Push the branch.
4. Open a PR using the repo's available GitHub tooling.
5. Report the exact branch name, PR base, PR title, and PR URL after the ship
   flow is complete.

When the user says **"land"**, run without asking for confirmation:
1. Show the exact PR number, title, head, and base, then ask for confirmation
   before squash-merging.
2. Squash-merge the open PR using the repo's available GitHub tooling.
3. Check out `main`.
4. `git pull` to bring the merge down locally.
5. Show the exact local and remote branch names, then ask for confirmation
   before deleting them.
6. Delete the feature branch, both local and remote.

## Read These

- `.claude/policies/branch-policy.md`
- `.claude/policies/commit-policy.md`
- `.claude/policies/pr-policy.md`
- `.claude/policies/public-repo.md`
- `.claude/policies/publishing.md`
