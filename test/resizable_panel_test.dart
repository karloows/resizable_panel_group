import 'package:flutter/material.dart' show Axis, SizedBox;
import 'package:flutter_test/flutter_test.dart'
    show expect, isA, test, throwsA;
import 'package:resizable_panel_group/resizable_panel_group.dart'
    show ResizablePanel, ResizablePanelGroup;

import 'src/test_helpers.dart'
    show
        groupWithHandleExtent,
        groupWithKeyboardResizeAmount,
        groupWithLargeKeyboardResizeAmount,
        panelWithInitialSize,
        panelWithMaxSize,
        panelWithMinSize;

void main() {
  test('rejects non-finite public group sizes', () {
    expect(
      () => groupWithHandleExtent(double.infinity),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => groupWithHandleExtent(double.nan),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => groupWithKeyboardResizeAmount(double.infinity),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => groupWithKeyboardResizeAmount(double.nan),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => groupWithLargeKeyboardResizeAmount(double.infinity),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => groupWithLargeKeyboardResizeAmount(double.nan),
      throwsA(isA<AssertionError>()),
    );
  });

  test('rejects structurally invalid public group sizes', () {
    expect(
      () => ResizablePanelGroup(direction: Axis.horizontal, children: const []),
      throwsA(isA<AssertionError>()),
    );
    expect(() => groupWithHandleExtent(-1), throwsA(isA<AssertionError>()));
    expect(
      () => groupWithKeyboardResizeAmount(-1),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => groupWithLargeKeyboardResizeAmount(-1),
      throwsA(isA<AssertionError>()),
    );
  });

  test('rejects non-finite public panel sizes', () {
    expect(
      () => panelWithMinSize(double.infinity),
      throwsA(isA<AssertionError>()),
    );
    expect(() => panelWithMinSize(double.nan), throwsA(isA<AssertionError>()));
    expect(
      () => panelWithInitialSize(double.infinity),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => panelWithInitialSize(double.nan),
      throwsA(isA<AssertionError>()),
    );
  });

  test('rejects invalid public panel bounds', () {
    expect(
      () => panelWithMaxSize(double.infinity),
      throwsA(isA<AssertionError>()),
    );
    expect(() => panelWithMaxSize(double.nan), throwsA(isA<AssertionError>()));
    expect(
      () => ResizablePanel(maxSize: -1, child: const SizedBox.shrink()),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => ResizablePanel(initialSize: -1, child: const SizedBox.shrink()),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => ResizablePanel(
        minSize: 120,
        maxSize: 100,
        child: const SizedBox.shrink(),
      ),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => ResizablePanel(
        maxSize: 100,
        initialSize: 120,
        child: const SizedBox.shrink(),
      ),
      throwsA(isA<AssertionError>()),
    );
  });
}
