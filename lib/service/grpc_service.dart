// Package imports:

// ignore_for_file: unrelated_type_equality_checks, implementation_imports

// Flutter imports:
import 'dart:async';
import 'dart:typed_data';

// Package imports:
import 'package:dusa/constants.dart';
import 'package:massa/massa.dart';
import 'package:massa/src/grpc/generated/public.pbgrpc.dart';

// Project imports:
import 'package:dusa/env/env.dart';

abstract interface class GrpcService {
  /// scReadOnlyCall reads only smart contracts
  Future<Uint8List> scReadOnlyCall({
    required double maximumGas,
    required String smartContracAddress,
    required String functionName,
    required Uint8List functionParameters,
  });

  /// scCall executes smart contract
  Future<(String, bool)> scCall(
      {required Account account,
      required double fee,
      required double maximumGas,
      required double coins,
      required String smartContracAddress,
      required String functionName,
      required Uint8List functionParameters});

  /// transfer coins from the account address to the a recipient address

  Future<(String, bool)> transfer(
      {required Account account, required String recipientAddress, required double amount, required double fee});
  Future<void> close();
}

class GrpcServiceImpl implements GrpcService {
  late Account account;
  late bool isBuildnet;
  late GRPCPublicClient _grpc;

  GrpcServiceImpl({required this.account, required this.isBuildnet}) {
    final host = isBuildnet ? Env.grpcBuildnetHost : Env.grpcMainnetHost;
    _grpc = GRPCPublicClient(host, Env.grpcPort);
  }

  @override
  Future<Uint8List> scReadOnlyCall({
    required double maximumGas,
    required String smartContracAddress,
    required String functionName,
    required Uint8List functionParameters,
  }) async {
    try {
      final fee = minimumFee;
      final response = await _grpc.executeReadOnlyCall(
          fee, maximumGas, smartContracAddress, functionName, functionParameters,
          callerAddress: account.address());
      return Uint8List.fromList(response.callResult);
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<(String, bool)> scCall(
      {required Account account,
      required double fee,
      required double maximumGas,
      required double coins,
      required String smartContracAddress,
      required String functionName,
      required Uint8List functionParameters}) async {
    try {
      final status = await _grpc.getStatus();
      final expirePeriod = status.lastExecutedFinalSlot.period + status.config.operationValidityPeriods;
      final operation = await callSC(
          account, smartContracAddress, functionName, functionParameters, fee, maximumGas, coins, expirePeriod.toInt());
      String operationID = "";
      await for (final resp in _grpc.sendOperations([operation])) {
        if (resp.operationIds.operationIds.isEmpty) {
          return (operationID, false);
        }
        operationID = resp.operationIds.operationIds[0];
        final status = await waitForFinalOperationStatus(operationID);
        return (operationID, status);
      }
      return (operationID, false);
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<(String, bool)> transfer({
    required Account account,
    required String recipientAddress,
    required double amount,
    required double fee,
  }) async {
    try {
      final status = await _grpc.getStatus();
      final expirePeriod = status.lastExecutedFinalSlot.period + status.config.operationValidityPeriods;
      final operation = await sendTransaction(account, recipientAddress, amount, fee, expirePeriod.toInt());
      String operationID = "";
      await for (final resp in _grpc.sendOperations([operation])) {
        if (resp.operationIds.operationIds.isEmpty) {
          return (operationID, false);
        }
        operationID = resp.operationIds.operationIds[0];
        final status = await waitForFinalOperationStatus(operationID);
        return (operationID, status);
      }
      return (operationID, false);
    } catch (error) {
      throw Exception(error);
    }
  }

  /// waitForFinalOperationStatus waits for operation to be final
  Future<bool> waitForFinalOperationStatus(String operationID) async {
    bool timeoutReached = false;
    Timer timeoutTimer = Timer(CommonConstants.waitOperationTimeout, () {
      timeoutReached = true;
    });

    final filter =
        NewSlotExecutionOutputsFilter(executedOpsChangesFilter: ExecutedOpsChangesFilter(operationId: operationID));
    await for (var resp in _grpc.newSlotExecutionOutputs(filters: [filter])) {
      if (resp.status == ExecutionOutputStatus.EXECUTION_OUTPUT_STATUS_FINAL) {
        timeoutTimer.cancel();
        return true;
      }
      if (timeoutReached) {
        timeoutTimer.cancel();
        return false;
      }
    }

    timeoutTimer.cancel();
    return false;
  }

  @override
  Future<void> close() async {
    await _grpc.close();
  }
}
