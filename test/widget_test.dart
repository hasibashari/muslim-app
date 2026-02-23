import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/app/app.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Beranda'), findsOneWidget);
  });
}
