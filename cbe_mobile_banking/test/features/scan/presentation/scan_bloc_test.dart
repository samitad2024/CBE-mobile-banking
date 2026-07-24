import 'package:cbe_mobile_banking/features/scan/presentation/bloc/scan_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('scan listening → success → reset', () async {
    final bloc = ScanBloc()..add(const ScanStarted());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, isA<ScanListening>());

    bloc.add(const ScanCodeDetected('CBE|PAY|MOCK'));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, isA<ScanSuccess>());
    expect((bloc.state as ScanSuccess).payload, 'CBE|PAY|MOCK');

    bloc.add(const ScanReset());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, isA<ScanIdle>());
    await bloc.close();
  });

  test('ignores detection when already successful', () async {
    final bloc = ScanBloc()..add(const ScanStarted());
    await Future<void>.delayed(Duration.zero);
    bloc.add(const ScanCodeDetected('first'));
    await Future<void>.delayed(Duration.zero);
    bloc.add(const ScanCodeDetected('second'));
    await Future<void>.delayed(Duration.zero);
    expect((bloc.state as ScanSuccess).payload, 'first');
    await bloc.close();
  });

  test('camera failure emits ScanFailure', () async {
    final bloc = ScanBloc()..add(const ScanStarted());
    await Future<void>.delayed(Duration.zero);
    bloc.add(const ScanFailed('no camera'));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, isA<ScanFailure>());
    await bloc.close();
  });
}
