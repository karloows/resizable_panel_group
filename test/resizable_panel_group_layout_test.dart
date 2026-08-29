import 'package:flutter/material.dart'
    show Axis, Colors, ColoredBox, Offset, SizedBox, UnconstrainedBox, ValueKey;
import 'package:flutter_test/flutter_test.dart'
    show
        expect,
        find,
        findsNothing,
        findsNWidgets,
        findsOneWidget,
        greaterThan,
        isNotNull,
        isNull,
        lessThan,
        orderedEquals,
        testWidgets;
import 'package:resizable_panel_group/resizable_panel_group.dart'
    show ResizablePanel, ResizablePanelGroup;

import 'src/test_helpers.dart' show buildTestApp;

void main() {
  testWidgets('builds with one panel', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          width: 300,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            children: const [
              ResizablePanel(
                child: ColoredBox(
                  key: ValueKey('only-panel'),
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('only-panel')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('resizable_panel_group_handle_0')),
      findsNothing,
    );
    expect(tester.getSize(find.byKey(const ValueKey('only-panel'))).width, 300);
  });

  testWidgets('lays out horizontal panels using initial size', (tester) async {
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

  testWidgets('shares remaining space across panels without initial size', (
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
            children: const [
              ResizablePanel(
                child: ColoredBox(key: ValueKey('first'), color: Colors.red),
              ),
              ResizablePanel(
                child: ColoredBox(key: ValueKey('second'), color: Colors.blue),
              ),
              ResizablePanel(
                child: ColoredBox(key: ValueKey('third'), color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const ValueKey('first'))).width, 160);
    expect(tester.getSize(find.byKey(const ValueKey('second'))).width, 160);
    expect(tester.getSize(find.byKey(const ValueKey('third'))).width, 160);
  });

  testWidgets('shrinks oversized initial sizes to fit available extent', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          width: 300,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            handleExtent: 10,
            children: const [
              ResizablePanel(
                initialSize: 200,
                child: ColoredBox(
                  key: ValueKey('oversized-left'),
                  color: Colors.red,
                ),
              ),
              ResizablePanel(
                initialSize: 180,
                child: ColoredBox(
                  key: ValueKey('oversized-right'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('oversized-left'))).width,
      155,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('oversized-right'))).width,
      135,
    );
  });

  testWidgets('scales minimum sizes when constraints cannot all fit', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          width: 110,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            handleExtent: 10,
            children: const [
              ResizablePanel(
                minSize: 60,
                child: ColoredBox(
                  key: ValueKey('scaled-left'),
                  color: Colors.red,
                ),
              ),
              ResizablePanel(
                minSize: 140,
                child: ColoredBox(
                  key: ValueKey('scaled-right'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const ValueKey('scaled-left'))).width, 30);
    expect(
      tester.getSize(find.byKey(const ValueKey('scaled-right'))).width,
      70,
    );
  });

  testWidgets('dragging clamps to min and max sizes', (tester) async {
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

  testWidgets('same-count bound changes refit cached sizes', (tester) async {
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
      const Offset(80, 0),
    );
    await tester.pump();

    expect(tester.getSize(find.byKey(const ValueKey('left'))).width, 180);

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
                initialSize: 120,
                maxSize: 150,
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
    await tester.pump();

    expect(tester.getSize(find.byKey(const ValueKey('left'))).width, 150);
    expect(tester.getSize(find.byKey(const ValueKey('right'))).width, 240);
  });

  testWidgets('same-count rebuilds keep resized state when bounds stay equal', (
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
                initialSize: 120,
                child: ColoredBox(
                  key: ValueKey('persist-left-before'),
                  color: Colors.red,
                ),
              ),
              ResizablePanel(
                child: ColoredBox(
                  key: ValueKey('persist-right-before'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.drag(
      find.byKey(const ValueKey('resizable_panel_group_handle_0')),
      const Offset(80, 0),
    );
    await tester.pump();

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
                initialSize: 120,
                child: ColoredBox(
                  key: ValueKey('persist-left-after'),
                  color: Colors.orange,
                ),
              ),
              ResizablePanel(
                child: ColoredBox(
                  key: ValueKey('persist-right-after'),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getSize(find.byKey(const ValueKey('persist-left-after'))).width,
      180,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('persist-right-after'))).width,
      210,
    );
  });

  testWidgets(
    'dragging is a no-op when adjacent minimum sizes cannot both fit',
    (tester) async {
      List<double>? reportedSizes;

      await tester.pumpWidget(
        buildTestApp(
          child: SizedBox(
            width: 150,
            height: 200,
            child: ResizablePanelGroup(
              direction: Axis.horizontal,
              handleExtent: 10,
              onSizesChanged: (sizes) => reportedSizes = sizes,
              children: const [
                ResizablePanel(
                  minSize: 100,
                  child: ColoredBox(
                    key: ValueKey('tight-left'),
                    color: Colors.red,
                  ),
                ),
                ResizablePanel(
                  minSize: 100,
                  child: ColoredBox(
                    key: ValueKey('tight-right'),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final leftBefore = tester
          .getSize(find.byKey(const ValueKey('tight-left')))
          .width;
      final rightBefore = tester
          .getSize(find.byKey(const ValueKey('tight-right')))
          .width;

      await tester.drag(
        find.byKey(const ValueKey('resizable_panel_group_handle_0')),
        const Offset(40, 0),
      );
      await tester.pump();

      expect(
        tester.getSize(find.byKey(const ValueKey('tight-left'))).width,
        leftBefore,
      );
      expect(
        tester.getSize(find.byKey(const ValueKey('tight-right'))).width,
        rightBefore,
      );
      expect(reportedSizes, isNull);
    },
  );

  testWidgets('dragging one handle does not resize non-adjacent panels', (
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
            children: const [
              ResizablePanel(
                initialSize: 120,
                child: ColoredBox(key: ValueKey('left-3'), color: Colors.red),
              ),
              ResizablePanel(
                initialSize: 180,
                child: ColoredBox(
                  key: ValueKey('middle-3'),
                  color: Colors.blue,
                ),
              ),
              ResizablePanel(
                child: ColoredBox(
                  key: ValueKey('right-3'),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final leftBefore = tester
        .getSize(find.byKey(const ValueKey('left-3')))
        .width;
    final middleBefore = tester
        .getSize(find.byKey(const ValueKey('middle-3')))
        .width;
    final rightBefore = tester
        .getSize(find.byKey(const ValueKey('right-3')))
        .width;

    await tester.drag(
      find.byKey(const ValueKey('resizable_panel_group_handle_0')),
      const Offset(40, 0),
    );
    await tester.pump();

    expect(
      tester.getSize(find.byKey(const ValueKey('left-3'))).width,
      greaterThan(leftBefore),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('middle-3'))).width,
      lessThan(middleBefore),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('right-3'))).width,
      rightBefore,
    );
  });

  testWidgets('supports vertical resizing', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
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

  testWidgets('calls onSizesChanged after dragging', (tester) async {
    List<double>? reportedSizes;

    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          width: 400,
          height: 200,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            handleExtent: 10,
            onSizesChanged: (sizes) => reportedSizes = sizes,
            children: const [
              ResizablePanel(
                initialSize: 120,
                child: ColoredBox(
                  key: ValueKey('drag-left'),
                  color: Colors.red,
                ),
              ),
              ResizablePanel(
                child: ColoredBox(
                  key: ValueKey('drag-right'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.drag(
      find.byKey(const ValueKey('resizable_panel_group_handle_0')),
      const Offset(40, 0),
    );
    await tester.pump();

    expect(reportedSizes, isNotNull);
    expect(
      reportedSizes,
      orderedEquals([
        tester.getSize(find.byKey(const ValueKey('drag-left'))).width,
        tester.getSize(find.byKey(const ValueKey('drag-right'))).width,
      ]),
    );
  });

  testWidgets('uses finite fallback sizing in a Row', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          height: 200,
          child: UnconstrainedBox(
            constrainedAxis: Axis.vertical,
            child: ResizablePanelGroup(
              direction: Axis.horizontal,
              handleExtent: 10,
              children: const [
                ResizablePanel(
                  initialSize: 120,
                  child: ColoredBox(
                    key: ValueKey('row-left'),
                    color: Colors.red,
                  ),
                ),
                ResizablePanel(
                  minSize: 80,
                  child: ColoredBox(
                    key: ValueKey('row-right'),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byKey(const ValueKey('row-left'))).width, 120);
    expect(tester.getSize(find.byKey(const ValueKey('row-right'))).width, 80);
  });

  testWidgets('uses finite fallback sizing in a Column', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          width: 200,
          child: UnconstrainedBox(
            constrainedAxis: Axis.horizontal,
            child: ResizablePanelGroup(
              direction: Axis.vertical,
              handleExtent: 10,
              children: const [
                ResizablePanel(
                  initialSize: 90,
                  child: ColoredBox(
                    key: ValueKey('column-top'),
                    color: Colors.red,
                  ),
                ),
                ResizablePanel(
                  minSize: 70,
                  child: ColoredBox(
                    key: ValueKey('column-bottom'),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byKey(const ValueKey('column-top'))).height, 90);
    expect(
      tester.getSize(find.byKey(const ValueKey('column-bottom'))).height,
      70,
    );
  });

  testWidgets('supports nested panel groups', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: SizedBox(
          width: 500,
          height: 300,
          child: ResizablePanelGroup(
            direction: Axis.horizontal,
            handleExtent: 10,
            children: [
              const ResizablePanel(
                initialSize: 160,
                child: ColoredBox(
                  key: ValueKey('nested-left'),
                  color: Colors.red,
                ),
              ),
              ResizablePanel(
                child: ResizablePanelGroup(
                  direction: Axis.vertical,
                  handleExtent: 10,
                  children: const [
                    ResizablePanel(
                      initialSize: 120,
                      child: ColoredBox(
                        key: ValueKey('nested-top'),
                        color: Colors.blue,
                      ),
                    ),
                    ResizablePanel(
                      child: ColoredBox(
                        key: ValueKey('nested-bottom'),
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('nested-left'))).width,
      160,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('nested-top'))).height,
      120,
    );
    expect(find.bySemanticsLabel('Resize panel'), findsNWidgets(2));
  });
}
