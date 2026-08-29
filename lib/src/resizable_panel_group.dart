import 'dart:math' show max, min;

import 'package:flutter/material.dart'
    show
        Axis,
        BoxDecoration,
        BuildContext,
        Center,
        Column,
        Container,
        CrossAxisAlignment,
        DecoratedBox,
        Directionality,
        Focus,
        FocusNode,
        GestureDetector,
        HitTestBehavior,
        KeyEventResult,
        LayoutBuilder,
        MouseRegion,
        Row,
        Semantics,
        Size,
        SizedBox,
        State,
        StatefulWidget,
        StatelessWidget,
        SystemMouseCursors,
        TextDirection,
        Theme,
        ValueChanged,
        ValueKey,
        VoidCallback,
        Widget;
import 'package:flutter/services.dart'
    show
        HardwareKeyboard,
        KeyDownEvent,
        KeyEvent,
        KeyRepeatEvent,
        LogicalKeyboardKey;

import 'resizable_panel.dart' show ResizableHandleDetails, ResizablePanel;

typedef ResizableHandleBuilder =
    Widget Function(BuildContext context, ResizableHandleDetails details);

class ResizablePanelGroup extends StatefulWidget {
  ResizablePanelGroup({
    super.key,
    required this.direction,
    required this.children,
    this.handleExtent = 12,
    this.keyboardResizeAmount = 16,
    this.largeKeyboardResizeAmount = 64,
    this.handleBuilder,
    this.onSizesChanged,
  }) : assert(children.isNotEmpty),
       assert(handleExtent.isFinite),
       assert(handleExtent >= 0),
       assert(keyboardResizeAmount.isFinite),
       assert(keyboardResizeAmount >= 0),
       assert(largeKeyboardResizeAmount.isFinite),
       assert(largeKeyboardResizeAmount >= 0),
       assert(
         children.every(
           (panel) => panel.maxSize == null || panel.minSize <= panel.maxSize!,
         ),
       );

  final Axis direction;
  final List<ResizablePanel> children;
  final double handleExtent;
  final double keyboardResizeAmount;
  final double largeKeyboardResizeAmount;
  final ResizableHandleBuilder? handleBuilder;
  final ValueChanged<List<double>>? onSizesChanged;

  @override
  State<ResizablePanelGroup> createState() => _ResizablePanelGroupState();
}

class _ResizablePanelGroupState extends State<ResizablePanelGroup> {
  static const double _epsilon = 0.001;

  List<double>? _sizes;
  double? _lastAvailableExtent;

