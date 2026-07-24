import 'package:cbe_mobile_banking/core/network/dio_client.dart';
import 'package:cbe_mobile_banking/core/security/biometric_gateway.dart';
import 'package:cbe_mobile_banking/core/security/biometric_gateway_impl.dart';
import 'package:cbe_mobile_banking/core/security/in_memory_secure_storage_gateway.dart';
import 'package:cbe_mobile_banking/core/security/mock_biometric_gateway.dart';
import 'package:cbe_mobile_banking/core/security/screen_security_gateway.dart';
import 'package:cbe_mobile_banking/core/security/secure_config.dart';
import 'package:cbe_mobile_banking/core/security/secure_storage_gateway.dart';
import 'package:cbe_mobile_banking/core/security/secure_storage_gateway_impl.dart';
import 'package:cbe_mobile_banking/core/security/session_manager.dart';
import 'package:cbe_mobile_banking/core/utils/app_logger.dart';
import 'package:cbe_mobile_banking/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cbe_mobile_banking/features/auth/data/repositories/session_repository_impl.dart';
import 'package:cbe_mobile_banking/features/auth/domain/repositories/auth_repository.dart';
import 'package:cbe_mobile_banking/features/auth/domain/repositories/session_repository.dart';
import 'package:cbe_mobile_banking/features/auth/domain/usecases/login_with_biometrics_usecase.dart';
import 'package:cbe_mobile_banking/features/auth/domain/usecases/login_with_pin_usecase.dart';
import 'package:cbe_mobile_banking/features/auth/domain/usecases/session_usecases.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/app_lock_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cbe_mobile_banking/features/auth/presentation/bloc/auth_session_bloc.dart';
import 'package:cbe_mobile_banking/features/home/data/datasources/home_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/home/data/repositories/home_repository_impl.dart';
import 'package:cbe_mobile_banking/features/home/domain/repositories/home_repository.dart';
import 'package:cbe_mobile_banking/features/home/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:cbe_mobile_banking/features/home/presentation/bloc/home_bloc.dart';
import 'package:cbe_mobile_banking/features/request_money/data/datasources/request_money_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/request_money/data/repositories/request_money_repository_impl.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/repositories/request_money_repository.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/usecases/create_payment_request_usecase.dart';
import 'package:cbe_mobile_banking/features/request_money/domain/usecases/get_pending_requests_usecase.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/request_money_bloc.dart';
import 'package:cbe_mobile_banking/features/request_money/presentation/bloc/requests_inbox_bloc.dart';
import 'package:cbe_mobile_banking/features/scan/presentation/bloc/scan_bloc.dart';
import 'package:cbe_mobile_banking/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:cbe_mobile_banking/features/transactions/data/datasources/transactions_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:cbe_mobile_banking/features/transactions/domain/usecases/transactions_usecases.dart';
import 'package:cbe_mobile_banking/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:cbe_mobile_banking/features/transfer/data/datasources/transfer_mock_datasource.dart';
import 'package:cbe_mobile_banking/features/transfer/data/repositories/transfer_repository_impl.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:cbe_mobile_banking/features/transfer/domain/usecases/submit_transfer_usecase.dart';
import 'package:cbe_mobile_banking/features/transfer/presentation/bloc/transfer_bloc.dart';
import 'package:cbe_mobile_banking/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:get_it/get_it.dart';

/// Global service locator — all feature BLoCs registered as factories.
final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (sl.isRegistered<DioClient>()) {
    return;
  }

  _registerCore();
  _registerAuth();
  _registerHome();
  _registerTransfer();
  _registerRequestMoney();
  _registerTransactions();
  _registerScanWalletSettings();
  AppLogger.d('Dependencies configured (full BLoC graph)');
}

