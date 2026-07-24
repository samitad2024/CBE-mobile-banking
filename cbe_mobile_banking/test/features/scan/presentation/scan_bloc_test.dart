import 'package:cbe_mobile_banking/features/scan/presentation/bloc/scan_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('scan listening → success → reset', () async {
    final bloc = ScanBloc()..add(const ScanStarted());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, isA<ScanListening>());

    bloc.add(const ScanMockCodeDetected('CBE|PAY|MOCK'));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, isA<ScanSuccess>());
    expect((bloc.state as ScanSuccess).payload, 'CBE|PAY|MOCK');

    bloc.add(const ScanReset());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, isA<ScanIdle>());
    await bloc.close();
  });
}
