/// App-wide constants (mock phase).
abstract final class AppConstants {
  static const String appName = 'CBE Mobile Banking';
  static const String currencyCode = 'ETB';
  static const int pinLength = 4;
  static const String mockPin = '1234';

  /// Background / idle duration before AppLockBloc requires re-auth.
  /// Short in mock builds so QA can exercise lock quickly.
  static const Duration appLockIdleTimeout = Duration(seconds: 45);
}
