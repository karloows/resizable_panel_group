# resizable_panel_group Plan

This document is the project brief for future sessions.

Read it before implementing package features. Keep the package small, focused,
and accessibility-first.

## One-Sentence Product

`resizable_panel_group` provides accessible resizable panel groups for Flutter.

## Positioning

The package is for app layouts that need panes users can resize:

- Sidebars
- Inspectors
- Split editors
- Preview panes
- Settings panels
- Dashboards
- Nested content regions

The niche is not "all resizable things." The niche is accessible, composable
panel groups with a small Flutter-native API.

## Mindset For Future Sessions

- Prefer the smallest API that solves real layout resizing.
- Do not add dependencies unless Flutter cannot reasonably do the job.
- Build with normal widgets first.
- Use a custom render object only if widget-based layout becomes impossible or visibly wrong.
- Accessibility is core scope, not polish.
- Keep examples realistic but small.
- Keep README short until the API is implemented.
- Do not build IDE features in v1.
- Do not create abstractions for future features.
- Every non-trivial layout rule needs a widget test.

## Core Promise

v1 should make this easy:

```dart
ResizablePanelGroup(
  direction: Axis.horizontal,
  children: [
    ResizablePanel(
      minSize: 160,
      initialSize: 240,
      child: Sidebar(),
    ),
    ResizablePanel(
      minSize: 320,
      child: Editor(),
    ),
  ],
)
```

Users should get:

- Mouse and touch drag resizing
- Keyboard resizing
- Screen reader semantics
- Horizontal and vertical groups
- Nested groups
- Min, max, and initial sizes
- A usable default handle
- A way to fully customize handles

## Non-Goals For v1

Do not build these unless the project owner explicitly asks:

- Docking
- Tabs
- Drag-to-reorder panels
- Floating windows
- Window management
- Persisted layout storage
- Multi-window desktop behavior
- Animated layout engine
- Theme extension system
- Controller class
- Breakpoint system
- Grid layout

These can be future packages or future versions after the core API proves
itself.

## Public API Target

Start with three public concepts:

- `ResizablePanelGroup`
- `ResizablePanel`
- `ResizableHandleDetails`

Avoid exposing internal sizing helpers in v1. If tests need helpers, keep them
private until app users need them.

### `ResizablePanelGroup`

Likely constructor:

```dart
const ResizablePanelGroup({
  super.key,
  required this.direction,
  required this.children,
  this.handleExtent = 12,
  this.keyboardResizeAmount = 16,
  this.largeKeyboardResizeAmount = 64,
  this.handleBuilder,
  this.onSizesChanged,
});
```

Likely fields:

- `Axis direction`
- `List<ResizablePanel> children`
- `double handleExtent`
- `double keyboardResizeAmount`
- `double largeKeyboardResizeAmount`
- `Widget Function(BuildContext, ResizableHandleDetails)? handleBuilder`
- `ValueChanged<List<double>>? onSizesChanged`

Validation:

- Require at least one panel.
- Reject negative `handleExtent`.
- Reject negative keyboard resize amounts.
- Reject panels where `minSize > maxSize`.

### `ResizablePanel`

Likely constructor:

```dart
const ResizablePanel({
  super.key,
  required this.child,
  this.minSize = 0,
  this.maxSize,
  this.initialSize,
});
```

Likely fields:

- `Widget child`
- `double minSize`
- `double? maxSize`
- `double? initialSize`

Do not add `collapsible` in the first implementation unless it naturally falls
out of `minSize: 0`. Explicit collapse behavior can wait.

### `ResizableHandleDetails`

Likely fields:

- `Axis direction`
- `int leadingPanelIndex`
- `bool isDragging`

Add more only when a custom handle example needs it.

## Layout Model

Use logical pixels for sizes.

Each group owns only its direct children. Nested groups should work because a
panel child can contain another `ResizablePanelGroup`.

Rules:

- The active axis is horizontal for `Axis.horizontal`.
- The active axis is vertical for `Axis.vertical`.
- A handle sits between each pair of panels.
- Handle count is `children.length - 1`.
- Total panel space is container size minus total handle extent.
- Panels with `initialSize` try to take that size first.
- Panels without `initialSize` share remaining space equally.
- If initial sizes exceed available space, clamp within min and max constraints.
- If constraints cannot all be satisfied, prefer a stable layout over throwing after build.
- Dragging handle `i` transfers size between panel `i` and panel `i + 1`.
- Dragging stops when either neighboring panel reaches min or max.
- Resizing never changes non-adjacent panels directly.

