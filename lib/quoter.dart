import 'package:massa/massa.dart';
import 'package:dusa/constants.dart';
import 'package:dusa/tokens.dart';
import 'package:dusa/service/grpc_service.dart';

class Quoter {
  late GrpcService grpc;
  final bool isBuildnet;
  final Account account;
  Quoter(this.account, {this.isBuildnet = true}) {
    grpc = GrpcServiceImpl(isBuildnet);
  }

  /// findBestPathFromAmountIn retrives the best path of a given token pair
  Future<(List, List, List, List, List, List)> findBestPathFromAmountIn(
      TokenName token1, TokenName token2, BigInt amountIn) {
    return _findBestPath(token1, token2, amountIn, true);
  }

  /// findBestPathFromAmountOut retrives the best path of a given token pair
  Future<(List, List, List, List, List, List)> findBestPathFromAmountOut(
      TokenName token1, TokenName token2, BigInt amountOut) async {
    return await _findBestPath(token1, token2, amountOut, false);
  }

  Future<(List, List, List, List, List, List)> _findBestPath(
      TokenName token1, TokenName token2, BigInt amount, bool isExactIn) async {
    final params = Args();
    final routes = [getTokenAddress(token1, isBuildnet), getTokenAddress(token2, isBuildnet)];
    params.addArray(routes, ArrayTypes.STRING);
    params.addU256(amount);
    params.addBool(isExactIn);
    final targetFunction = isExactIn ? "findBestPathFromAmountIn" : "findBestPathFromAmountOut";
    final functionParameters = params.serialise();
    const maximumGas = GasLimit.MAX_GAS_CALL;
    final smartContracAddress = isBuildnet ? BuildnetConstants.quoterAddress : MainnetConstants.quoterAddress;

    final response = await grpc.scReadOnlyCall(
        maximumGas: toMAS(BigInt.from(maximumGas.value)),
        smartContracAddress: smartContracAddress,
        functionName: targetFunction,
        functionParameters: functionParameters,
        callerAddress: account.address());
    final responseArg = Args(initialData: response);
    final route = responseArg.nextArray(ArrayTypes.STRING);
    final pair = responseArg.nextArray(ArrayTypes.STRING);
    final binSteps = responseArg.nextArray(ArrayTypes.U64);
    final amounts = responseArg.nextArray(ArrayTypes.U256);
    final amountsWithoutSlippage = responseArg.nextArray(ArrayTypes.U256);
    final fees = responseArg.nextArray(ArrayTypes.U256);
    return (route, pair, binSteps, amounts, amountsWithoutSlippage, fees);
  }
}
