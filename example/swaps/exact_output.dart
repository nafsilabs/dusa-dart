// Package imports:
// ignore_for_file: dead_code

import 'package:dusa/constants.dart';
import 'package:dusa/helpers.dart';
import 'package:dusa/quoter.dart';
import 'package:dusa/tokens.dart';
import 'package:massa/massa.dart';
import 'package:dusa/swap.dart';
import 'package:dusa/env/env.dart';

void main() async {
  final isBuildnet = false;
  final wallet = Wallet();
  final account = await wallet.addAccountFromSecretKey(
      Env.privateKey, AddressType.user, isBuildnet ? NetworkType.BUILDNET : NetworkType.MAINNET);
  final swap = Swap(account, isBuildnet: isBuildnet);
  final quoter = Quoter(account, isBuildnet: isBuildnet);

  final amountOut = doubleToMassaInt(1.0);

// 0.1 USDC to 10 MAS to
  final (route, pair, binSteps, amounts, amountsWithoutSlippage, fees) =
      await quoter.findBestPathFromAmountOut(TokenName.USDC, TokenName.WMAS, BigInt.from(amountOut));
  print('amount out: $amountOut');
  print('route: $route');
  print('pair: $pair');
  print('bin steps: $binSteps');
  final amountIn = bigIntToDecimal(amounts[0], getTokenDecimal(TokenName.USDC));
  final amountInWithSlippage = maximumAmoutIn(amountIn, 0.5);
  final amountBigInt = decimalToBigInt(amountInWithSlippage, getTokenDecimal(TokenName.USDC));

  print(
      'amounts: $amounts => ${toMAS(amounts[1])} MAS = ${bigIntToDecimal(amounts[0], getTokenDecimal(TokenName.USDC))} USDC => ${bigIntToDecimal(amountBigInt, getTokenDecimal(TokenName.USDC))} USDC');

  final token = Token(account, TokenName.USDC, isBuildnet: isBuildnet);
  await token.increaseAllowance(amountBigInt);
  final result = await swap.swapTokensForExactMAS(
      amountBigInt, amounts[1], binSteps, route, account.address(), CommonConstants.txDeadline);
  print('response: $result');
  print("");

  // 10 MAS to WETH
  // final (route2, pair2, binSteps2, amounts2, amountsWithoutSlippage2, fees2) =
  //     await quoter.findBestPathFromAmountOut(TokenName.WETH, TokenName.WMAS, BigInt.from(amountOut));
  // print('amount out: $amountOut');
  // print('route: $route2');
  // print('pair: $pair2');
  // print('bin steps: $binSteps2');
  // final amountIn2 = bigIntToDecimal(amounts2[0], getTokenDecimal(TokenName.WETH));
  // final amountInWithSlippage2 = maximumAmoutIn(amountIn2, 0.5);
  // final amountBigInt2 = decimalToBigInt(amountInWithSlippage2, getTokenDecimal(TokenName.WETH));

  // print(
  //     'amounts: $amounts2 => ${toMAS(amounts2[1])} MAS = ${bigIntToDecimal(amounts2[0], getTokenDecimal(TokenName.WETH))} WETH => ${bigIntToDecimal(amountBigInt2, getTokenDecimal(TokenName.WETH))} WETH');
  // final result2 = await swap.swapTokensForExactMAS(
  //     amountBigInt2, amounts2[1], binSteps2, route2, account.address(), CommonConstants.txDeadline);
  // print('response: $result2');
}