Implementation hint:

- Keep sizes in a `StatefulWidget`.
- Use `LayoutBuilder` to know available size.
- Use `Row` or `Column` plus fixed-size wrappers.
- Use `GestureDetector` for drag.
- Use `Focus`, `Shortcuts`, `Actions`, or `KeyboardListener` only as needed.

Do not start with `CustomMultiChildLayout` or `RenderBox`. Reach for those only
after a simple widget implementation fails a concrete requirement.

## Accessibility Requirements

The package promise depends on this section.

Handles must:

- Be keyboard focusable.
- Have a visible focus state.
- Expose semantics as an adjustable control where Flutter supports it.
- Expose a useful label such as `Resize panel`.
- Expose a useful value when possible, such as the current leading panel size.
- Support semantic increase and decrease actions.
- Support keyboard resizing without a mouse.

Keyboard behavior:

- Horizontal LTR: right increases the leading panel, left decreases it.
- Horizontal RTL: left increases the leading panel, right decreases it.
- Vertical: down increases the leading panel, up decreases it.
- Shift plus arrow uses `largeKeyboardResizeAmount`.
- Home moves the leading panel to its minimum valid size.
- End moves the leading panel to its maximum valid size.

Touch target:

- Default `handleExtent` should be large enough to grab.
- The visual handle may be smaller than the hit area.
- Do not make users style their way into basic usability.

## Defaults

Default values should make a useful widget without theme setup:

- `handleExtent`: `12`
- `keyboardResizeAmount`: `16`
- `largeKeyboardResizeAmount`: `64`
- `minSize`: `0`
- `maxSize`: `null`
- Default handle color should derive from `Theme.of(context).dividerColor`.
- Default focused handle should use `Theme.of(context).colorScheme.primary`.

Keep default styling boring and native-feeling. The package is layout
infrastructure.

## Theming And Customization

Use `handleBuilder` for v1 customization.

Do not add:

- `ResizablePanelTheme`
- `ThemeExtension`
- Handle preset enum
- Global inherited config

A builder is enough until repeated user needs prove otherwise.

## State And Control

v1 should be internally stateful and externally observable.

Include:

- Internal uncontrolled sizes
- `onSizesChanged`

Skip for v1:

- External controller
- Controlled `sizes`
- Persistence helper
- Restoration helper

Apps can store the emitted sizes themselves. Add controlled state later only if
real users need it.

## Error Handling And Edge Cases

Handle these deliberately:

- Empty `children`
- One child and zero handles
- Tiny container smaller than min sizes
- Panels with zero size
- Negative sizes in constructor inputs
- Rebuild with different child count
- Rebuild with different constraints
- Orientation change
- Text direction change
- Nested groups

Prefer asserts for developer mistakes. Prefer graceful clamping for runtime
constraint pressure.

## Suggested File Shape

Start small:

```text
lib/
  resizable_panel_group.dart
  src/
    resizable_panel.dart
    resizable_panel_group.dart
```

Only split further when a file becomes hard to read.

Possible later split:

```text
lib/src/
  resizable_handle.dart
  resizable_handle_details.dart
```

Do not create folders for themes, controllers, models, or utils before they are
real.

## Implementation Phases

### Phase 1: First Usable Layout

Goal: two horizontal panels resize by drag.

Build:

- `ResizablePanel`
- `ResizablePanelGroup`
- Horizontal layout
- One handle between two panels
- `minSize`, `maxSize`, `initialSize`
- Default handle
- Widget test for drag clamp behavior

Done when:

- Example code from the README can render.
- Dragging changes panel sizes.
- Min and max constraints are honored.
- `flutter analyze` and `flutter test` pass.

### Phase 2: General Panel Groups

Goal: support real panel groups.

Build:

- Vertical layout
- More than two panels
- Multiple handles
- Nested groups
- `onSizesChanged`

Done when:

- Three-panel resizing works.
- Resizing one handle only affects adjacent panels.
- Nested groups render and resize independently.

### Phase 3: Accessibility

Goal: make accessibility part of the core behavior.

Build:

- Focusable handles
- Keyboard resizing
- Semantic label
- Semantic increase and decrease actions
- RTL-aware horizontal keyboard behavior
- Visible focus state

