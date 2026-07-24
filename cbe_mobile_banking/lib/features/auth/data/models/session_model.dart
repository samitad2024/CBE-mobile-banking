import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  const SessionModel({
    required this.token,
    required this.customerName,
    required this.accountNumber,
  });

  final String token;
  final String customerName;
  final String accountNumber;

  @override
  List<Object?> get props => [token, customerName, accountNumber];
}
