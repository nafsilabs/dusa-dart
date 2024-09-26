// ignore_for_file: dead_code

import 'package:dusa/constants.dart';
import 'package:dusa/helpers.dart';
import 'package:dusa/quoter.dart';
import 'package:dusa/tokens.dart';
import 'package:massa/massa.dart';
import 'package:dusa/swap.dart';
import 'package:dusa/env/env.dart';

void main() async {
  final isBuildnet = true;
  final wallet = Wallet();
  final account = await wallet.addAccountFromSecretKey(
      Env.privateKey, AddressType.user, isBuildnet ? NetworkType.BUILDNET : NetworkType.MAINNET);
  final swap = Swap(account, isBuildnet: isBuildnet);
  final quoter = Quoter(account, isBuildnet: isBuildnet);

  final amountIn = doubleToMassaInt(2.00);

// swap exact 2 MAS to USDC
  final (route, pair, binSteps, amounts, amountsWithoutSlippage, fees) =
      await quoter.findBestPathFromAmountIn(TokenName.WMAS, TokenName.USDC, BigInt.from(amountIn));
  print('amount in: $amountIn');
  print('route: $route');
  print('pair: $pair');
  print('bin steps: $binSteps');
  final amountOut = bigIntToDecimal(amounts[1], getTokenDecimal(TokenName.USDC));
  final amountOutWithSlippage = minimumAmoutOut(amountOut, 0.5);
  final amountBigInt = decimalToBigInt(amountOutWithSlippage, getTokenDecimal(TokenName.USDC));

  print(
      'amounts: $amounts => ${toMAS(amounts[0])} MAS = ${bigIntToDecimal(amounts[1], getTokenDecimal(TokenName.USDC))} USDC => ${bigIntToDecimal(amountBigInt, getTokenDecimal(TokenName.USDC))} USDC');
  final result = await swap.swapExactMASForTokens(
      amounts[0], amountBigInt, binSteps, route, account.address(), CommonConstants.txDeadline);
  print('response: $result');
  print("");

  // swap exact 102 MAS to WETH
  final (route2, pair2, binSteps2, amounts2, amountsWithoutSlippage2, fees2) =
      await quoter.findBestPathFromAmountIn(TokenName.WMAS, TokenName.WETH, BigInt.from(amountIn));
  print('amount in: $amountIn');
  print('route: $route');
  print('pair: $pair');
  print('bin steps: $binSteps');
  final amountOut2 = bigIntToDecimal(amounts2[1], getTokenDecimal(TokenName.WETH));
  final amountOutWithSlippage2 = minimumAmoutOut(amountOut2, 0.5);
  final amountBigInt2 = decimalToBigInt(amountOutWithSlippage2, getTokenDecimal(TokenName.WETH));

  print(
      'amounts: $amounts2 => ${toMAS(amounts2[0])} MAS = ${bigIntToDecimal(amounts2[1], getTokenDecimal(TokenName.WETH))} WETH => ${bigIntToDecimal(amountBigInt2, getTokenDecimal(TokenName.WETH))} WETH');
  final result2 = await swap.swapExactMASForTokens(
      amounts2[0], amountBigInt2, binSteps2, route2, account.address(), CommonConstants.txDeadline);
  print('response: $result2');
}