Done when:

- Widget tests cover keyboard resizing.
- Widget tests cover semantics.
- Widget tests cover RTL horizontal behavior.

### Phase 4: Docs And Example

Goal: make the package understandable on pub.dev.

Build:

- Minimal README usage
- Accessibility notes
- Limitations section
- Small example app
- Screenshot or GIF if useful

Done when:

- README code compiles.
- Example app demonstrates nested panels and custom handle styling.
- Package description still matches the package.

### Phase 5: Publish Prep

Goal: prepare an honest first release.

Build:

- Repository URL in `pubspec.yaml`
- Issue tracker URL in `pubspec.yaml`
- Real changelog entry
- License intact
- Pub dry run clean

Done when:

- `flutter analyze` passes.
- `flutter test` passes.
- `dart pub publish --dry-run` passes.

## Test Plan

Use widget tests first. Do not add golden tests until the handle visuals become
important.

Required tests:

- Builds with one panel.
- Builds with two panels.
- Builds horizontal group.
- Builds vertical group.
- Applies `initialSize`.
- Shares remaining space across panels without `initialSize`.
- Clamps below `minSize`.
- Clamps above `maxSize`.
- Dragging handle resizes adjacent panels.
- Dragging one handle does not resize non-adjacent panels.
- Calls `onSizesChanged`.
- Supports nested panel groups.
- Focuses handle with keyboard navigation.
- Arrow keys resize focused handle.
- Shift plus arrow uses large step.
- Home and End clamp to boundaries.
- Horizontal RTL reverses left and right keyboard meaning.
- Semantics expose resize action.

Avoid testing private helpers unless public behavior is too awkward to reach.

## Example App Plan

Keep the example app focused:

- Left sidebar and main content split
- Main content split vertically into editor and preview
- Custom handle builder
- Visible focus behavior

Avoid:

- Fake product UI
- Routing
- State management packages
- Persistence
- Docking demos

## README Plan

When the widget API exists, README should include:

- One-sentence description
- Feature bullets
- Install snippet
- Minimal usage
- Custom handle usage
- Accessibility behavior
- Known limits

Keep the README direct. Pub.dev users should know within 30 seconds whether the
package solves their layout problem.

## CHANGELOG Plan

Use plain release notes:

- `0.0.1`: scaffold
- `0.1.0`: first usable public widget API
- Patch releases: bug fixes only

Do not overpromise future features in the changelog.

## Pub.dev Readiness

Before publishing:

- Confirm package name is available or owned.
- Add `repository`.
- Add `issue_tracker`.
- Confirm `description` is under pub.dev limits.
- Confirm README has no TODOs.
- Confirm public API docs explain each constructor.
- Run `flutter analyze`.
- Run `flutter test`.
- Run `dart pub publish --dry-run`.

## Compatibility

Current scaffold:

- Dart SDK: `^3.10.0`
- Flutter: `>=1.17.0`
- Runtime dependencies: Flutter only

Before release, consider whether `sdk: ^3.10.0` is too new for the intended
audience. Lower only if the code and tests actually work on the lower SDK.

## Decision Log

Keep these decisions unless there is a clear reason to change them:

- Package name: `resizable_panel_group`
- Description: `Accessible resizable panel groups for Flutter.`
- Primary API: panel group, panel, handle details
- v1 customization: `handleBuilder`
- v1 state model: uncontrolled with `onSizesChanged`
- v1 dependency policy: Flutter only
- v1 scope: panel resizing, not docking

## Future Ideas

Only revisit these after v1 works and users ask:

- Controlled panel sizes
- Controller API
- Collapse and expand callbacks
- Animated collapse
- Double-click reset
- Saved layout helper
- More handle presets
- Theme extension
- Drag-to-reorder panels
- Docking package built on top of this package

## Hand-Off Checklist For Future Sessions

Before editing:

- Read this file.
- Read `README.md`.
- Read `pubspec.yaml`.
- Inspect current `lib/` and `test/`.
- Check `git status --short`.

While editing:

- Keep the diff small.
- Add behavior before customization.
- Add one test for each non-trivial rule.
- Avoid new dependencies.
- Do not change public names casually after release.

Before handoff:

- Run `flutter analyze`.
- Run `flutter test`.
- Mention any skipped validation.
