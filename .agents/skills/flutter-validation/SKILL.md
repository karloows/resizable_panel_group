---
name: flutter-validation
description: Use when validating code changes in this package. Run the smallest honest checks while iterating, then finish with flutter analyze and flutter test before handoff.
---

# Flutter Validation

Use this skill when package or test code changed.

## Validation Flow

1. Use the smallest check that proves the edited area while iterating.
2. Finish with `fvm flutter analyze`.
3. Finish with `fvm flutter test`.
4. If public API or documented behavior changed, review `README.md`,
   `CHANGELOG.md`, and `PLAN.md` for consistency.
5. Report exactly what ran and what did not.

## Notes

- This repo does not document CI or release automation yet.
- If a change touches only non-Dart, non-Markdown repo files, document review
  may be enough.

## Read These

- `CLAUDE.md`
- `.agents/policies/publishing.md`
- `.agents/policies/public-repo.md`
