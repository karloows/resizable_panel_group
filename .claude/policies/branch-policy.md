# Branch policy

- Don't commit directly on `main` unless the user explicitly asks for that
  exception.
- Branch names: `<type>/<short-kebab-description>`, for example
  `feat/basic-group` or `fix/handle-focus`.
- Allowed types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`,
  `build`, `ci`.
- Keep the description to 2-3 words max, based on the real diff.
- When the user says `ship`, create and check out a new branch that follows
  this naming policy only if the current branch is `main`; otherwise keep the
  current feature branch before committing.
- After a PR is merged: switch back to `main`, pull the merged changes, and
  delete the local and remote feature branch.
