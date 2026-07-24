import 'package:flutter/services.dart';

/// Prevents screenshots / recents previews on supported platforms.
abstract interface class ScreenSecurityGateway {
  Future<void> enableSecure();

  Future<void> disableSecure();
}

/// MethodChannel-backed FLAG_SECURE (Android). No-op elsewhere.
class ScreenSecurityGatewayImpl implements ScreenSecurityGateway {
  ScreenSecurityGatewayImpl({
    MethodChannel? channel,
  }) : _channel = channel ??
            const MethodChannel('com.cbe.mobilebanking/screen_security');

  final MethodChannel _channel;
  int _refCount = 0;

  @override
  Future<void> enableSecure() async {
    _refCount++;
    if (_refCount == 1) {
      try {
        await _channel.invokeMethod<void>('enableSecure');
      } on MissingPluginException {
        // Desktop/web/tests — ignore.
      } on PlatformException {
        // Channel not wired yet — ignore.
      }
    }
  }

  @override
  Future<void> disableSecure() async {
    if (_refCount == 0) return;
    _refCount--;
    if (_refCount == 0) {
      try {
        await _channel.invokeMethod<void>('disableSecure');
      } on MissingPluginException {
        // Desktop/web/tests — ignore.
      } on PlatformException {
        // Channel not wired yet — ignore.
      }
    }
  }
}

/// Always-no-op gateway for unit tests / platforms without a channel.
class NoOpScreenSecurityGateway implements ScreenSecurityGateway {
  @override
  Future<void> enableSecure() async {}

  @override
  Future<void> disableSecure() async {}
}
