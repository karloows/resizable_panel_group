import 'package:flutter/material.dart';
import 'package:resizable_panel_group/resizable_panel_group.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resizable Panel Group Example',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatelessWidget {
  const ExampleHome({super.key});

  static const double _wideLayoutMinWidth = 744;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resizable Panel Group')),
      body: Column(
        children: [
          const _ExampleNotice(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < _wideLayoutMinWidth) {
                  return const _PortraitWorkspace();
                }

                return const _LandscapeWorkspace();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleNotice extends StatelessWidget {
  const _ExampleNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          'Wide screens show a landscape split view. Narrow screens switch to a portrait split view. Both are resizable.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _LandscapeWorkspace extends StatelessWidget {
  const _LandscapeWorkspace();

  @override
  Widget build(BuildContext context) {
    return ResizablePanelGroup(
      direction: Axis.horizontal,
      handleBuilder: _buildExampleHandle,
      children: [
        const ResizablePanel(
          minSize: 180,
          initialSize: 220,
          child: _SidebarPane(),
        ),
        ResizablePanel(
          minSize: 320,
          child: ResizablePanelGroup(
            direction: Axis.vertical,
            handleBuilder: _buildExampleHandle,
            children: const [
              ResizablePanel(
                minSize: 220,
                initialSize: 320,
                child: _EditorPane(),
              ),
              ResizablePanel(
                minSize: 120,
                initialSize: 180,
                child: _ConsolePane(),
              ),
            ],
          ),
        ),
        const ResizablePanel(
          minSize: 220,
          maxSize: 360,
          initialSize: 280,
          child: _InspectorPane(label: 'Inspector'),
        ),
      ],
    );
  }
}

class _PortraitWorkspace extends StatelessWidget {
  const _PortraitWorkspace();

  @override
  Widget build(BuildContext context) {
    return ResizablePanelGroup(
      direction: Axis.vertical,
      handleBuilder: _buildExampleHandle,
      children: const [
        ResizablePanel(minSize: 160, initialSize: 180, child: _SidebarPane()),
        ResizablePanel(minSize: 240, initialSize: 300, child: _EditorPane()),
        ResizablePanel(minSize: 120, initialSize: 140, child: _ConsolePane()),
        ResizablePanel(
          minSize: 160,
          initialSize: 180,
          child: _InspectorPane(label: 'Inspector (Portrait)'),
        ),
      ],
    );
  }
}

Widget _buildExampleHandle(
  BuildContext context,
  ResizableHandleDetails details,
) {
  final theme = Theme.of(context);
  final color = details.isDragging
      ? theme.colorScheme.primary
      : theme.colorScheme.outline;
  final isHorizontal = details.direction == Axis.horizontal;

  return Center(
    child: MouseRegion(
      cursor: isHorizontal
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      child: Container(
        width: isHorizontal ? 12 : 52,
        height: isHorizontal ? 52 : 12,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          border: Border.all(color: color.withValues(alpha: 0.45)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Container(
            width: isHorizontal ? 4 : 36,
            height: isHorizontal ? 36 : 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    ),
  );
}

class _SidebarPane extends StatelessWidget {
  const _SidebarPane();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF5F7FA),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PaneTitle('Navigation'),
          SizedBox(height: 12),
          _NavTile('Overview'),
          _NavTile('Components'),
          _NavTile('States'),
          _NavTile('Accessibility'),
          _NavTile('Release Notes'),
        ],
      ),
    );
  }
}

class _EditorPane extends StatelessWidget {
  const _EditorPane();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PaneTitle('Editor'),
            const SizedBox(height: 12),
            Text(
              'Drag handles, tab to a handle, then use arrow keys to resize.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '''ResizablePanelGroup(
  direction: Axis.horizontal,
  children: [
    ResizablePanel(
      minSize: 180,
      initialSize: 220,
      child: Sidebar(),
    ),
    ResizablePanel(
      minSize: 320,
      child: Editor(),
    ),
  ],
)''',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsolePane extends StatelessWidget {
  const _ConsolePane();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: const Color(0xFF111827),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: DefaultTextStyle(
            style: theme.textTheme.bodySmall!.copyWith(
              color: const Color(0xFFD1D5DB),
              fontFamily: 'monospace',
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PaneTitle('Console', color: Colors.white),
                SizedBox(height: 12),
                Text('> flutter run'),
                SizedBox(height: 8),
                Text('Handle focused'),
                Text('ArrowRight -> leading panel +16'),
                Text('Shift+ArrowRight -> leading panel +64'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InspectorPane extends StatelessWidget {
  const _InspectorPane({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFFFFBEB),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PaneTitle(label),
          SizedBox(height: 12),
          const _InspectorRow(label: 'Landscape', value: 'Horizontal split'),
          const _InspectorRow(label: 'Portrait', value: 'Vertical split'),
          const _InspectorRow(label: 'Keyboard', value: 'Enabled'),
          const _InspectorRow(label: 'Semantics', value: 'Resize panel'),
        ],
      ),
    );
  }
}

class _PaneTitle extends StatelessWidget {
  const _PaneTitle(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(label),
        ),
      ),
    );
  }
}

class _InspectorRow extends StatelessWidget {
  const _InspectorRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
