/// In-memory mock session holder. Replace with secure token store later.
abstract interface class SessionManager {
  String? get accessToken;

  bool get isAuthenticated;

  void setSession({required String token});

  void clear();
}

class MockSessionManager implements SessionManager {
  String? _token;

  @override
  String? get accessToken => _token;

  @override
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  @override
  void setSession({required String token}) => _token = token;

  @override
  void clear() => _token = null;
}
