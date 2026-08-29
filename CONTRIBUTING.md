# Contributing

Thanks for considering a contribution to `resizable_panel_group`.

## Before you start

Read [AGENTS.md](AGENTS.md), [CLAUDE.md](CLAUDE.md), and [PLAN.md](PLAN.md).
They define the repo workflow, package constraints, and intended product shape.

## Setup

```sh
fvm install
fvm flutter pub get
cd example && fvm flutter pub get
```

## Before opening a PR

These should all pass before you open a pull request:

```sh
fvm flutter analyze
fvm flutter test
dart format .
```

## Project shape

- Keep the package small, Flutter-native, and accessibility-first.
- Prefer widget-based layout before custom render objects.
- Keep the public API aligned with [README.md](README.md).
- Keep major product-direction changes aligned with [PLAN.md](PLAN.md).
- Add or update a widget test for every non-trivial layout or resize rule.

## Public API changes

This package is public, but still at scaffold stage.

- If you add or change a user-facing API, update [README.md](README.md) in the
  same change.
- Do not edit `CHANGELOG.md` or bump `version` in `pubspec.yaml` during normal
  feature, fix, refactor, docs, or test work. `release-please` owns those in
  the release PR flow.

## Git and pull requests

- Branch names use `<type>/<short-kebab-description>`, such as
  `feat/basic-group` or `fix/handle-focus`.
- Commit messages use conventional commits:
  `<type>(<scope>): <summary>`.
- Every commit needs a short body explaining why.
- PR titles use the same format as commits.
- PR descriptions should explain what changed, why, and the likely release
  impact when behavior or the planned public API changed.

## Reporting bugs and requesting features

Use the GitHub templates when possible:

- [Bug report](.github/ISSUE_TEMPLATE/bug_report.md)
- [Feature request](.github/ISSUE_TEMPLATE/feature_request.md)
