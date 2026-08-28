import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resizable_panel_group/resizable_panel_group.dart';

void main() {
  testWidgets('lays out horizontal panels using initial size', (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: SizedBox(
          width: 400,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            handleExtent: 10,
            children: const [
              ResizablePanel(
                initialSize: 120,
                child: ColoredBox(key: ValueKey('left'), color: Colors.red),
              ),
              ResizablePanel(
                child: ColoredBox(key: ValueKey('right'), color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const ValueKey('left'))).width, 120);
    expect(tester.getSize(find.byKey(const ValueKey('right'))).width, 270);
  });

  testWidgets('dragging clamps to min and max sizes', (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: SizedBox(
          width: 400,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            handleExtent: 10,
            children: const [
              ResizablePanel(
                minSize: 100,
                maxSize: 200,
                initialSize: 120,
                child: ColoredBox(key: ValueKey('left'), color: Colors.red),
              ),
              ResizablePanel(
                minSize: 100,
                child: ColoredBox(key: ValueKey('right'), color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );

    final handle = find.byKey(const ValueKey('resizable_panel_group_handle_0'));

    await tester.drag(handle, const Offset(200, 0));
    await tester.pump();
    expect(tester.getSize(find.byKey(const ValueKey('left'))).width, 200);
    expect(tester.getSize(find.byKey(const ValueKey('right'))).width, 190);

    await tester.drag(handle, const Offset(-300, 0));
    await tester.pump();
    expect(tester.getSize(find.byKey(const ValueKey('left'))).width, 100);
    expect(tester.getSize(find.byKey(const ValueKey('right'))).width, 290);
  });

  testWidgets('supports vertical resizing', (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: SizedBox(
          width: 200,
          height: 400,
          child: ResizablePanelGroup(
            direction: Axis.vertical,
            handleExtent: 10,
            children: const [
              ResizablePanel(
                initialSize: 120,
                child: ColoredBox(key: ValueKey('top'), color: Colors.red),
              ),
              ResizablePanel(
                child: ColoredBox(key: ValueKey('bottom'), color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );

    final handle = find.byKey(const ValueKey('resizable_panel_group_handle_0'));
    await tester.drag(handle, const Offset(0, 60));
    await tester.pump();

    expect(tester.getSize(find.byKey(const ValueKey('top'))).height, 160);
    expect(tester.getSize(find.byKey(const ValueKey('bottom'))).height, 230);
  });

  testWidgets('keyboard resizing works from a focused handle', (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: SizedBox(
          width: 400,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            handleExtent: 10,
            keyboardResizeAmount: 20,
            children: const [
              ResizablePanel(
                initialSize: 120,
                child: ColoredBox(key: ValueKey('left'), color: Colors.red),
              ),
              ResizablePanel(
                child: ColoredBox(key: ValueKey('right'), color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );

    final handle = find.byKey(const ValueKey('resizable_panel_group_handle_0'));
    await tester.tap(handle);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();

    expect(tester.getSize(find.byKey(const ValueKey('left'))).width, 140);
    expect(tester.getSize(find.byKey(const ValueKey('right'))).width, 250);
  });

  testWidgets('rtl horizontal keyboard behavior is reversed', (tester) async {
    await tester.pumpWidget(
      _testApp(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 400,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            handleExtent: 10,
            keyboardResizeAmount: 20,
            children: const [
              ResizablePanel(
                initialSize: 120,
                child: ColoredBox(key: ValueKey('left'), color: Colors.red),
              ),
              ResizablePanel(
                child: ColoredBox(key: ValueKey('right'), color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );

    final handle = find.byKey(const ValueKey('resizable_panel_group_handle_0'));
    await tester.tap(handle);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();

    expect(tester.getSize(find.byKey(const ValueKey('left'))).width, 140);
    expect(tester.getSize(find.byKey(const ValueKey('right'))).width, 250);
  });

  testWidgets('handle exposes resize semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _testApp(
        child: SizedBox(
          width: 400,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            children: const [
              ResizablePanel(child: ColoredBox(color: Colors.red)),
              ResizablePanel(child: ColoredBox(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Resize panel'), findsOneWidget);
    semantics.dispose();
  });
}

Widget _testApp({
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
