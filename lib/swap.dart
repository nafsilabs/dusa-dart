import 'dart:typed_data';

import 'package:massa/massa.dart';
import 'package:dusa/constants.dart';
import 'package:dusa/env/env.dart';
import 'package:dusa/service/grpc_service.dart';
import 'package:massa/src/grpc/generated/massa/model/v1/execution.pb.dart';

class Swap {
  final Account account;
  final bool isBuildnet;
  late GrpcService grpc;

  Swap(this.account, {this.isBuildnet = true}) {
    grpc = GrpcServiceImpl(isBuildnet);
  }

  Future<(BigInt, BigInt)> getSwapIn(String pairAddress, BigInt amountOut, bool swapForY) async {
    final params = Args();
    params.addString(pairAddress);
    params.addU256(amountOut);
    params.addBool(swapForY);
    const targetFunction = "getSwapIn";
    final functionParameters = params.serialise();
    const maximumGas = GasLimit.MAX_GAS_CALL;
    final smartContracAddress = isBuildnet ? BuildnetConstants.routerAddress : MainnetConstants.routerAddress;

    final response = await grpc.scReadOnlyCall(
        maximumGas: maximumGas.value / 1e9,
        smartContracAddress: smartContracAddress,
        functionName: targetFunction,
        functionParameters: functionParameters,
        callerAddress: account.address());
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
    final smartContracAddress = isBuildnet ? BuildnetConstants.routerAddress : MainnetConstants.routerAddress;

    final response = await grpc.scReadOnlyCall(
        maximumGas: maximumGas,
        smartContracAddress: smartContracAddress,
        functionName: targetFunction,
        functionParameters: functionParameters,
        callerAddress: account.address());

    final responseArg = Args(initialData: response);
    final amountOut = responseArg.nextU256();
    final feesIn = responseArg.nextU256();
    return (amountOut, feesIn);
  }

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
    final smartContracAddress = isBuildnet ? BuildnetConstants.routerAddress : MainnetConstants.routerAddress;
    final coins = toMAS(amountIn) + storageCost;
    return await grpc.scCall(
      account: account,
      fee: minimumFee,
      coins: coins,
      maximumGas: maximumGas,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );
  }

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
    final smartContracAddress = isBuildnet ? BuildnetConstants.routerAddress : MainnetConstants.routerAddress;
    final coins = storageCost;
    return await grpc.scCall(
      account: account,
      fee: minimumFee,
      coins: coins,
      maximumGas: maximumGas,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );
  }
}

