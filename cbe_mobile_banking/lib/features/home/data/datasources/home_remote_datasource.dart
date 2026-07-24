import 'package:cbe_mobile_banking/core/error/exceptions.dart';
import 'package:cbe_mobile_banking/core/network/dio_client.dart';
import 'package:cbe_mobile_banking/core/network/dio_exception_mapper.dart';
import 'package:cbe_mobile_banking/features/home/data/datasources/home_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:dio/dio.dart';

class HomeRemoteDataSourceImpl implements HomeDataSource {
  HomeRemoteDataSourceImpl({required DioClient dioClient})
      : _dio = dioClient.dio;

  final Dio _dio;

  @override
  Future<HomeDashboardEntity> fetchDashboard() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/home');
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty home response');
      }
      return _mapDashboard(data);
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }

  HomeDashboardEntity _mapDashboard(Map<String, dynamic> json) {
    final accountJson = json['account'] as Map<String, dynamic>? ?? {};
    final recipientsJson = json['recentRecipients'] as List<dynamic>? ?? [];
    return HomeDashboardEntity(
      account: AccountSummaryEntity(
        customerName: accountJson['customerName'] as String? ?? '',
        accountNumber: accountJson['accountNumber'] as String? ?? '',
        balanceEtb: (accountJson['balanceEtb'] as num?)?.toDouble() ?? 0,
        updatedAt: DateTime.tryParse(accountJson['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      ),
      recentRecipients: recipientsJson
          .whereType<Map<String, dynamic>>()
          .map(
            (r) => RecentRecipientEntity(
              initial: r['initial'] as String? ?? '?',
              lastFour: r['lastFour'] as String? ?? '',
              fullName: r['fullName'] as String? ?? '',
              accountNumber: r['accountNumber'] as String? ?? '',
            ),
          )
          .toList(),
      pendingRequestCount: json['pendingRequestCount'] as int? ?? 0,
    );
  }
}
