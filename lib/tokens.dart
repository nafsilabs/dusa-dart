// ignore_for_file: constant_identifier_names

import 'package:dusa/constants.dart';
import 'package:dusa/service/grpc_service.dart';
import 'package:massa/massa.dart';

enum TokenName { WMAS, USDC, WETH }

class Token {
  final Account account;
  final bool isBuildnet;
  final TokenName token;
  late GrpcService grpc;
  Token(this.account, this.token, {this.isBuildnet = true}) {
    grpc = GrpcServiceImpl(isBuildnet);
  }

  /// balanceOf  gets the balance of the given address
  Future<BigInt> balanceOf(String address) async {
    final params = Args();
    params.addString(address);

    const targetFunction = "balanceOf";
    final functionParameters = params.serialise();
    const maximumGas = GasLimit.MAX_GAS_CALL;
    final smartContracAddress = getTokenAddress(token, isBuildnet);

    final response = await grpc.scReadOnlyCall(
        maximumGas: maximumGas.value / 1e9,
        smartContracAddress: smartContracAddress,
        functionName: targetFunction,
        functionParameters: functionParameters,
        callerAddress: account.address());

    final responseArg = Args(initialData: response);
    final balance = responseArg.nextU256();
    return balance;
  }

  /// totalSupply  gets the balance of the given address
  Future<BigInt> totalSupply() async {
    final params = Args();
    const targetFunction = "totalSupply";
    final functionParameters = params.serialise();
    const maximumGas = GasLimit.MAX_GAS_CALL;
    final smartContracAddress = getTokenAddress(token, isBuildnet);

    final response = await grpc.scReadOnlyCall(
        maximumGas: maximumGas.value / 1e9,
        smartContracAddress: smartContracAddress,
        functionName: targetFunction,
        functionParameters: functionParameters,
        callerAddress: account.address());

    final responseArg = Args(initialData: response);
    final totalSupply = responseArg.nextU256();
    return totalSupply;
  }

  /// decimals gets the number of decimals of a token
  Future<int> decimals() async {
    final params = Args();
    const targetFunction = "decimals";
    final functionParameters = params.serialise();
    const maximumGas = GasLimit.MAX_GAS_CALL;
    final smartContracAddress = getTokenAddress(token, isBuildnet);

    final response = await grpc.scReadOnlyCall(
        maximumGas: maximumGas.value / 1e9,
        smartContracAddress: smartContracAddress,
        functionName: targetFunction,
        functionParameters: functionParameters,
        callerAddress: account.address());

    final responseArg = Args(initialData: response);
    final decimals = responseArg.nextU8();
    return decimals;
  }

  /// name gets the name of the token
  Future<String> name() async {
    final params = Args();
    const targetFunction = "name";
    final functionParameters = params.serialise();
    const maximumGas = GasLimit.MAX_GAS_CALL;
    final smartContracAddress = getTokenAddress(token, isBuildnet);

    final response = await grpc.scReadOnlyCall(
        maximumGas: maximumGas.value / 1e9,
        smartContracAddress: smartContracAddress,
        functionName: targetFunction,
        functionParameters: functionParameters,
        callerAddress: account.address());

    final responseArg = Args(initialData: response);
    final name = responseArg.nextString();
    return name;
  }

  /// symbol gets the name of the token
  Future<String> symbol() async {
    final params = Args();
    const targetFunction = "symbol";
    final functionParameters = params.serialise();
    const maximumGas = GasLimit.MAX_GAS_CALL;
    final smartContracAddress = getTokenAddress(token, isBuildnet);

    final response = await grpc.scReadOnlyCall(
        maximumGas: maximumGas.value / 1e9,
        smartContracAddress: smartContracAddress,
        functionName: targetFunction,
        functionParameters: functionParameters,
        callerAddress: account.address());

    final responseArg = Args(initialData: response);
    final name = responseArg.nextString();
    return name;
  }

  Future<void> approve(String spender, double amount) async {
    final params = Args();
    params.addString(spender);
    params.addU256(BigInt.from(doubleToMassaInt(amount)));
    const targetFunction = "approve";
    final functionParameters = params.serialise();
    const maximumGas = GasLimit.MAX_GAS_CALL;
    final smartContracAddress = getTokenAddress(token, isBuildnet);

    await grpc.scCall(
      account: account,
      fee: 0.01,
      coins: 0.0,
      maximumGas: maximumGas.value / 1e9,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );
  }

  Future<void> transfer(String toAddress, double amount) async {
    final params = Args();
    params.addString(toAddress);
    params.addU256(BigInt.from(doubleToMassaInt(amount)));
    const targetFunction = "transfer";
    final functionParameters = params.serialise();
    const maximumGas = GasLimit.MAX_GAS_CALL;
    final smartContracAddress = getTokenAddress(token, isBuildnet);

    await grpc.scCall(
      account: account,
      fee: 0.01,
      coins: 0.0,
      maximumGas: maximumGas.value / 1e9,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );
  }

  Future<void> increaseAllowance(BigInt amount) async {
    final params = Args();
    params.addString(isBuildnet ? BuildnetConstants.routerAddress : MainnetConstants.routerAddress); //spender address
    params.addU256(amount);
    const targetFunction = "increaseAllowance";
    final functionParameters = params.serialise();
    final maximumGas = toMAS(BigInt.from(GasLimit.MAX_GAS_CALL.value));
    final smartContracAddress = getTokenAddress(token, isBuildnet);

    await grpc.scCall(
      account: account,
      fee: 0.01,
      coins: 0.0,
      maximumGas: maximumGas,
      smartContracAddress: smartContracAddress,
      functionName: targetFunction,
      functionParameters: functionParameters,
    );
  }
}

String getTokenAddress(TokenName token, bool isBuildnet) {
  String tokenAddress = '';
  switch (token) {
    case TokenName.WMAS:
      tokenAddress = isBuildnet ? BuildnetConstants.wmasAddress : MainnetConstants.wmasAddress;
      break;
    case TokenName.USDC:
      tokenAddress = isBuildnet ? BuildnetConstants.usdcAddress : MainnetConstants.usdcAddress;
      break;
    case TokenName.WETH:
      tokenAddress = isBuildnet ? BuildnetConstants.wethAddress : MainnetConstants.wethAddress;
      break;
    default:
      throw Exception("Unknown token name: ${token.name}");
  }
  return tokenAddress;
}

int getTokenDecimal(TokenName token) {
  int tokenDecimals = 0;
  switch (token) {
    case TokenName.WMAS:
      tokenDecimals = 9;
      break;
    case TokenName.USDC:
      tokenDecimals = 6;
      break;
    case TokenName.WETH:
      tokenDecimals = 18;
      break;
    default:
      throw Exception("Unknown token name: ${token.name}");
  }
  return tokenDecimals;
}
