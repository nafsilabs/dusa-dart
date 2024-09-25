// Package imports:

// ignore_for_file: unrelated_type_equality_checks

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
  /// read only smart contract call
  Future<Uint8List> scReadOnlyCall(
      {required double maximumGas,
      required String smartContracAddress,
      required String functionName,
      required Uint8List functionParameters,
      required String callerAddress});

  Future<(String, bool)> scCall(
      {required Account account,
      required double fee,
      required double maximumGas,
      required double coins,
      required String smartContracAddress,
      required String functionName,
      required Uint8List functionParameters});
  Future<void> close();
}

class GrpcServiceImpl implements GrpcService {
  final bool isBuildnet;
  late GRPCPublicClient _grpc;

  GrpcServiceImpl(this.isBuildnet) {
    final host = isBuildnet ? Env.grpcBuildnetHost : Env.grpcMainnetHost;
    _grpc = GRPCPublicClient(host, Env.grpcPort);
  }

  @override
  Future<Uint8List> scReadOnlyCall(
      {required double maximumGas,
      required String smartContracAddress,
      required String functionName,
      required Uint8List functionParameters,
      required String callerAddress}) async {
    try {
      final fee = minimumFee;
      final response = await _grpc.executeReadOnlyCall(
          fee, maximumGas, smartContracAddress, functionName, functionParameters,
          callerAddress: callerAddress);
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

  Future<void> close() async {
    await _grpc.close();
  }
}
