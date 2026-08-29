import 'package:flutter/widgets.dart'
    show Axis, BuildContext, StatelessWidget, Widget, immutable;

/// Details about a handle between two panels.
///
/// This is passed to [ResizableHandleBuilder] so custom handles can react to
/// the group direction, panel position, and current drag state.
@immutable
class ResizableHandleDetails {
  /// Creates handle details for a specific handle in a panel group.
  const ResizableHandleDetails({
    required this.direction,
    required this.leadingPanelIndex,
    required this.isDragging,
  });

  /// The axis along which the surrounding [ResizablePanelGroup] resizes.
  final Axis direction;

  /// The index of the panel immediately before this handle.
  final int leadingPanelIndex;

  /// Whether the handle is currently being dragged by pointer input.
  final bool isDragging;
}

/// A single child inside a [ResizablePanelGroup].
///
/// The panel itself only stores sizing constraints and returns [child] from
/// [build]. The surrounding group owns the actual layout and resize behavior.
class ResizablePanel extends StatelessWidget {
  /// Creates a panel with optional min, max, and initial size constraints.
  const ResizablePanel({
    super.key,
    required this.child,
    this.minSize = 0,
    this.maxSize,
    this.initialSize,
  }) : assert(minSize == minSize),
       assert(minSize < double.infinity),
       assert(minSize >= 0),
       assert(maxSize == null || maxSize == maxSize),
       assert(maxSize == null || maxSize < double.infinity),
       assert(maxSize == null || maxSize >= 0),
       assert(initialSize == null || initialSize == initialSize),
       assert(initialSize == null || initialSize < double.infinity),
       assert(initialSize == null || initialSize >= 0),
       assert(maxSize == null || minSize <= maxSize),
       assert(initialSize == null || maxSize == null || initialSize <= maxSize);

  /// The widget shown inside this panel.
  final Widget child;

  /// The smallest size this panel may shrink to on the group's main axis.
  final double minSize;

  /// The largest size this panel may grow to on the group's main axis.
  ///
  /// When null, the panel can grow as large as the group allows.
  final double? maxSize;

  /// The preferred starting size on the group's main axis.
  ///
  /// When omitted, the group starts this panel at [minSize] and distributes any
  /// remaining space across flexible panels.
  final double? initialSize;

  @override
  Widget build(BuildContext context) => child;
}
