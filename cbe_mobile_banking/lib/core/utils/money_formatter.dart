/// Money formatting helpers (ETB). Never log raw balances in production logs.
abstract final class MoneyFormatter {
  static String formatEtb(num amount, {bool withCode = true}) {
    final fixed = amount.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = _withSeparators(parts[0]);
    final value = '$whole.${parts[1]}';
    return withCode ? '$value ETB' : value;
  }

  static String _withSeparators(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final reverseIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }
}
