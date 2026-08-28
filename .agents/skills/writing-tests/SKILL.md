---
name: writing-tests
description: Use when adding or updating tests for this package. Prefer behavior-level coverage for panel sizing, resizing, keyboard interaction, and semantics, and keep tests aligned with the public API.
---

# Writing Tests

Use this skill when the task is to add, update, or repair tests.

## Test Rules

- Prefer behavior-level tests over private implementation checks.
- Cover the real risk: layout constraints, resize interactions, callbacks,
  focus, keyboard behavior, RTL behavior, and semantics.
- When a shared path is changed, consider whether both horizontal and vertical
  groups need coverage.
- Keep tests close to the package behavior they protect.
- Avoid test-only seams that worsen the public package design.

## Validation Flow

1. Run focused `flutter test` commands while iterating when useful.
2. Finish with `flutter analyze`.
3. Finish with `flutter test`.

## Read These

- `CLAUDE.md`
- `.agents/policies/publishing.md`
- `.agents/policies/public-repo.md`
