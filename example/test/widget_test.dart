import 'package:flutter_test/flutter_test.dart';
import 'package:resizable_panel_group_example/main.dart';

void main() {
  testWidgets('shows the example app', (tester) async {
    await tester.pumpWidget(const ExampleApp());

    expect(find.text('Resizable Panel Group'), findsOneWidget);
    expect(
      find.textContaining('Wide screens show a landscape split view'),
      findsOneWidget,
    );
  });
}
