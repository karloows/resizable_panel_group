# Commit policy

- Format: `<type>(<scope>): <summary>` (conventional commits).
- Scope = the narrowest area the diff actually touches. Good fits here include
  `api`, `layout`, `a11y`, `tests`, `docs`, `deps`, `dev`.
- Every commit needs a body: 1-2 short lines on why.
- If the change affects user-facing behavior or the planned public API, note the
  likely semver impact in the body, but do not bump `version` or edit
  `CHANGELOG.md` unless doing release work.
