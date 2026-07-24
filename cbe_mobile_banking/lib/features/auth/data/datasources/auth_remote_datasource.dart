import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/network/dio_client.dart';
import 'package:cbe_mobile_banking/core/network/dio_exception_mapper.dart';
import 'package:cbe_mobile_banking/core/security/biometric_gateway.dart';
import 'package:cbe_mobile_banking/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/auth/data/models/session_model.dart';
import 'package:dio/dio.dart';

/// Remote auth — PIN login hits API; biometrics still unlocks locally then exchanges.
class AuthRemoteDataSourceImpl implements AuthDataSource {
  AuthRemoteDataSourceImpl({
    required DioClient dioClient,
    required this._biometricGateway,
  }) : _dio = dioClient.dio;

  final Dio _dio;
  final BiometricGateway _biometricGateway;

  @override
  Future<SessionModel> loginWithPin(String pin) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/auth/login',
        data: <String, dynamic>{'pin': pin},
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty login response');
      }
      return SessionModel.fromJson(data);
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }

  @override
  Future<SessionModel> loginWithBiometrics() async {
    final ok = await _biometricGateway.authenticate(
      reason: 'Authenticate to open CBE Mobile Banking',
    );
    if (!ok) {
      throw const AuthException('Biometric authentication failed');
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/auth/biometric',
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty biometric login response');
      }
      return SessionModel.fromJson(data);
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }
}
