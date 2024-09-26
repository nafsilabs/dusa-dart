import 'dart:math';

/// bigIntToDecimal converts a given big int to decimal number
double bigIntToDecimal(BigInt value, int decimals) {
  return value.toDouble() / pow(10, decimals);
}

/// decimalToBigInt converts a given decimal number to big int
BigInt decimalToBigInt(double value, int decimals) {
  return BigInt.from(value * pow(10, decimals).toInt());
}

/// minimumAmoutOut computes the minimum output amount given the slippage parcentage
double minimumAmoutOut(double amount, double slippageTorrelance,
    {bool isExactOut = false}) {
  if (isExactOut) return amount;
  final slippageAmount = amount.toDouble() * slippageTorrelance / 100.00;
  return amount - slippageAmount;
}

/// maximumAmoutIn computes the maximum input amount given the slippage parcentage
double maximumAmoutIn(double amount, double slippageTorrelance,
    {bool isExactIn = false}) {
  if (isExactIn) return amount;
  final slippageAmount = amount.toDouble() * slippageTorrelance / 100.00;
  return amount + slippageAmount;
}
