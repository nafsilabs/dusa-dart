// Package imports:
import 'package:dusa/helpers.dart';
import 'package:massa/massa.dart';
import 'package:dusa/quoter.dart';
import 'package:dusa/tokens.dart';
import 'package:dusa/env/env.dart';

void main() async {
  final wallet = Wallet();
  final account = await wallet.addAccountFromSecretKey(Env.privateKey, AddressType.user, NetworkType.BUILDNET);
  final quoter = Quoter(account);

  // final grpc = GRPCPublicClient(Env.grpcHost, Env.grpcPort);
  // final status = await grpc.getStakers();
  // print(status);
  // grpc.close();

  final amountIn = doubleToMassaInt(200.00);

  final (route, pair, binSteps, amounts, amountsWithoutSlippage, fees) =
      await quoter.findBestPathFromAmountIn(TokenName.WMAS, TokenName.USDC, BigInt.from(amountIn));
  print('amount in: $amountIn');
  print('route: $route');
  print('pair: $pair');
  print('bin steps: $binSteps');
  print(
      'amounts: $amounts => ${toMAS(amounts[0])} MAS = ${bigIntToDecimal(amounts[1], getTokenDecimal(TokenName.USDC))} USDC');
  print('amounts without slippage: $amountsWithoutSlippage');
  print('fees: $fees');

  // final (route2, pair2, binSteps2, amounts2, amountsWithoutSlippage2, fees2) =
  //     await quoter.findBestPathFromAmountOut(TokenName.WMAS, TokenName.USDC, amounts[1]);
  // print('amount in: $amountIn');
  // print('route: $route2');
  // print('pair: $pair2');
  // print('bin steps: $binSteps2');
  // print(
  //     'amounts: $amounts2 => ${toMAS(amounts2[0])} MAS = ${bigIntToDecimal(amounts2[1], getTokenDecimal(TokenName.USDC))} USDC');
  // print('amounts without slippage: $amountsWithoutSlippage');
  // print('fees: $fees2');
  print("");
  final (route2, pair2, binSteps2, amounts2, amountsWithoutSlippage2, fees2) =
      await quoter.findBestPathFromAmountIn(TokenName.WETH, TokenName.USDC, BigInt.from(amountIn));
  print('amount in: $amountIn');
  print('route: $route2');
  print('pair: $pair2');
  print('bin steps: $binSteps2');
  print(
      'amounts: $amounts2 => ${bigIntToDecimal(amounts2[0], getTokenDecimal(TokenName.USDC))} USDC = ${bigIntToDecimal(amounts2[1], getTokenDecimal(TokenName.WETH))} WETH');
  print('amounts without slippage: $amountsWithoutSlippage2');
  print('fees: $fees2');
}
