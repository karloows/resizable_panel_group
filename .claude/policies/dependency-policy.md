# Dependency policy

This package should stay lean.

- Don't add a new `dependencies:` entry for something solvable with Flutter,
  Dart stdlib, or a few lines of code.
- `dev_dependencies:` are freer, but still justify additions.
- Avoid git or path dependencies in published package work unless the user is
  explicitly doing local-only experimentation.
