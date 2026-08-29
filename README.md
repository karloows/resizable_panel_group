# resizable_panel_group

Accessible resizable panel groups for Flutter.

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
flutter run
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
