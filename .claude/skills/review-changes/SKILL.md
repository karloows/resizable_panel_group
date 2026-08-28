---
name: review-changes
description: Use when reviewing code or docs changes in this package. Prioritize regressions, public API compatibility, release-note gaps, and missing validation before handoff.
---

# Review Changes

Use this skill for self-review, requested review, or pre-handoff checking.

## Review Order

1. Regressions in panel sizing, drag behavior, keyboard resizing, focus, or
   semantics.
2. Public API changes in `lib/resizable_panel_group.dart` or other exported
   package behavior.
3. Missing release-impact notes or changelog work when the task explicitly
   included release updates.
4. README or `PLAN.md` drift after public API or behavior changes.
5. Validation gaps or unnecessary dependency additions.
6. Public-repo hygiene issues such as secrets or personal data.

## Output Rules

- Findings first.
- Tie each finding to a file or behavior.
- If no findings remain, say so directly and still mention any real validation
  gap.

## Read These

- `.claude/policies/publishing.md`
- `.claude/policies/public-repo.md`
- `.claude/policies/dependency-policy.md`
