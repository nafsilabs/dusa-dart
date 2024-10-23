// Package imports:
// ignore_for_file: dead_code

import 'package:dusa/constants.dart';
import 'package:dusa/helpers.dart';
import 'package:dusa/quoter.dart';
import 'package:dusa/service/grpc_service.dart';
import 'package:dusa/tokens.dart';
import 'package:massa/massa.dart';
import 'package:dusa/swap.dart';
import 'package:dusa/env/env.dart';

void main() async {
  final isBuildnet = false;
  final wallet = Wallet();
  final account = await wallet.addAccountFromSecretKey(
      Env.privateKey, AddressType.user, isBuildnet ? NetworkType.BUILDNET : NetworkType.MAINNET);
  final grpc = GrpcServiceImpl(account: account, isBuildnet: isBuildnet);

  final usdDCtoken = Token(grpc: grpc, token: TokenName.USDC);

  final balance = await usdDCtoken.balanceOf(account.address());
  final balanceUSDC = bigIntToDecimal(balance, getTokenDecimal(TokenName.USDC));
  print('response: $balanceUSDC USDC');
}
