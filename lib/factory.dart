import 'package:massa/massa.dart';
import 'package:dusa/constants.dart';
import 'package:dusa/tokens.dart';
import 'package:dusa/service/grpc_service.dart';

class Factory {
  final bool isBuildnet;
  final Account account;
  late GrpcService grpc;
  Factory(this.account, {this.isBuildnet = true}) {
    grpc = GrpcServiceImpl(isBuildnet);
  }

  Future<(int, String, bool, bool)> getAllLBPairs(TokenName token1, TokenName token2) async {
    final params = Args();
    params.addString(getTokenAddress(token1, isBuildnet));
    params.addString(getTokenAddress(token2, isBuildnet));

    const targetFunction = "getAllLBPairs";
    const smartContracAddress = BuildnetConstants.factoryAddress;
    final response = await grpc.scReadOnlyCall(
        maximumGas: CommonConstants.minimumFee,
        smartContracAddress: smartContracAddress,
        functionName: targetFunction,
        functionParameters: params.serialise(),
        callerAddress: account.address());
    await grpc.close();

    final responseArg = Args(initialData: response);
    final binStep = responseArg.nextU32();
    final lBPair = responseArg.nextString();
    final createdByOwner = responseArg.nextBool();
    final isBlacklisted = responseArg.nextBool();
    return (binStep, lBPair, createdByOwner, isBlacklisted);
  }

  /// getPairInformation returns bin information including bin steps and LBPair address
  Future<(int, String, bool, bool)> getPairInformation(TokenName token1, TokenName token2, int binSteps) async {
    final params = Args();
    params.addString(getTokenAddress(token1, isBuildnet));
    params.addString(getTokenAddress(token2, isBuildnet));
    params.addU32(binSteps);

    const targetFunction = "getLBPairInformation";
    const smartContracAddress = BuildnetConstants.factoryAddress;
    final response = await grpc.scReadOnlyCall(
        maximumGas: CommonConstants.minimumFee,
        smartContracAddress: smartContracAddress,
        functionName: targetFunction,
        functionParameters: params.serialise(),
        callerAddress: account.address());
    //await grpc.close();

    final responseArg = Args(initialData: response);
    final binStep = responseArg.nextU32();
    final lBPair = responseArg.nextString();
    final createdByOwner = responseArg.nextBool();
    final isBlacklisted = responseArg.nextBool();
    return (binStep, lBPair, createdByOwner, isBlacklisted);
  }
}
