---
name: package-workflow
description: Repo-local workflow guidance for building `resizable_panel_group`.
---

# Package Workflow

Use this skill when working on the `resizable_panel_group` package.

## Read first

1. `AGENTS.md`
2. `CLAUDE.md`
3. `PLAN.md`

## What this repo is

- A public Flutter package scaffold for accessible resizable panel groups.
- Current version is `0.0.1`.
- The public widget API is not implemented yet.

## Build rules

- Keep v1 small: `ResizablePanelGroup`, `ResizablePanel`,
  `ResizableHandleDetails`.
- Prefer widget-based layout before render objects.
- Accessibility is in scope from the start: focus, keyboard resizing,
  semantics, and RTL-aware behavior.
- Avoid new dependencies unless Flutter cannot reasonably cover the need.
- Add or update widget tests for non-trivial layout or resize behavior.

## Checks

Run:

```sh
fvm flutter analyze
fvm flutter test
```
