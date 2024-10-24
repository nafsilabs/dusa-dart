// Package imports:
// ignore_for_file: dead_code

import 'package:dusa/service/grpc_service.dart';
import 'package:massa/massa.dart';
import 'package:dusa/swap.dart';
import 'package:dusa/env/env.dart';

void main() async {
  final isBuildnet = false;
  final wallet = Wallet();
  final account = await wallet.addAccountFromSecretKey(
      Env.privateKey, AddressType.user, isBuildnet ? NetworkType.BUILDNET : NetworkType.MAINNET);
  final grpc = GrpcServiceImpl(account: account, isBuildnet: isBuildnet);

  final swap = Swap(grpc);

  final wrapAmount = 0.5;

  final (op, isWrap) = await swap.wrap(wrapAmount);
  print('wrap op: $op');
  print('is wrapped: $isWrap');
}
