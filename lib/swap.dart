import 'package:dusa/tokens.dart';
import 'package:massa/massa.dart';
import 'package:dusa/constants.dart';
import 'package:dusa/service/grpc_service.dart';

class Swap {
  final GrpcServiceImpl grpc;
  Swap(this.grpc);

  /// getSwapIn  evaluates the input amount of coin and fee needed to obtain the given output amount of coins

  Future<(BigInt, BigInt)> getSwapIn(String pairAddress, BigInt amountOut, bool swapForY) async {
    final params = Args();
    params.addString(pairAddress);
    params.addU256(amountOut);
    params.addBool(swapForY);
    const targetFunction = "getSwapIn";
    final functionParameters = params.serialise();
    const maximumGas = GasLimit.MAX_GAS_CALL;
    final smartContracAddress = grpc.isBuildnet ? BuildnetConstants.routerAddress : MainnetConstants.routerAddress;

    final response = await grpc.scReadOnlyCall(
      maximumGas: maximumGas.value / 1e9,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );
    //await grpc.close();

    final responseArg = Args(initialData: response);
    final amountIn = responseArg.nextU256();
    final feesIn = responseArg.nextU256();
    return (amountIn, feesIn);
  }

  /// getSwapOut  evaluates the output amount of coin and fee needed to obtain the given input amount of coins
  Future<(BigInt, BigInt)> getSwapOut(String pairAddress, BigInt amountIn, bool swapForY) async {
    final params = Args();
    params.addString(pairAddress);
    params.addU256(amountIn);
    params.addBool(swapForY);
    const targetFunction = "getSwapOut";
    final functionParameters = params.serialise();
    const maximumGas = 1.0;
    final smartContracAddress = grpc.isBuildnet ? BuildnetConstants.routerAddress : MainnetConstants.routerAddress;

    final response = await grpc.scReadOnlyCall(
      maximumGas: maximumGas,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );

    final responseArg = Args(initialData: response);
    final amountOut = responseArg.nextU256();
    final feesIn = responseArg.nextU256();
    return (amountOut, feesIn);
  }

  /// swapExactMASForTokens swaps exact amount of input MAS coins to a specified output token
  Future<(String, bool)> swapExactMASForTokens(BigInt amountIn, BigInt amountOut, List<dynamic> binSteps,
      List<dynamic> tokenPath, String toAddress, int deadline) async {
    final deadline2 = BigInt.from(DateTime.timestamp().millisecondsSinceEpoch + deadline);
    final storageCost = 0.1;
    final params = Args();
    params.addU256(amountOut);
    params.addArray(binSteps, ArrayTypes.U64);
    params.addArray(tokenPath, ArrayTypes.STRING);
    params.addString(toAddress);
    params.addU64(deadline2);
    params.addU64(fromMAS(storageCost)); //storage cost 0.1 MAS

    const targetFunction = "swapExactMASForTokens";
    final functionParameters = params.serialise();
    final maximumGas = toMAS(BigInt.from(GasLimit.MAX_GAS_CALL.value));
    final smartContracAddress = grpc.isBuildnet ? BuildnetConstants.routerAddress : MainnetConstants.routerAddress;
    final coins = toMAS(amountIn) + storageCost;
    return await grpc.scCall(
      account: grpc.account,
      fee: minimumFee,
      coins: coins,
      maximumGas: maximumGas,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );
  }

  /// swapTokensForExactMAS swaps specified input amount of coins to an exact output ammount of MAS coins

  Future<(String, bool)> swapTokensForExactMAS(BigInt amountIn, BigInt amountOut, List<dynamic> binSteps,
      List<dynamic> tokenPath, String toAddress, int deadline) async {
    final deadline2 = BigInt.from(DateTime.timestamp().millisecondsSinceEpoch + deadline);
    final storageCost = 0.1;
    final params = Args();
    params.addU256(amountOut);
    params.addU256(amountIn);
    params.addArray(binSteps, ArrayTypes.U64);
    params.addArray(tokenPath, ArrayTypes.STRING);
    params.addString(toAddress);
    params.addU64(deadline2);

    const targetFunction = "swapTokensForExactMAS";
    final functionParameters = params.serialise();
    final maximumGas = toMAS(BigInt.from(GasLimit.MAX_GAS_CALL.value));
    final smartContracAddress = grpc.isBuildnet ? BuildnetConstants.routerAddress : MainnetConstants.routerAddress;
    final coins = storageCost;
    return await grpc.scCall(
      account: grpc.account,
      fee: minimumFee,
      coins: coins,
      maximumGas: maximumGas,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );
  }

  /// wrap wraps MAS coin to WMAS

  Future<(String, bool)> wrap(double amount) async {
    final params = Args();
    const targetFunction = "deposit";
    final functionParameters = params.serialise();
    final maximumGas = toMAS(BigInt.from(GasLimit.MAX_GAS_CALL.value));
    final smartContracAddress = getTokenAddress(TokenName.WMAS, grpc.isBuildnet);
    return await grpc.scCall(
      account: grpc.account,
      fee: minimumFee,
      coins: amount,
      maximumGas: maximumGas,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );
  }

  /// wrap wraps MAS coin to WMAS

  Future<(String, bool)> uwrap(double amount) async {
    final params = Args();
    const targetFunction = "withdraw";
    final functionParameters = params.serialise();
    final maximumGas = toMAS(BigInt.from(GasLimit.MAX_GAS_CALL.value));
    final smartContracAddress = getTokenAddress(TokenName.WMAS, grpc.isBuildnet);
    return await grpc.scCall(
      account: grpc.account,
      fee: minimumFee,
      coins: amount,
      maximumGas: maximumGas,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );
  }
}
