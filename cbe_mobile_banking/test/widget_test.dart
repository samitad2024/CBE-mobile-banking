import 'package:cbe_mobile_banking/app/app.dart';
import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  testWidgets('Login page renders', (WidgetTester tester) async {
    await tester.pumpWidget(const CbeMobileBankingApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('COMMERCIAL BANK OF ETHIOPIA'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
