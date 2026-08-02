import 'package:flutter_test/flutter_test.dart';
import 'package:chatbot/main.dart';

void main() {
  testWidgets('EduPathApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EduPathApp());
    expect(find.text('EduPath AI'), findsOneWidget);
  });
}
