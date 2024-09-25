class CommonConstants {
  static const double minimumFee = 0.01; //MAS
  static const Duration waitStatusTimeout = Duration(seconds: 60); //60000 ms
  static const Duration waitOperationTimeout = Duration(seconds: 160); //160000 ms
  static const Duration txPollIntervals = Duration(seconds: 1); //1000 ms
  static const int txDeadline = 2 * 60 * 1000; //in ms (2 minutes)
}

class BuildnetConstants {
  static const String wmasAddress = String.fromEnvironment(
    'wmasAddress',
    defaultValue: 'AS12FW5Rs5YN2zdpEnqwj4iHUUPt9R4Eqjq2qtpJFNKW3mn33RuLU',
  );

  static const String usdcAddress = String.fromEnvironment(
    'usdcAddress',
    defaultValue: 'AS12N76WPYB3QNYKGhV2jZuQs1djdhNJLQgnm7m52pHWecvvj1fCQ',
  );

  static const String wethAddress = String.fromEnvironment(
    'wethAddress',
    defaultValue: 'AS12rcqHGQ3bPPhnjBZsYiANv9TZxYp96M7r49iTMUrX8XCJQ8Wrk',
  );
  static const String quoterAddress = String.fromEnvironment(
    'quoterAddress',
    defaultValue: 'AS1Wse7vxWvB1iP1DwNQTQQctwU1fQ1jrq5JgdSPZH132UYrYrXF',
  );
  static const String routerAddress = String.fromEnvironment(
    'routerAddress',
    defaultValue: 'AS1XqtvX3rz2RWbnqLfaYVKEjM3VS5pny9yKDdXcmJ5C1vrcLEFd',
  );
  static const String factoryAddress = String.fromEnvironment(
    'factoryAddress',
    defaultValue: 'AS125Y3UWiMoEx3w71jf7iq1RwkxXdwkEVdoucBTAmvyzGh2KUqXS',
  );
  static const String multicallAddress = String.fromEnvironment(
    'multicallAddress',
    defaultValue: 'AS1yphCWi7gychZWYPpqrKDiGb6ZacRoji8YYMLHtQ2TSuuQFqLC',
  );
}

class MainnetConstants {
  /// wmasAddress is a smart contract address that supports these functions
  /// deposit, withdraw, computeMintStorageCost, version, name, symbol, totalSupply,
  /// decimals, balanceOf, transfer, allowance, increaseAllowance, decreaseAllowance, transferFrom
  static const String wmasAddress = String.fromEnvironment(
    'wmasAddress',
    defaultValue: 'AS12U4TZfNK7qoLyEERBBRDMu8nm5MKoRzPXDXans4v9wdATZedz9',
  );

  /// usdcAddress is a smart contract address that supports the following functions:
  /// mint, version, name, symbol, totalSupply, decimals, balanceOf, transfer, allowance, increaseAllowance,
  /// decreaseAllowance, transferFrom, burn, burnFrom, grantRole, members, hasRole, revokeRole, onlyRole,
  /// setOwner, ownerAddress, isOwner
  static const String usdcAddress = String.fromEnvironment(
    'usdcAddress',
    defaultValue: 'AS1hCJXjndR4c9vekLWsXGnrdigp4AaZ7uYG3UKFzzKnWVsrNLPJ',
  );

  /// wethAddress is a smart contract address that supports these functions:
  /// mint, version, name, symbol, totalSupply, decimals, balanceOf, transfer, allowance,
  /// increaseAllowance, decreaseAllowance, transferFrom, burn, burnFrom, grantRole, members, hasRole,
  /// revokeRole, onlyRole, setOwner, ownerAddress, isOwner
  static const String wethAddress = String.fromEnvironment(
    'wethAddress',
    defaultValue: 'AS124vf3YfAJCSCQVYKczzuWWpXrximFpbTmX4rheLs5uNSftiiRY',
  );

  /// quoterAddress is a smart contract address that support these functions:
  /// findBestPathFromAmountIn, findBestPathFromAmountOut
  static const String quoterAddress = String.fromEnvironment(
    'quoterAddress',
    defaultValue: 'AS128hBKoHbgXdiBXp8ji2KuT8krDFSjLnakw38GN4xcL3XyR9yFF',
  );

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

  /// factoryAddress is a smart contract address that supports these functions:
  /// getLBPairInformation, getPreset, getAllBinSteps, getAvailableLBPairBinSteps, getAllLBPairs, createLBPair,
  /// setLBPairIgnored, setPreset, removePreset, setFeesParametersOnPair, setFeeRecipient, setFlashLoanFee,
  /// setFactoryLockedState, addQuoteAsset, removeQuoteAsset, forceDecay, proposeNewOwner, acceptOwnership, receiveCoins
  static const String factoryAddress = String.fromEnvironment(
    'factoryAddress',
    defaultValue: 'AS1rahehbQkvtynTomfoeLmwRgymJYgktGv5xd1jybRtiJMdu8XX',
  );

  /// mutlicallAddress is a smart contract address that supports 'multicall' function
  static const String multicallAddress = String.fromEnvironment(
    'multicallAddress',
    defaultValue: 'AS1FJrNBtZ5oXK9y6Wcmiio5AV6rR2UopqqdQWhBH4Fss9JNMySm',
  );
}
