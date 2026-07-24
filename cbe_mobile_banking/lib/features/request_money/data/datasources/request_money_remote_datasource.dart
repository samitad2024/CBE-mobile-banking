import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/network/dio_client.dart';
import 'package:cbe_mobile_banking/core/network/dio_exception_mapper.dart';
import 'package:cbe_mobile_banking/features/request_money/data/datasources/request_money_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/incoming_request_entity.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/entities/payment_request_entity.dart';
import 'package:dio/dio.dart';

class RequestMoneyRemoteDataSourceImpl implements RequestMoneyDataSource {
  RequestMoneyRemoteDataSourceImpl({required DioClient dioClient})
      : _dio = dioClient.dio;

  final Dio _dio;

  @override
  Future<PaymentRequestEntity> create({
    required RequestMode mode,
    required double amountEtb,
    String? accountOrNote,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/requests',
        data: <String, dynamic>{
          'mode': mode.name,
          'amountEtb': amountEtb,
          'accountOrNote': accountOrNote,
        },
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty request response');
      }
      return PaymentRequestEntity(
        mode: mode,
        amountEtb: (data['amountEtb'] as num?)?.toDouble() ?? amountEtb,
        accountOrNote: data['accountOrNote'] as String? ?? accountOrNote,
        qrPayload: data['qrPayload'] as String?,
      );
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }

  @override
  Future<List<IncomingRequestEntity>> fetchPendingRequests() async {
    try {
      final response = await _dio.get<List<dynamic>>('/v1/requests/pending');
      final data = response.data ?? const [];
      return data.whereType<Map<String, dynamic>>().map((json) {
        return IncomingRequestEntity(
          id: json['id'] as String? ?? '',
          fromName: json['fromName'] as String? ?? '',
          maskedAccount: json['maskedAccount'] as String? ?? '',
          amountEtb: (json['amountEtb'] as num?)?.toDouble() ?? 0,
          note: json['note'] as String? ?? '',
          requestedAt:
              DateTime.tryParse(json['requestedAt'] as String? ?? '') ??
                  DateTime.now(),
        );
      }).toList();
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }
}
