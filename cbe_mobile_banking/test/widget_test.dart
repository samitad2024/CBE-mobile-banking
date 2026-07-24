import 'package:cbe_mobile_banking/app/app.dart';
import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
    sl<AuthSessionBloc>().add(const AuthSessionRestoreRequested());
  });

  testWidgets('Login page renders', (WidgetTester tester) async {
    await tester.pumpWidget(const CbeMobileBankingApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('COMMERCIAL BANK OF ETHIOPIA'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
