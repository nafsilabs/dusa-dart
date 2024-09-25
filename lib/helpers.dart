import 'dart:math';

double bigIntToDecimal(BigInt value, int decimals) {
  return value.toDouble() / pow(10, decimals);
}

BigInt decimalToBigInt(double value, int decimals) {
  return BigInt.from(value * pow(10, decimals).toInt());
}

double minimumAmoutOut(double amount, double slippageTorrelance, {bool isExactOut = false}) {
  if (isExactOut) return amount;
  final slippageAmount = amount.toDouble() * slippageTorrelance / 100.00;
  return amount - slippageAmount;
}

double maximumAmoutIn(double amount, double slippageTorrelance, {bool isExactIn = false}) {
  if (isExactIn) return amount;
  final slippageAmount = amount.toDouble() * slippageTorrelance / 100.00;
  return amount + slippageAmount;
}
