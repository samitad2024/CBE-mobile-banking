import 'package:cbe_mobile_banking/core/network/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';

/// Shared Dio client. Mock-first — real base URL injected later.
class DioClient {
  DioClient({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
                headers: <String, Object>{
                  Headers.contentTypeHeader: Headers.jsonContentType,
                  Headers.acceptHeader: Headers.jsonContentType,
                },
              ),
            ) {
    this.dio.interceptors.add(LoggingInterceptor());
  }

  final Dio dio;
}
