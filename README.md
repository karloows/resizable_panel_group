# resizable_panel_group

Accessible resizable panel groups for Flutter.

## Features

- Horizontal and vertical panel groups
- Drag resizing for mouse and touch
- Keyboard-accessible resize handles
- Screen reader resize semantics

## Usage

```dart
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

## Accessibility

Handles can be focused and resized with the keyboard. Horizontal keyboard
behavior respects text direction.
