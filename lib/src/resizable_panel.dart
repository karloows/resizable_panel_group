import 'package:flutter/widgets.dart';

@immutable
class ResizableHandleDetails {
  const ResizableHandleDetails({
    required this.direction,
    required this.leadingPanelIndex,
    required this.isDragging,
  });

  final Axis direction;
  final int leadingPanelIndex;
  final bool isDragging;
}

class ResizablePanel extends StatelessWidget {
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

  final Widget child;
  final double minSize;
  final double? maxSize;
  final double? initialSize;

  @override
  Widget build(BuildContext context) => child;
}