  @override
  void didUpdateWidget(covariant ResizablePanelGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _sizes = null;
      _lastAvailableExtent = null;
    } else if (!_hasSameBounds(oldWidget.children, widget.children)) {
      if (_sizes != null && _lastAvailableExtent != null) {
        _sizes = _fitSizesToAvailable(_sizes!, _lastAvailableExtent!);
      } else {
        _sizes = null;
      }
      _lastAvailableExtent = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelExtent = _availablePanelExtent(constraints.biggest);
        final sizes = _resolveSizes(panelExtent);
        final children = <Widget>[];

        for (var index = 0; index < widget.children.length; index += 1) {
          children.add(_buildPanel(widget.children[index], sizes[index]));
          if (index < widget.children.length - 1) {
            children.add(_buildHandle(context, index));
          }
        }

        if (widget.direction == Axis.horizontal) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        );
      },
    );
  }

  Widget _buildPanel(ResizablePanel panel, double extent) {
    if (widget.direction == Axis.horizontal) {
      return SizedBox(width: extent, child: panel.child);
    }

    return SizedBox(height: extent, child: panel.child);
  }

  Widget _buildHandle(BuildContext context, int index) {
    return _ResizableHandle(
      key: ValueKey('resizable_panel_group_handle_$index'),
      direction: widget.direction,
      extent: widget.handleExtent,
      leadingPanelIndex: index,
      handleBuilder: widget.handleBuilder,
      keyboardResizeAmount: widget.keyboardResizeAmount,
      largeKeyboardResizeAmount: widget.largeKeyboardResizeAmount,
      onResizeBy: (delta) => _resizePair(index, delta),
      onMoveToStart: () =>
          _resizePairToBoundary(index, moveLeadingToMax: false),
      onMoveToEnd: () => _resizePairToBoundary(index, moveLeadingToMax: true),
    );
  }

  double _mainAxisExtent(Size size) {
    return widget.direction == Axis.horizontal ? size.width : size.height;
  }

  double _availablePanelExtent(Size size) {
    final availableExtent = _mainAxisExtent(size);
    if (availableExtent.isFinite) {
      return max(
            0,
            availableExtent -
                widget.handleExtent * max(0, widget.children.length - 1),
          )
          .toDouble();
    }

    return widget.children.fold<double>(0, (sum, panel) {
      return sum + (panel.initialSize ?? panel.minSize);
    });
  }

  List<double> _resolveSizes(double availableExtent) {
    if (_sizes == null || _sizes!.length != widget.children.length) {
      _sizes = _initializeSizes(availableExtent);
    } else if (_lastAvailableExtent == null ||
        (_lastAvailableExtent! - availableExtent).abs() > _epsilon) {
      _sizes = _fitSizesToAvailable(_sizes!, availableExtent);
    }
    _lastAvailableExtent = availableExtent;
    return _sizes!;
  }

  bool _hasSameBounds(
    List<ResizablePanel> oldChildren,
    List<ResizablePanel> newChildren,
  ) {
    for (var index = 0; index < oldChildren.length; index += 1) {
      final oldPanel = oldChildren[index];
      final newPanel = newChildren[index];
      if (oldPanel.minSize != newPanel.minSize ||
          oldPanel.maxSize != newPanel.maxSize) {
        return false;
      }
    }
    return true;
  }

  List<double> _initializeSizes(double availableExtent) {
    final sizes = <double>[];
    final flexibleIndices = <int>[];

    for (var index = 0; index < widget.children.length; index += 1) {
      final panel = widget.children[index];
      final size = panel.initialSize ?? panel.minSize;
      sizes.add(_clampToBounds(index, size));
      if (panel.initialSize == null) {
        flexibleIndices.add(index);
      }
    }

    final remaining = availableExtent - _sum(sizes);
    if (remaining > _epsilon && flexibleIndices.isNotEmpty) {
      _growSizes(sizes, flexibleIndices, remaining);
    }

    return _fitSizesToAvailable(sizes, availableExtent);
  }

  List<double> _fitSizesToAvailable(
    List<double> input,
    double availableExtent,
  ) {
    final sizes = <double>[
      for (var index = 0; index < input.length; index += 1)
        _clampToBounds(index, input[index]),
    ];
    final currentTotal = _sum(sizes);

    if (currentTotal < availableExtent - _epsilon) {
      _growSizes(
        sizes,
        List<int>.generate(sizes.length, (index) => index),
        availableExtent - currentTotal,
      );
    } else if (currentTotal > availableExtent + _epsilon) {
      final remainingExcess = _shrinkSizes(
        sizes,
        List<int>.generate(sizes.length, (index) => index),
        currentTotal - availableExtent,
      );
      if (remainingExcess > _epsilon) {
        _scaleSizesToAvailable(sizes, availableExtent);
      }
    }

    return sizes;
  }

  void _growSizes(List<double> sizes, List<int> indices, double amount) {
    var remaining = amount;

    while (remaining > _epsilon) {
      final growable = <int>[
        for (final index in indices)
          if (sizes[index] < _maxSize(index) - _epsilon) index,
      ];
      if (growable.isEmpty) {
        return;
      }

      final share = remaining / growable.length;
      var consumed = 0.0;

      for (final index in growable) {
        final capacity = _maxSize(index) - sizes[index];
        final delta = min(capacity, share);
        if (delta > 0) {
          sizes[index] += delta;
          consumed += delta;
        }
      }

      if (consumed <= _epsilon) {
        return;
      }

      remaining -= consumed;
    }
  }

  double _shrinkSizes(List<double> sizes, List<int> indices, double amount) {
    var remaining = amount;

    while (remaining > _epsilon) {
      final shrinkable = <int>[
        for (final index in indices)
          if (sizes[index] > _minSize(index) + _epsilon) index,
      ];
      if (shrinkable.isEmpty) {
        return remaining;
      }

      final share = remaining / shrinkable.length;
      var consumed = 0.0;

      for (final index in shrinkable) {
        final capacity = sizes[index] - _minSize(index);
        final delta = min(capacity, share);
        if (delta > 0) {
          sizes[index] -= delta;
          consumed += delta;
        }
      }

      if (consumed <= _epsilon) {
        return remaining;
      }

      remaining -= consumed;
    }

    return 0;
  }

  void _scaleSizesToAvailable(List<double> sizes, double availableExtent) {
    final currentTotal = _sum(sizes);
    if (availableExtent <= 0 || currentTotal <= 0) {
      for (var index = 0; index < sizes.length; index += 1) {
        sizes[index] = 0;
      }
      return;
    }

    final scale = availableExtent / currentTotal;
    for (var index = 0; index < sizes.length; index += 1) {
      sizes[index] *= scale;
    }
  }

  void _resizePair(int index, double delta) {
    if (_sizes == null) {
      return;
    }

    final range = _allowedDeltaRange(index);
    final appliedDelta = delta.clamp(range.$1, range.$2).toDouble();
    if (appliedDelta.abs() <= _epsilon) {
      return;
    }

    setState(() {
      _sizes![index] += appliedDelta;
      _sizes![index + 1] -= appliedDelta;
    });
    widget.onSizesChanged?.call(List<double>.unmodifiable(_sizes!));
  }

  void _resizePairToBoundary(int index, {required bool moveLeadingToMax}) {
    final range = _allowedDeltaRange(index);
    _resizePair(index, moveLeadingToMax ? range.$2 : range.$1);
  }

  (double, double) _allowedDeltaRange(int index) {
    final leadingSize = _sizes![index];
    final trailingSize = _sizes![index + 1];
    final minDelta = max(
      _minSize(index) - leadingSize,
      trailingSize - _maxSize(index + 1),
    );
    final maxDelta = min(
      _maxSize(index) - leadingSize,
      trailingSize - _minSize(index + 1),
    );
    if (minDelta > maxDelta) {
      return (0, 0);
    }
    return (minDelta, maxDelta);
  }

  double _clampToBounds(int index, double size) {
    return size.clamp(_minSize(index), _maxSize(index)).toDouble();
  }

  double _minSize(int index) => widget.children[index].minSize;

  double _maxSize(int index) =>
      widget.children[index].maxSize ?? double.infinity;

  double _sum(List<double> sizes) {
    return sizes.fold<double>(0, (sum, size) => sum + size);
  }
}

