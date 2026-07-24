import 'package:cbe_mobile_banking/app/di/injection.dart';
import 'package:cbe_mobile_banking/core/security/screen_security_gateway.dart';
import 'package:flutter/widgets.dart';

/// Enables FLAG_SECURE while mounted (Login, Transfer, Receipt).
class SecureScreen extends StatefulWidget {
  const SecureScreen({required this.child, super.key});

  final Widget child;

  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  @override
  void initState() {
    super.initState();
    sl<ScreenSecurityGateway>().enableSecure();
  }

  @override
  void dispose() {
    sl<ScreenSecurityGateway>().disableSecure();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
