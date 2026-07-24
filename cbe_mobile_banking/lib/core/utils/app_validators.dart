/// Input validators for banking forms (mock phase).
abstract final class AppValidators {
  static String? pin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }
    if (value.length != 4 || int.tryParse(value) == null) {
      return 'Enter a 4-digit PIN';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    final parsed = num.tryParse(value.replaceAll(',', ''));
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid amount';
    }
    return null;
  }

  static String? accountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.length < 8) {
      return 'Account number looks too short';
    }
    return null;
  }
}
