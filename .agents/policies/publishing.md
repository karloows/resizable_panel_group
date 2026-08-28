# Publishing policy

This package is versioned and has a changelog, but no release automation is
documented in this repo yet.

- Do not bump `version` in `pubspec.yaml` or edit `CHANGELOG.md` unless the user
  is explicitly asking for release work.
- For regular fixes and features, note release impact in the commit or PR body
  instead of making ad hoc version bumps.
- Never run `dart pub publish` or `flutter pub publish` unless the user
  explicitly asks for a publish flow.
