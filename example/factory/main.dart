// Package imports:
import 'package:dusa/factory.dart';
import 'package:dusa/service/grpc_service.dart';
import 'package:massa/massa.dart';
import 'package:dusa/tokens.dart';
import 'package:dusa/env/env.dart';

void main() async {
  final wallet = Wallet();
  final account = await wallet.addAccountFromSecretKey(Env.privateKey, AddressType.user, NetworkType.BUILDNET);
  final grpc = GrpcServiceImpl(account: account, isBuildnet: false);
  final factory = Factory(grpc);
  final token1 = TokenName.WMAS;
  final token2 = TokenName.USDC;
  final token3 = TokenName.WETH;
  final usdcBinStep = 20;
  final (binSteps1, lBPair1, createdByOwner1, isBlacklisted1) =
      await factory.getPairInformation(token1, token2, usdcBinStep);
  print('token information for WMAS/USDC');
  print('bin steps: $binSteps1');
  print('LBPair: $lBPair1');
  print('created by Owner: $createdByOwner1');
  print('isBlacklisted: $isBlacklisted1');

  final (binSteps2, lBPair2, createdByOwner2, isBlacklisted2) = await factory.getAllLBPairs(token1, token3);
  print('token information for WMAS/WETH');
  print('bin steps: $binSteps2');
  print('LBPair: $lBPair2');
  print('created by Owner: $createdByOwner2');
  print('isBlacklisted: $isBlacklisted2');
}
