import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  const SessionModel({
    required this.token,
    required this.customerName,
    required this.accountNumber,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      token: json['token'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
    );
  }

  final String token;
  final String customerName;
  final String accountNumber;

  Map<String, dynamic> toJson() => {
        'token': token,
        'customerName': customerName,
        'accountNumber': accountNumber,
      };

  @override
  List<Object?> get props => [token, customerName, accountNumber];
}
