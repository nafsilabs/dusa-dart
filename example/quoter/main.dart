// Package imports:
import 'package:dusa/dusa.dart';
import 'package:dusa/service/grpc_service.dart';
import 'package:massa/massa.dart';

void main() async {
  final wallet = Wallet();
  final account = await wallet.addAccountFromSecretKey(Env.privateKey, AddressType.user, NetworkType.BUILDNET);
  final grpc = GrpcServiceImpl(account: account, isBuildnet: false);
  final quoter = Quoter(grpc);
  final amountIn = doubleToMassaInt(1.00);

  final (route, pair, binSteps, amounts, amountsWithoutSlippage, fees) =
      await quoter.findBestPathFromAmountIn(TokenName.WMAS, TokenName.USDC, BigInt.from(amountIn));
  print('amount in: $amountIn');
  print('route: $route');
  print('pair: $pair');
  print('bin steps: $binSteps');
  final massaAmount = toMAS(amounts[0]);
  final usdcAmount = bigIntToDecimal(amounts[1], getTokenDecimal(TokenName.USDC));
  print('amounts: $amounts => $massaAmount MAS = $usdcAmount USDC');
  print('amounts without slippage: $amountsWithoutSlippage');
  print('fees: $fees');
}
