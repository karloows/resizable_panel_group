# Agent Instructions

`resizable_panel_group` — a Flutter package for accessible resizable panel
groups. Source is hosted on a public GitHub repo.

Commands and architecture live in [CLAUDE.md](CLAUDE.md) — read that first.

Policies (read all, they're short):
[.agents/policies/publishing.md](.agents/policies/publishing.md),
[.agents/policies/public-repo.md](.agents/policies/public-repo.md),
[.agents/policies/commit-policy.md](.agents/policies/commit-policy.md),
[.agents/policies/branch-policy.md](.agents/policies/branch-policy.md),
[.agents/policies/pr-policy.md](.agents/policies/pr-policy.md),
[.agents/policies/dependency-policy.md](.agents/policies/dependency-policy.md)

Repo-local skills:

- Shared: [.agents/skills/package-workflow/SKILL.md](.agents/skills/package-workflow/SKILL.md)
- Claude: [.claude/skills/package-workflow/SKILL.md](.claude/skills/package-workflow/SKILL.md)

## Public repo — read before editing

- This repo is public. Never commit secrets, tokens, or personal data. Assume
  every commit and PR is visible to anyone.
- The package is still at scaffold stage (`0.0.1`) and the public widget API is
  not implemented yet. Even so, keep the package entrypoint and any documented
  usage in `README.md` aligned with code changes.
- Do not edit `CHANGELOG.md` or bump `version` in `pubspec.yaml` during normal
  fix, feat, refactor, docs, or test work. `release-please` owns changelog and
  version updates through the release PR flow.
- If you add or change a user-facing API, update `README.md` in the same change.
- Keep `PLAN.md` aligned with the intended product shape when major direction
  changes happen.

## Git conventions

- Don't commit or push directly to `main` unless explicitly asked — see
  [.agents/policies/branch-policy.md](.agents/policies/branch-policy.md) for
  branch naming.
- Commit messages follow
  [.agents/policies/commit-policy.md](.agents/policies/commit-policy.md) —
  conventional commits with a required body.
- `ship` means: if the current branch is `main`, create and check out a new
  branch that follows branch policy; otherwise keep the current feature branch.
  Then commit the work, push the branch, and open a PR without asking for extra
  confirmation.
- `land` means: squash-merge the PR, switch the local checkout back to `main`,
  pull the merged changes, and delete the local branch.

## Conventions

- This repo uses FVM and pins Flutter `3.47.0` in `.fvmrc`. Prefer
  `fvm flutter ...` for package and example commands.
- Release automation uses `release-please` in
  `.github/workflows/release-please.yml` plus pub.dev publishing in
  `.github/workflows/publish.yml`. Release tags use `v{{version}}`, and the
  first pub.dev release must still be manual.
- Lints: `flutter_lints` via `analysis_options.yaml` — keep it passing, don't
  add ignores without reason.
- Follow the product brief in `PLAN.md`: keep the package small, Flutter-native,
  and accessibility-first.
- Prefer widget-based layout first (`LayoutBuilder`, `Row`, `Column`, gesture,
  focus, semantics). Do not jump to a custom render object without a concrete
  reason.
- Every non-trivial layout or resize rule needs a widget test.
