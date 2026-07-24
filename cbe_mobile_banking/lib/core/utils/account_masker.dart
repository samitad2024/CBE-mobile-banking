/// Account masking — show only safe prefix/suffix. Never log full numbers.
abstract final class AccountMasker {
  /// e.g. 1000582007601 → 1000 ******** 7601
  static String mask(String accountNumber, {int visibleStart = 4, int visibleEnd = 4}) {
    final cleaned = accountNumber.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.length <= visibleStart + visibleEnd) {
      return '*' * cleaned.length;
    }
    final start = cleaned.substring(0, visibleStart);
    final end = cleaned.substring(cleaned.length - visibleEnd);
    return '$start ******** $end';
  }
}
