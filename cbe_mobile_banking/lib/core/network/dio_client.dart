import 'package:cbe_mobile_banking/core/network/interceptors/auth_interceptor.dart';
import 'package:cbe_mobile_banking/core/network/interceptors/logging_interceptor.dart';
import 'package:cbe_mobile_banking/core/security/secure_config.dart';
import 'package:cbe_mobile_banking/core/security/session_manager.dart';
import 'package:dio/dio.dart';

/// Shared Dio client. Base URL from [SecureConfig.apiBaseUrl].
class DioClient {
  DioClient({
    required SessionManager sessionManager,
    Dio? dio,
    String? baseUrl,
  }) : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? SecureConfig.apiBaseUrl,
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
                headers: <String, Object>{
                  Headers.contentTypeHeader: Headers.jsonContentType,
                  Headers.acceptHeader: Headers.jsonContentType,
                },
              ),
            ) {
    this.dio.interceptors
      ..add(AuthInterceptor(sessionManager))
      ..add(LoggingInterceptor());
  }

  final Dio dio;
}
