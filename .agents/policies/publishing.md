# Publishing policy

This package is versioned, has a changelog, and now includes `release-please`
plus GitHub Actions automation for tag-based publishing to pub.dev.

- Do not bump `version` in `pubspec.yaml` or edit `CHANGELOG.md` unless the user
  is explicitly asking for release work.
- `release-please` owns routine version and changelog bumps through release PRs.
  Do not hand-edit those files during normal feature work.
- This applies to all agent-authored routine changes in this repo: fixes,
  features, refactors, docs, tests, and tooling updates should leave
  `CHANGELOG.md` and `pubspec.yaml` version untouched.
- The first release must still be published manually. pub.dev only allows
  automated publishing for versions after the package already exists.
- `release-please` requires a GitHub secret token named `RELEASE_PLEASE_TOKEN`
  so its release tags can trigger the publish workflow.
- Automated releases use the Git tag pattern `v{{version}}`, so the pushed tag
  must match the `version` in `pubspec.yaml`.
- For regular fixes and features, note release impact in the commit or PR body
  instead of making ad hoc version bumps.
- Never run `dart pub publish` or `flutter pub publish` unless the user
  explicitly asks for a publish flow.
