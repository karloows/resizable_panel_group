# resizable_panel_group

Accessible resizable panel groups for Flutter.

## Tooling

This repo uses FVM and pins Flutter `3.47.0`.

```sh
fvm install
fvm flutter pub get
```

## Features

- Horizontal and vertical panel groups
- Drag resizing for mouse and touch
- Keyboard-accessible resize handles
- Screen reader resize semantics

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:resizable_panel_group/resizable_panel_group.dart';

ResizablePanelGroup(
  direction: Axis.horizontal,
  children: const [
    ResizablePanel(
      minSize: 160,
      initialSize: 240,
      child: ColoredBox(color: Colors.red),
    ),
    ResizablePanel(
      minSize: 240,
      child: ColoredBox(color: Colors.blue),
    ),
  ],
)
```

## Example

The repo includes a runnable Flutter example in [`example/`](example/).

```sh
cd example
fvm flutter run
```

It demonstrates:

- a landscape split-view example
- a portrait split-view example
- a nested vertical panel group
- a custom handle

The example switches automatically by width, so you do not need to manually
rotate an emulator or phone to find an interactive layout.

## Accessibility

Handles can be focused and resized with the keyboard. Horizontal keyboard
behavior respects text direction.

## Release

This repo is set up for `release-please` plus automated pub.dev publishing.

1. Add a GitHub Actions secret named `RELEASE_PLEASE_TOKEN` with a token that
   can open PRs and create tags/releases.
2. Publish the first package version manually from a trusted local machine.
3. In `pub.dev/packages/resizable_panel_group/admin`, enable automated
   publishing from GitHub Actions for this GitHub repository with the tag
   pattern `v{{version}}`.
4. Merge conventional-commit changes to `main`. `release-please` will open or
   update a release PR with the next `pubspec.yaml` version and changelog.
5. Merge that release PR. `release-please` will create the GitHub release and
   matching `v<version>` tag, which triggers pub.dev publishing.

Workflows and config live in:

- [`.github/workflows/release-please.yml`](.github/workflows/release-please.yml)
- [`.github/workflows/publish.yml`](.github/workflows/publish.yml)
- [`release-please-config.json`](release-please-config.json)
- [`.release-please-manifest.json`](.release-please-manifest.json)
