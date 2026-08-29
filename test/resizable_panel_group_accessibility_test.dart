import 'package:flutter/material.dart'
    show
        Axis,
        Colors,
        ColoredBox,
        Offset,
        SizedBox,
        Text,
        TextDirection,
        ValueKey;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart'
    show expect, find, findsOneWidget, matchesSemantics, testWidgets;
import 'package:resizable_panel_group/resizable_panel_group.dart'
    show ResizablePanel, ResizablePanelGroup;

import 'src/test_helpers.dart' show buildTestApp;

void main() {
  testWidgets('keyboard resizing works from a focused handle', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
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

  testWidgets('ignores unrelated keyboard arrows for the current axis', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          width: 200,
          height: 400,
          child: ResizablePanelGroup(
            direction: Axis.vertical,
            handleExtent: 10,
            keyboardResizeAmount: 20,
            children: const [
              ResizablePanel(
                initialSize: 120,
                child: ColoredBox(
                  key: ValueKey('ignored-top'),
                  color: Colors.red,
                ),
              ),
              ResizablePanel(
                child: ColoredBox(
                  key: ValueKey('ignored-bottom'),
                  color: Colors.blue,
                ),
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

    expect(
      tester.getSize(find.byKey(const ValueKey('ignored-top'))).height,
      120,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('ignored-bottom'))).height,
      270,
    );
  });

  testWidgets('shift plus arrow uses the large keyboard step', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          width: 400,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            handleExtent: 10,
            keyboardResizeAmount: 20,
            largeKeyboardResizeAmount: 60,
            children: const [
              ResizablePanel(
                initialSize: 120,
                child: ColoredBox(
                  key: ValueKey('shift-left'),
                  color: Colors.red,
                ),
              ),
              ResizablePanel(
                child: ColoredBox(
                  key: ValueKey('shift-right'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final handle = find.byKey(const ValueKey('resizable_panel_group_handle_0'));
    await tester.tap(handle);
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
    await tester.pump();

    expect(tester.getSize(find.byKey(const ValueKey('shift-left'))).width, 180);
    expect(
      tester.getSize(find.byKey(const ValueKey('shift-right'))).width,
      210,
    );
  });

  testWidgets('home and end move the handle to panel boundaries', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
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
                child: ColoredBox(
                  key: ValueKey('home-left'),
                  color: Colors.red,
                ),
              ),
              ResizablePanel(
                minSize: 150,
                child: ColoredBox(
                  key: ValueKey('home-right'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final handle = find.byKey(const ValueKey('resizable_panel_group_handle_0'));
    await tester.tap(handle);
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    expect(tester.getSize(find.byKey(const ValueKey('home-left'))).width, 200);
    expect(tester.getSize(find.byKey(const ValueKey('home-right'))).width, 190);

    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(tester.getSize(find.byKey(const ValueKey('home-left'))).width, 100);
    expect(tester.getSize(find.byKey(const ValueKey('home-right'))).width, 290);
  });

  testWidgets('tab focuses the first handle', (tester) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      buildTestApp(
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

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(
      tester.getSemantics(find.bySemanticsLabel('Resize panel')),
      matchesSemantics(
        label: 'Resize panel',
        isFocusable: true,
        isFocused: true,
        hasTapAction: true,
        hasScrollLeftAction: true,
        hasScrollRightAction: true,
        hasScrollUpAction: true,
        hasScrollDownAction: true,
        hasIncreaseAction: true,
        hasDecreaseAction: true,
      ),
    );

    semantics.dispose();
  });

  testWidgets('rtl horizontal keyboard behavior is reversed', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
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

  testWidgets('rtl horizontal pointer dragging is reversed', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        textDirection: TextDirection.rtl,
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

    await tester.drag(
      find.byKey(const ValueKey('resizable_panel_group_handle_0')),
      const Offset(-60, 0),
    );
    await tester.pump();

    expect(tester.getSize(find.byKey(const ValueKey('left'))).width, 160);
    expect(tester.getSize(find.byKey(const ValueKey('right'))).width, 230);
  });

  testWidgets('custom handle builder receives index and drag state', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          width: 500,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            handleExtent: 10,
            handleBuilder: (context, details) {
              final direction = details.direction == Axis.horizontal
                  ? 'h'
                  : 'v';
              return ColoredBox(
                color: Colors.black,
                child: Text(
                  '${details.leadingPanelIndex}:$direction:${details.isDragging}',
                  textDirection: TextDirection.ltr,
                ),
              );
            },
            children: const [
              ResizablePanel(child: ColoredBox(color: Colors.red)),
              ResizablePanel(child: ColoredBox(color: Colors.blue)),
              ResizablePanel(child: ColoredBox(color: Colors.green)),
            ],
          ),
        ),
      ),
    );

    expect(find.text('0:h:false'), findsOneWidget);
    expect(find.text('1:h:false'), findsOneWidget);

    final gesture = await tester.startGesture(
      tester.getCenter(
        find.byKey(const ValueKey('resizable_panel_group_handle_0')),
      ),
    );
    await gesture.moveBy(const Offset(20, 0));
    await tester.pump();

    expect(find.text('0:h:true'), findsOneWidget);

    await gesture.up();
    await tester.pump();

    expect(find.text('0:h:false'), findsOneWidget);
  });

  testWidgets('handle exposes resize semantics and semantics actions resize', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          width: 400,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            children: const [
              ResizablePanel(
                child: ColoredBox(
                  key: ValueKey('semantics-left'),
                  color: Colors.red,
                ),
              ),
              ResizablePanel(
                child: ColoredBox(
                  key: ValueKey('semantics-right'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final handle = find.bySemanticsLabel('Resize panel');

    expect(
      tester.getSemantics(handle),
      matchesSemantics(
        label: 'Resize panel',
        isFocusable: true,
        hasTapAction: true,
        hasScrollLeftAction: true,
        hasScrollRightAction: true,
        hasScrollUpAction: true,
        hasScrollDownAction: true,
        hasIncreaseAction: true,
        hasDecreaseAction: true,
      ),
    );

    tester.semantics.increase(find.semantics.byLabel('Resize panel'));
    await tester.pump();
    expect(
      tester.getSize(find.byKey(const ValueKey('semantics-left'))).width,
      210,
    );

    tester.semantics.decrease(find.semantics.byLabel('Resize panel'));
    await tester.pump();
    expect(
      tester.getSize(find.byKey(const ValueKey('semantics-left'))).width,
      194,
    );

    semantics.dispose();
  });
}