void _registerCore() {
  sl
    ..registerLazySingleton<DioClient>(DioClient.new)
    ..registerLazySingleton<SessionManager>(MockSessionManager.new);

  if (SecureConfig.isMock) {
    sl
      ..registerLazySingleton<SecureStorageGateway>(
        InMemorySecureStorageGateway.new,
      )
      ..registerLazySingleton<BiometricGateway>(MockBiometricGateway.new);
  } else {
    sl
      ..registerLazySingleton<SecureStorageGateway>(
        SecureStorageGatewayImpl.new,
      )
      ..registerLazySingleton<BiometricGateway>(BiometricGatewayImpl.new);
  }

  // FLAG_SECURE channel; no-ops when plugin/channel unavailable (tests/desktop).
  sl.registerLazySingleton<ScreenSecurityGateway>(ScreenSecurityGatewayImpl.new);
}

void _registerAuth() {
  sl
    ..registerLazySingleton<AuthMockDataSource>(
      () => AuthMockDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        mockDataSource: sl(),
        sessionManager: sl(),
      ),
    )
    ..registerLazySingleton<SessionRepository>(
      () => SessionRepositoryImpl(
        secureStorage: sl(),
        sessionManager: sl(),
      ),
    )
    ..registerLazySingleton(() => LoginWithPinUseCase(sl()))
    ..registerLazySingleton(() => LoginWithBiometricsUseCase(sl()))
    ..registerLazySingleton(() => RestoreSessionUseCase(sl()))
    ..registerLazySingleton(() => PersistSessionUseCase(sl()))
    ..registerLazySingleton(() => ClearSessionUseCase(sl()))
    ..registerLazySingleton(
      () => AuthSessionBloc(
        restoreSession: sl(),
        persistSession: sl(),
        clearSession: sl(),
      ),
    )
    ..registerLazySingleton(AppLockBloc.new)
    ..registerFactory(
      () => AuthBloc(
        loginWithPin: sl(),
        loginWithBiometrics: sl(),
      ),
    );
}

void _registerHome() {
  sl
    ..registerLazySingleton<HomeMockDataSource>(HomeMockDataSourceImpl.new)
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(mockDataSource: sl()),
    )
    ..registerLazySingleton(() => GetHomeDashboardUseCase(sl()))
    ..registerFactory(() => HomeBloc(getHomeDashboard: sl()));
}

void _registerTransfer() {
  sl
    ..registerLazySingleton<TransferMockDataSource>(
      TransferMockDataSourceImpl.new,
    )
    ..registerLazySingleton<TransferRepository>(
      () => TransferRepositoryImpl(mockDataSource: sl()),
    )
    ..registerLazySingleton(() => SubmitTransferUseCase(sl()))
    ..registerFactory(() => TransferBloc(submitTransfer: sl()));
}

void _registerRequestMoney() {
  sl
    ..registerLazySingleton<RequestMoneyMockDataSource>(
      RequestMoneyMockDataSourceImpl.new,
    )
    ..registerLazySingleton<RequestMoneyRepository>(
      () => RequestMoneyRepositoryImpl(mockDataSource: sl()),
    )
    ..registerLazySingleton(() => CreatePaymentRequestUseCase(sl()))
    ..registerLazySingleton(() => GetPendingRequestsUseCase(sl()))
    ..registerFactory(
      () => RequestMoneyBloc(createPaymentRequest: sl()),
    )
    ..registerFactory(
      () => RequestsInboxBloc(getPendingRequests: sl()),
    );
}

void _registerTransactions() {
  sl
    ..registerLazySingleton<TransactionsMockDataSource>(
      TransactionsMockDataSourceImpl.new,
    )
    ..registerLazySingleton<TransactionsRepository>(
      () => TransactionsRepositoryImpl(mockDataSource: sl()),
    )
    ..registerLazySingleton(() => GetTransactionsUseCase(sl()))
    ..registerLazySingleton(() => GetReceiptUseCase(sl()))
    ..registerFactory(
      () => TransactionsBloc(
        getTransactions: sl(),
        getReceipt: sl(),
      ),
    );
}

void _registerScanWalletSettings() {
  sl
    ..registerFactory(ScanBloc.new)
    ..registerFactory(WalletBloc.new)
    ..registerFactory(SettingsBloc.new);
}

/// Resets GetIt — for tests only.
Future<void> resetDependencies() async {
  await sl.reset();
}
