import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:dio/dio.dart';

/// Maps Dio errors to data-layer exceptions (never logs bodies / secrets).
abstract final class DioExceptionMapper {
  static Exception map(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException('Unable to reach CBE services');
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 401 || code == 403) {
          return const AuthException('Session expired or unauthorized');
        }
        return ServerException('Server error (${code ?? 'unknown'})');
      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');
      case DioExceptionType.badCertificate:
        return const NetworkException('Secure connection failed');
      case DioExceptionType.unknown:
        return NetworkException(
          error.message ?? 'Unexpected network error',
        );
    }
  }
}
