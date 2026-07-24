import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/network/dio_client.dart';
import 'package:cbe_mobile_banking/core/network/dio_exception_mapper.dart';
import 'package:cbe_mobile_banking/features/transactions/data/datasources/transactions_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dio/dio.dart';

class TransactionsRemoteDataSourceImpl implements TransactionsDataSource {
  TransactionsRemoteDataSourceImpl({required DioClient dioClient})
      : _dio = dioClient.dio;

  final Dio _dio;

  @override
  Future<List<TransactionEntity>> fetchTransactions() async {
    try {
      final response = await _dio.get<List<dynamic>>('/v1/transactions');
      final data = response.data ?? const [];
      return data.whereType<Map<String, dynamic>>().map(_mapTxn).toList();
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }

  @override
  Future<ReceiptEntity> fetchReceipt(String id) async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>('/v1/transactions/$id/receipt');
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty receipt response');
      }
      return ReceiptEntity(
        transactionNumber: data['transactionNumber'] as String? ?? '',
        amountEtb: (data['amountEtb'] as num?)?.toDouble() ?? 0,
        receiverName: data['receiverName'] as String? ?? '',
        receiverNumber: data['receiverNumber'] as String? ?? '',
      );
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }

  TransactionEntity _mapTxn(Map<String, dynamic> json) {
    final direction = (json['direction'] as String?) == 'credit'
        ? TransactionDirection.credit
        : TransactionDirection.debit;
    return TransactionEntity(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      amountEtb: (json['amountEtb'] as num?)?.toDouble() ?? 0,
      direction: direction,
      occurredAt:
          DateTime.tryParse(json['occurredAt'] as String? ?? '') ??
              DateTime.now(),
      partnerLabel: json['partnerLabel'] as String?,
    );
  }
}
