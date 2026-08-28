---
name: task-planning
description: Use when package work has multiple moving parts and benefits from a short plan. Inspect the real package entrypoint, product brief, and public surface first, then keep the plan concrete and small.
---

# Task Planning

Use this skill for non-trivial package work that benefits from a short
execution plan.

## Planning Rules

1. Read `CLAUDE.md`, `AGENTS.md`, and the relevant policies before planning.
2. Plan around the real package flow: public export in
   `lib/resizable_panel_group.dart`, the current implementation files, and
   `PLAN.md`.
3. Keep the plan to a few concrete steps tied to files or behaviors.
4. Include validation when code behavior changes.
5. Include release, README, or product-brief updates only when the public
   package surface actually changed.

## Good Plan Shape

- inspect the current flow
- edit the smallest responsible files
- add or adjust focused tests if needed
- run analyze and test
- review docs and release follow-through before handoff
