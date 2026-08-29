import 'package:flutter/material.dart'
    show
        Axis,
        Center,
        Directionality,
        MaterialApp,
        Scaffold,
        SizedBox,
        TextDirection,
        Widget;
import 'package:resizable_panel_group/resizable_panel_group.dart'
    show ResizablePanel, ResizablePanelGroup;

Widget buildTestApp({
  required Widget child,
  TextDirection textDirection = TextDirection.ltr,
}) {
  return MaterialApp(
    home: Directionality(
      textDirection: textDirection,
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

ResizablePanel panelWithMinSize(double minSize) {
  return ResizablePanel(minSize: minSize, child: const SizedBox.shrink());
}

ResizablePanel panelWithInitialSize(double initialSize) {
  return ResizablePanel(
    initialSize: initialSize,
    child: const SizedBox.shrink(),
  );
}

ResizablePanel panelWithMaxSize(double maxSize) {
  return ResizablePanel(maxSize: maxSize, child: const SizedBox.shrink());
}

ResizablePanelGroup groupWithHandleExtent(double handleExtent) {
  return ResizablePanelGroup(
    direction: Axis.horizontal,
    handleExtent: handleExtent,
    children: const [
      ResizablePanel(child: SizedBox.shrink()),
      ResizablePanel(child: SizedBox.shrink()),
    ],
  );
}

ResizablePanelGroup groupWithKeyboardResizeAmount(double keyboardResizeAmount) {
  return ResizablePanelGroup(
    direction: Axis.horizontal,
    keyboardResizeAmount: keyboardResizeAmount,
    children: const [
      ResizablePanel(child: SizedBox.shrink()),
      ResizablePanel(child: SizedBox.shrink()),
    ],
  );
}

ResizablePanelGroup groupWithLargeKeyboardResizeAmount(
  double largeKeyboardResizeAmount,
) {
  return ResizablePanelGroup(
    direction: Axis.horizontal,
    largeKeyboardResizeAmount: largeKeyboardResizeAmount,
    children: const [
      ResizablePanel(child: SizedBox.shrink()),
      ResizablePanel(child: SizedBox.shrink()),
    ],
  );
}
