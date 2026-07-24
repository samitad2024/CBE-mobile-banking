import 'package:cbe_mobile_banking/features/auth/data/models/session_model.dart';
import 'package:cbe_mobile_banking/features/auth/domain/entities/session_entity.dart';

abstract final class SessionMapper {
  static SessionEntity toEntity(SessionModel model) {
    return SessionEntity(
      token: model.token,
      customerName: model.customerName,
      accountNumber: model.accountNumber,
    );
  }
}
