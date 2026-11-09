import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sylpark/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SylPark app initialization smoke test', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SylParkApp());
    expect(find.byType(SylParkApp), findsOneWidget);

    // Advance fake timer past splash delay
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}