/*
swap/trade

  /**
   * Returns the on-chain method name and args for this trade
   *
   * @param {TradeOptions | TradeOptionsDeadline} options
   * @returns {SwapParameters}
   */
  public swapCallParameters(
    options: TradeOptions | TradeOptionsDeadline
  ): SwapParameters {
    const nativeIn = this.isNativeIn
    const nativeOut = this.isNativeOut
    // the router does not support both native in and out
    invariant(!(nativeIn && nativeOut), 'NATIVE_IN_OUT')
    invariant(!('ttl' in options) || options.ttl > 0, 'TTL')

    const to: string = options.recipient
    const amountIn: bigint = this.maximumAmountIn(options.allowedSlippage).raw
    const amountOut: bigint = this.minimumAmountOut(options.allowedSlippage).raw

    const binSteps: string[] = this.quote.binSteps.map((bin) => bin.toString())
    const path: RouterPathParameters = {
      pairBinSteps: binSteps,
      tokenPath: this.quote.route.map((t) => new Address(t))
    }
    const deadline =
      'ttl' in options
        ? Math.floor(new Date().getTime()) + options.ttl
        : options.deadline

    const useFeeOnTransfer = Boolean(options.feeOnTransfer)

    const SWAP_STORAGE_COST = MassaUnits.oneMassa / 10n // 0.1 MAS

    const { methodName, args, value } = ((
      tradeType: TradeType
    ): SwapParameters => {
      const args: Args = new Args()
      let value = SWAP_STORAGE_COST
      switch (tradeType) {
        case TradeType.EXACT_INPUT:
          if (nativeIn) {
            const methodName = useFeeOnTransfer
              ? 'swapExactMASForTokensSupportingFeeOnTransferTokens'
              : 'swapExactMASForTokens'
            args
              .addU256(amountOut)
              .addArray(path.pairBinSteps, ArrayTypes.U64)
              .addSerializableObjectArray(path.tokenPath)
              .addString(to)
              .addU64(BigInt(deadline))
              .addU64(SWAP_STORAGE_COST)
            value += amountIn
            return { args, methodName, value }
          } else if (nativeOut) {
            const methodName = useFeeOnTransfer
              ? 'swapExactTokensForMASSupportingFeeOnTransferTokens'
              : 'swapExactTokensForMAS'
            args
              .addU256(amountIn)
              .addU256(amountOut)
              .addArray(path.pairBinSteps, ArrayTypes.U64)
              .addSerializableObjectArray(path.tokenPath)
              .addString(to)
              .addU64(BigInt(deadline))
            return { args, methodName, value }
          } else {
            const methodName = useFeeOnTransfer
              ? 'swapExactTokensForTokensSupportingFeeOnTransferTokens'
              : 'swapExactTokensForTokens'
            args
              .addU256(amountIn)
              .addU256(amountOut)
              .addArray(path.pairBinSteps, ArrayTypes.U64)
              .addSerializableObjectArray(path.tokenPath)
              .addString(to)
              .addU64(BigInt(deadline))
            return { args, methodName, value }
          }
        case TradeType.EXACT_OUTPUT:
          invariant(!useFeeOnTransfer, 'EXACT_OUT_FOT')
          if (nativeIn) {
            const methodName = 'swapMASForExactTokens'
            args
              .addU256(amountOut)
              .addArray(path.pairBinSteps, ArrayTypes.U64)
              .addSerializableObjectArray(path.tokenPath)
              .addString(to)
              .addU64(BigInt(deadline))
              .addU64(SWAP_STORAGE_COST)
            value += amountIn
            return { args, methodName, value }
          } else if (nativeOut) {
            const methodName = 'swapTokensForExactMAS'
            args
              .addU256(amountOut)
              .addU256(amountIn)
              .addArray(path.pairBinSteps, ArrayTypes.U64)
              .addSerializableObjectArray(path.tokenPath)
              .addString(to)
              .addU64(BigInt(deadline))
            return { args, methodName, value }
          } else {
            const methodName = 'swapTokensForExactTokens'
            args
              .addU256(amountOut)
              .addU256(amountIn)
              .addArray(path.pairBinSteps, ArrayTypes.U64)
              .addSerializableObjectArray(path.tokenPath)
              .addString(to)
              .addU64(BigInt(deadline))
            return { args, methodName, value }
          }
      }
    })(this.tradeType)

    return {
      methodName,
      args,
      value
    }
  }
*/


/* extract swap output
const extractAmountInOut = (
  method: SwapRouterMethod,
  args: Args,
  coins: bigint
) => {
  switch (method) {
    case 'swapExactTokensForTokens': {
      const amountIn = args.nextU256()
      const amountOutMin = args.nextU256()
      return { amountIn, amountOut: amountOutMin }
    }
    case 'swapTokensForExactTokens': {
      const amountOut = args.nextU256()
      const amountInMax = args.nextU256()
      return { amountIn: amountInMax, amountOut }
    }
    case 'swapExactMASForTokens': {
      const amountIn = coins
      const amountOutMin = args.nextU256()
      return { amountIn, amountOut: amountOutMin }
    }
    case 'swapExactTokensForMAS': {
      const amountIn = args.nextU256()
      const amountOutMinMAS = args.nextU256()
      return { amountIn, amountOut: amountOutMinMAS }
    }
    case 'swapTokensForExactMAS': {
      const amountOut = args.nextU256()
      const amountInMax = args.nextU256()
      return { amountIn: amountInMax, amountOut }
    }
    case 'swapMASForExactTokens': {
      const amountIn = coins
      const amountOut = args.nextU256()
      return { amountIn, amountOut }
    }
    case 'swapExactMASForTokensSupportingFeeOnTransferTokens': {
      const amountIn = coins
      const amountOutMin = args.nextU256()
      return { amountIn, amountOut: amountOutMin }
    }
    case 'swapExactTokensForMASSupportingFeeOnTransferTokens': {
      const amountIn = args.nextU256()
      const amountOutMinMAS = args.nextU256()
      return { amountIn, amountOut: amountOutMinMAS }
    }
    case 'swapExactTokensForTokensSupportingFeeOnTransferTokens': {
      const amountIn = args.nextU256()
      const amountOutMin = args.nextU256()
      return { amountIn, amountOut: amountOutMin }
    }
    default:
      throw new Error('unknown method: ' + method)
  }
}
*/