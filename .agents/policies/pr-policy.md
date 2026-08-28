# Pull request policy

Public repo — PR title and description are visible to anyone and become part of
the permanent history.

- Title: same format as commits, `<type>(<scope>): <summary>`.
- Keep the PR title if it still matches the branch diff. Update it only when the
  real scope changes.
- Description: what changed and why, plus release impact when user-facing
  behavior or the planned public API changed.
- When the user says `ship`, push the branch and open the PR as part of that
  workflow.
- When the user says `land`, squash-merge the PR rather than creating a merge
  commit, then finish the local cleanup steps from `branch-policy.md`.
