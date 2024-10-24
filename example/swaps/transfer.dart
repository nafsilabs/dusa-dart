// Package imports:
// ignore_for_file: dead_code

import 'package:dusa/service/grpc_service.dart';
import 'package:massa/massa.dart';
import 'package:dusa/env/env.dart';

void main() async {
  final isBuildnet = false;
  final wallet = Wallet();
  final account = await wallet.addAccountFromSecretKey(
      Env.privateKey, AddressType.user, isBuildnet ? NetworkType.BUILDNET : NetworkType.MAINNET);
  final grpc = GrpcServiceImpl(account: account, isBuildnet: isBuildnet);

  final transferAmount = 0.5;
  final recipientAddress = "AU1ZsnNYP6jsPWZ1YJ1u3eBv49vkbW7q7FayycMsfML3UFVmYTL";

  final (op, isTransfer) = await grpc.transfer(
      account: account, recipientAddress: recipientAddress, amount: transferAmount, fee: minimumFee);
  print('transfer op: $op');
  print('is transfered: $isTransfer');
}
