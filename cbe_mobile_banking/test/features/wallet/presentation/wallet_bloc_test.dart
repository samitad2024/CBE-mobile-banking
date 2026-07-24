import 'package:cbe_mobile_banking/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late WalletBloc bloc;

  setUp(() => bloc = WalletBloc());
  tearDown(() async => bloc.close());

  test('loads linked wallets', () async {
    bloc.add(const WalletStarted());
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final state = bloc.state;
    expect(state, isA<WalletLoaded>());
    expect(
      (state as WalletLoaded).linkedWallets,
      ['CBE Birr', 'Telebirr', 'M-Pesa'],
    );
  });
}
