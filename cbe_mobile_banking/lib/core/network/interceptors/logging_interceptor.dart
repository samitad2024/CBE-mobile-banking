import 'package:cbe_mobile_banking/core/utils/app_logger.dart';
import 'package:dio/dio.dart';

/// Logs method + path only. Never logs bodies that may contain secrets.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d('${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.w('HTTP ${err.response?.statusCode} ${err.requestOptions.path}');
    handler.next(err);
  }
}
