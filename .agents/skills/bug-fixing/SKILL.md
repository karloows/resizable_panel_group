---
name: bug-fixing
description: Use when fixing a bug, regression, or incorrect behavior in this Flutter package. Trace the public export, the current widget flow, and the affected resize or accessibility path before editing, then keep the fix small and validate with analyze plus tests.
---

# Bug Fixing

Use this skill for broken panel layout, resize behavior, keyboard handling,
focus treatment, semantics, RTL behavior, or exported API regressions.

## Workflow

1. Read `CLAUDE.md`, `AGENTS.md`, and the relevant policy files first.
2. Trace the flow through `lib/resizable_panel_group.dart`, `PLAN.md`, and the
   affected implementation before choosing an edit point.
3. Check whether the bug is in shared sizing logic, handle interaction, or
   accessibility behavior.
4. Fix the narrowest shared root cause that matches the report.
5. Add or update tests when the change touches non-trivial behavior.
6. Run `flutter analyze` and `flutter test` before handoff.

## Bias

- Prefer one fix in shared layout or interaction logic over patching symptoms in
  multiple places.
- Preserve the smallest usable public API unless the task explicitly requires
  widening it.
- If user-facing behavior changes, note likely release impact in the commit or
  PR body instead of editing version files during normal work.

## Read These

- `CLAUDE.md`
- `.agents/policies/publishing.md`
- `.agents/policies/public-repo.md`
- `.agents/policies/dependency-policy.md`
