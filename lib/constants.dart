/// CommonConstants defines commonly used constants across dusa package
class CommonConstants {
  /// minimum transaction fee
  static const double minimumFee = 0.01;

  /// waiting status before timeout
  static const Duration waitStatusTimeout = Duration(seconds: 60); //60000 ms

  /// waiting time for the operation status before timeout
  static const Duration waitOperationTimeout = Duration(seconds: 160); //160000 ms

  /// polling interval
  static const Duration txPollIntervals = Duration(seconds: 1); //1000 ms

  /// typical transaction deadline
  static const int txDeadline = 2 * 60 * 1000; //in ms (2 minutes)
}

/// BuildnetConstants contains constants that are used for for buildnet
class BuildnetConstants {
  /// smart contract address for the WMAS token
  static const String wmasAddress = String.fromEnvironment(
    'wmasAddress',
    defaultValue: 'AS12FW5Rs5YN2zdpEnqwj4iHUUPt9R4Eqjq2qtpJFNKW3mn33RuLU',
  );

  /// smart contract address for the USDC token
  static const String usdcAddress = String.fromEnvironment(
    'usdcAddress',
    defaultValue: 'AS12N76WPYB3QNYKGhV2jZuQs1djdhNJLQgnm7m52pHWecvvj1fCQ',
  );

  /// smart contract address for the WETH token
  static const String wethAddress = String.fromEnvironment(
    'wethAddress',
    defaultValue: 'AS12rcqHGQ3bPPhnjBZsYiANv9TZxYp96M7r49iTMUrX8XCJQ8Wrk',
  );

  /// quoter smart contract address
  static const String quoterAddress = String.fromEnvironment(
    'quoterAddress',
    defaultValue: 'AS1Wse7vxWvB1iP1DwNQTQQctwU1fQ1jrq5JgdSPZH132UYrYrXF',
  );

  /// router smart contract address
  static const String routerAddress = String.fromEnvironment(
    'routerAddress',
    defaultValue: 'AS1XqtvX3rz2RWbnqLfaYVKEjM3VS5pny9yKDdXcmJ5C1vrcLEFd',
  );

  /// factory smart contract address
  static const String factoryAddress = String.fromEnvironment(
    'factoryAddress',
    defaultValue: 'AS125Y3UWiMoEx3w71jf7iq1RwkxXdwkEVdoucBTAmvyzGh2KUqXS',
  );

  /// multicall smart contract address
  static const String multicallAddress = String.fromEnvironment(
    'multicallAddress',
    defaultValue: 'AS1yphCWi7gychZWYPpqrKDiGb6ZacRoji8YYMLHtQ2TSuuQFqLC',
  );
}

/// MainnetConstants contains constants that are used for for buildnet
class MainnetConstants {
  /// smart contract address for the WMAS token
  /// wmasAddress is a smart contract address that supports these functions
  /// deposit, withdraw, computeMintStorageCost, version, name, symbol, totalSupply,
  /// decimals, balanceOf, transfer, allowance, increaseAllowance, decreaseAllowance, transferFrom
  static const String wmasAddress = String.fromEnvironment(
    'wmasAddress',
    defaultValue: 'AS12U4TZfNK7qoLyEERBBRDMu8nm5MKoRzPXDXans4v9wdATZedz9',
  );

  /// smart contract address for the USDC token
  /// usdcAddress is a smart contract address that supports the following functions:
  /// mint, version, name, symbol, totalSupply, decimals, balanceOf, transfer, allowance, increaseAllowance,
  /// decreaseAllowance, transferFrom, burn, burnFrom, grantRole, members, hasRole, revokeRole, onlyRole,
  /// setOwner, ownerAddress, isOwner
  static const String usdcAddress = String.fromEnvironment(
    'usdcAddress',
    defaultValue: 'AS1hCJXjndR4c9vekLWsXGnrdigp4AaZ7uYG3UKFzzKnWVsrNLPJ',
  );

  /// smart contract address for the WETH token
  /// wethAddress is a smart contract address that supports these functions:
  /// mint, version, name, symbol, totalSupply, decimals, balanceOf, transfer, allowance,
  /// increaseAllowance, decreaseAllowance, transferFrom, burn, burnFrom, grantRole, members, hasRole,
  /// revokeRole, onlyRole, setOwner, ownerAddress, isOwner
  static const String wethAddress = String.fromEnvironment(
    'wethAddress',
    defaultValue: 'AS124vf3YfAJCSCQVYKczzuWWpXrximFpbTmX4rheLs5uNSftiiRY',
  );

  /// quoter smart contract address
  /// quoterAddress is a smart contract address that support these functions:
  /// findBestPathFromAmountIn, findBestPathFromAmountOut
  static const String quoterAddress = String.fromEnvironment(
    'quoterAddress',
    defaultValue: 'AS128hBKoHbgXdiBXp8ji2KuT8krDFSjLnakw38GN4xcL3XyR9yFF',
  );

  /// router smart contract address
  /// routerAddress is a smart contract address that supports these functions:
  /// createLBPair, addLiquidity, addLiquidityMAS, removeLiquidity, removeLiquidityMAS,
  /// swapExactTokensForTokens, swapExactTokensForMAS, swapExactMASForTokens, swapTokensForExactTokens,
  /// swapTokensForExactMAS, swapMASForExactTokens, swapExactTokensForTokensSupportingFeeOnTransferTokens,
  /// swapExactTokensForMASSupportingFeeOnTransferTokens, swapExactMASForTokensSupportingFeeOnTransferTokens,
  /// sweep, sweepLBToken, getSwapIn, getSwapOut, receiveCoins
  static const String routerAddress = String.fromEnvironment(
    'routerAddress',
    defaultValue: 'AS12UMSUxgpRBB6ArZDJ19arHoxNkkpdfofQGekAiAJqsuE6PEFJy',
  );

  /// factory smart contract address
  /// factoryAddress is a smart contract address that supports these functions:
  /// getLBPairInformation, getPreset, getAllBinSteps, getAvailableLBPairBinSteps, getAllLBPairs, createLBPair,
  /// setLBPairIgnored, setPreset, removePreset, setFeesParametersOnPair, setFeeRecipient, setFlashLoanFee,
  /// setFactoryLockedState, addQuoteAsset, removeQuoteAsset, forceDecay, proposeNewOwner, acceptOwnership, receiveCoins
  static const String factoryAddress = String.fromEnvironment(
    'factoryAddress',
    defaultValue: 'AS1rahehbQkvtynTomfoeLmwRgymJYgktGv5xd1jybRtiJMdu8XX',
  );

  /// multicall smart contract address
  /// mutlicallAddress is a smart contract address that supports 'multicall' function
  static const String multicallAddress = String.fromEnvironment(
    'multicallAddress',
    defaultValue: 'AS1FJrNBtZ5oXK9y6Wcmiio5AV6rR2UopqqdQWhBH4Fss9JNMySm',
  );
}
