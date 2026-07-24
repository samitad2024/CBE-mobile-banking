import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/network/dio_exception_mapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps connection errors to NetworkException', () {
    final mapped = DioExceptionMapper.map(
      DioException(
        requestOptions: RequestOptions(path: '/v1/home'),
        type: DioExceptionType.connectionError,
      ),
    );
    expect(mapped, isA<NetworkException>());
  });

  test('maps 401 to AuthException', () {
    final mapped = DioExceptionMapper.map(
      DioException(
        requestOptions: RequestOptions(path: '/v1/auth/login'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/v1/auth/login'),
          statusCode: 401,
        ),
      ),
    );
    expect(mapped, isA<AuthException>());
  });

  test('maps 500 to ServerException', () {
    final mapped = DioExceptionMapper.map(
      DioException(
        requestOptions: RequestOptions(path: '/v1/transfers'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/v1/transfers'),
          statusCode: 500,
        ),
      ),
    );
    expect(mapped, isA<ServerException>());
  });
}