class _ResizableHandle extends StatefulWidget {
  const _ResizableHandle({
    super.key,
    required this.direction,
    required this.extent,
    required this.leadingPanelIndex,
    required this.handleBuilder,
    required this.keyboardResizeAmount,
    required this.largeKeyboardResizeAmount,
    required this.onResizeBy,
    required this.onMoveToStart,
    required this.onMoveToEnd,
  });

  final Axis direction;
  final double extent;
  final int leadingPanelIndex;
  final ResizableHandleBuilder? handleBuilder;
  final double keyboardResizeAmount;
  final double largeKeyboardResizeAmount;
  final ValueChanged<double> onResizeBy;
  final VoidCallback onMoveToStart;
  final VoidCallback onMoveToEnd;

  @override
  State<_ResizableHandle> createState() => _ResizableHandleState();
}

class _ResizableHandleState extends State<_ResizableHandle> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;
  bool _isDragging = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = ResizableHandleDetails(
      direction: widget.direction,
      leadingPanelIndex: widget.leadingPanelIndex,
      isDragging: _isDragging,
    );
    final handleChild =
        widget.handleBuilder?.call(context, details) ??
        _DefaultResizableHandle(
          direction: widget.direction,
          isFocused: _hasFocus,
        );
    final axisSizedChild = widget.direction == Axis.horizontal
        ? SizedBox(width: widget.extent, child: handleChild)
        : SizedBox(height: widget.extent, child: handleChild);

    return Focus(
      focusNode: _focusNode,
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      onKeyEvent: (node, event) => _handleKeyEvent(context, event),
      child: Semantics(
        label: 'Resize panel',
        focusable: true,
        focused: _hasFocus,
        onIncrease: () => widget.onResizeBy(widget.keyboardResizeAmount),
        onDecrease: () => widget.onResizeBy(-widget.keyboardResizeAmount),
        child: MouseRegion(
          cursor: widget.direction == Axis.horizontal
              ? SystemMouseCursors.resizeColumn
              : SystemMouseCursors.resizeRow,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _focusNode.requestFocus(),
            onPanStart: (_) {
              _focusNode.requestFocus();
              setState(() {
                _isDragging = true;
              });
            },
            onPanUpdate: (details) {
              final delta = switch (widget.direction) {
                Axis.horizontal =>
                  Directionality.of(context) == TextDirection.rtl
                      ? -details.delta.dx
                      : details.delta.dx,
                Axis.vertical => details.delta.dy,
              };
              widget.onResizeBy(delta);
            },
            onPanEnd: (_) {
              setState(() {
                _isDragging = false;
              });
            },
            onPanCancel: () {
              setState(() {
                _isDragging = false;
              });
            },
            child: _HandleFocusDecoration(
              hasFocus: _hasFocus,
              child: axisSizedChild,
            ),
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(BuildContext context, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;
    final step = isShiftPressed
        ? widget.largeKeyboardResizeAmount
        : widget.keyboardResizeAmount;
    final textDirection = Directionality.of(context);
    double? delta;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        if (widget.direction == Axis.horizontal) {
          delta = textDirection == TextDirection.rtl ? step : -step;
        }
        break;
      case LogicalKeyboardKey.arrowRight:
        if (widget.direction == Axis.horizontal) {
          delta = textDirection == TextDirection.rtl ? -step : step;
        }
        break;
      case LogicalKeyboardKey.arrowUp:
        if (widget.direction == Axis.vertical) {
          delta = -step;
        }
        break;
      case LogicalKeyboardKey.arrowDown:
        if (widget.direction == Axis.vertical) {
          delta = step;
        }
        break;
      case LogicalKeyboardKey.home:
        widget.onMoveToStart();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.end:
        widget.onMoveToEnd();
        return KeyEventResult.handled;
    }

    if (delta == null) {
      return KeyEventResult.ignored;
    }

    widget.onResizeBy(delta);
    return KeyEventResult.handled;
  }
}

class _HandleFocusDecoration extends StatelessWidget {
  const _HandleFocusDecoration({required this.hasFocus, required this.child});

  final bool hasFocus;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: hasFocus ? colorScheme.primary.withValues(alpha: 0.12) : null,
      ),
      child: child,
    );
  }
}

class _DefaultResizableHandle extends StatelessWidget {
  const _DefaultResizableHandle({
    required this.direction,
    this.isFocused = false,
  });

  final Axis direction;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorColor = isFocused ? colorScheme.primary : dividerColor;

    return Center(
      child: direction == Axis.horizontal
          ? Container(width: 2, color: indicatorColor)
          : Container(height: 2, color: indicatorColor),
    );
  }
}
