/// Compile-time / env placeholders. Never put real secrets in source.
abstract final class SecureConfig {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'mock',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.cbe.et',
  );

  static bool get isMock => appEnv == 'mock';
}
