@AGENTS.md

# CLAUDE.md

This file provides guidance to coding agents working in this repository.

Process and policy conventions live in [AGENTS.md](AGENTS.md) — read that too.

Repo-local skills live here:

- Shared: `.agents/skills/package-workflow/SKILL.md`
- Claude: `.claude/skills/package-workflow/SKILL.md`

## Commands

```sh
fvm flutter pub get
fvm flutter analyze
fvm flutter test
fvm flutter test test/resizable_panel_group_test.dart
dart format .
```

This repo now has `release-please` in `.github/workflows/release-please.yml`
and tag-based pub.dev publishing in `.github/workflows/publish.yml`, but you
should still run checks yourself before considering a change done.

Do not edit `CHANGELOG.md` or bump `version` in `pubspec.yaml` during normal
development work. Those changes belong only in the `release-please` release PR
or explicit release work the user asked for.

## Architecture

Read [PLAN.md](PLAN.md) before implementing package features. It is the project
brief and defines the intended v1 scope.

Current codebase shape:

- `lib/resizable_panel_group.dart` is the whole public entrypoint today. It
  exports only a placeholder `packageName` constant while the widget API is
  still being built.
- `test/resizable_panel_group_test.dart` is a scaffold smoke test proving the
  package entrypoint exports successfully.
- `README.md` intentionally stays short until the public widget API exists.
- `PLAN.md` is the source of truth for the intended public API:
  `ResizablePanelGroup`, `ResizablePanel`, and `ResizableHandleDetails`.

When implementing the real widget API, keep the first version simple:

- Start with normal widgets and state, not a render object.
- Expect `LayoutBuilder` plus `Row`/`Column` to be the first implementation.
- Accessibility is core scope: keyboard interaction, focus treatment, and
  semantics belong in the first real version, not as follow-up polish.
- Keep helpers private until app users clearly need them exported.
