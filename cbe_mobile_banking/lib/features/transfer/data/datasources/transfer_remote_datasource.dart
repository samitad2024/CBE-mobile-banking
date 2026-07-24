import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/network/dio_client.dart';
import 'package:cbe_mobile_banking/core/network/dio_exception_mapper.dart';
import 'package:cbe_mobile_banking/features/transfer/data/datasources/transfer_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/entities/transfer_entity.dart';
import 'package:dio/dio.dart';

class TransferRemoteDataSourceImpl implements TransferDataSource {
  TransferRemoteDataSourceImpl({required DioClient dioClient})
      : _dio = dioClient.dio;

  final Dio _dio;

  @override
  Future<TransferResultEntity> submit(TransferDraftEntity draft) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/transfers',
        data: <String, dynamic>{
          'rail': draft.rail.name,
          'receiverName': draft.receiverName,
          'destination': draft.destination,
          'amountEtb': draft.amountEtb,
        },
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty transfer response');
      }
      return TransferResultEntity(
        transactionId: data['transactionId'] as String? ?? '',
        amountEtb: (data['amountEtb'] as num?)?.toDouble() ?? draft.amountEtb,
        receiverName:
            data['receiverName'] as String? ?? draft.receiverName,
        destination: data['destination'] as String? ?? draft.destination,
        message: data['message'] as String? ?? 'Transfer completed',
      );
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }
}
