
# dusa
[![pub.dev][pub-dev-shield]][pub-dev-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

[Dusa](https://dusa.io) is a decentralised exchange (DEX) built on the Massa blockchain. As a fully on-chain DEX, Dusa leverages the benefits of blockchain technology to provide a secure and transparent platform for users to buy and sell cryptocurrency.

## Introduction
Dusa-dart is an SDK that is able to connect your Dart and Flutter applications to the Dusa decentralised exchange and allows you to swap/trade tokens.
## Features
Dusa has a number of smart contracts, each with several functions. The implementation status of these functions are detailed below

### Factory
- [ ] acceptOwnership
- [ ] addQuoteAsset
- [ ] createLBPair
- [ ] forceDecay
- [ ] getAllBinSteps
- [x] getAllLBPairs
- [ ] getAvailableLBPairBinSteps
- [x] getLBPairInformation
- [ ] getPreset
- [ ] proposeNewOwner
- [ ] receiveCoins
- [ ] removePreset
- [ ] removeQuoteAsset
- [ ] setFactoryLockedState
- [ ] setFeeRecipient
- [ ] setFeesParametersOnPair
- [ ] setFlashLoanFee
- [ ] setLBPairIgnored
- [ ] setPreset

### Pair
- [ ] balanceOf
- [ ] balanceOfBatch
- [ ] burn
- [ ] collectFees
- [ ] collectProtocolFees
- [ ] findFirstNonEmptyBinId
- [ ] flashLoan
- [ ] forceDecay
- [ ] getBin
- [ ] getGlobalFees
- [ ] getOracleParameters
- [ ] getOracleSampleFrom
- [ ] getPairInformation
- [ ] getUserBins
- [ ] increaseOracleLength
- [ ] isApprovedForAll
- [ ] mint
- [ ] name
- [ ] pendingFees
- [ ] receiveCoins
- [ ] safeBatchTransferFrom
- [ ] safeTransferFrom
- [ ] setApprovalForAll
- [ ] setFeesParameters
- [ ] swap
- [ ] symbol
- [ ] totalSupply

### Quoter
- [x] findBestPathFromAmountIn
- [x] findBestPathFromAmountOut

### Router
- [ ] addLiquidity
- [ ] addLiquidityMAS
- [ ] createLBPair
- [x] getSwapIn
- [x] getSwapOut
- [ ] receiveCoins
- [ ] removeLiquidity
- [ ] removeLiquidityMAS
- [x] swapExactMASForTokens
- [ ] swapExactMASForTokensSupportingFeeOnTransferTokens
- [x] swapExactTokensForMAS
- [ ] swapExactTokensForMASSupportingFeeOnTransferTokens
- [ ] swapExactTokensForTokens
- [ ] swapExactTokensForTokensSupportingFeeOnTransferTokens
- [ ] swapMASForExactTokens
- [ ] swapTokensForExactMAS
- [ ] swapTokensForExactTokens
- [ ] sweep
- [ ] sweepLBToken


## Getting started

Check usage in `/example` folder to test some examples:
To run the examples, follow the following steps:
1. Navigate to the example folder.
2. To run a specific example, navigate to the given folder, and run the command `dart run example_folder_name/example_filename.dart`


## Testing
To run the test cases, navigate to the project root folder and run `dart test`
You need to have flutter/dart sdk installed in your machine.


## Usage

View more examples in `/example` folder. 

NOTE: For smart contract examples, all the smart contracts are already deployed on the buildnet, so you do not need to deploy them.

The example below shows how to get list of stakers
```dart
import 'package:dusa/dusa.dart';
import 'package:massa/massa.dart';

void main() async {
  final wallet = Wallet();
  final account = await wallet.addAccountFromSecretKey(Env.privateKey, AddressType.user, NetworkType.BUILDNET);
  final quoter = Quoter(account);
  final amountIn = doubleToMassaInt(200.00);

  final (route, pair, binSteps, amounts, amountsWithoutSlippage, fees) =
      await quoter.findBestPathFromAmountIn(TokenName.WMAS, TokenName.USDC, BigInt.from(amountIn));
  print('amount in: $amountIn');
  print('route: $route');
  print('pair: $pair');
  print('bin steps: $binSteps');
  final massaAmount = toMAS(amounts[0]);
  final usdcAmount = bigIntToDecimal(amounts[1], getTokenDecimal(TokenName.USDC));
  print('amounts: $amounts => $massaAmount MAS = $usdcAmount USDC');
  print('amounts without slippage: $amountsWithoutSlippage');
  print('fees: $fees');
}
```

## Additional information
You can get more information about massa by visiting the links below.
### Links
- [Dusa: Dusa official website](https://dusa.io)
- [Dusa App](https://app.dusa.io)
- [Testnet: Dusa testnet](https://beta.dusa.io)
- [Dusa Documentation: Valuable dusa documentation](https://docs.dusa.io/)
- [Dusa Github: Dusa official github repository](https://github.com/dusaprotocol)

### Other links
- [Massa: Massa main website](https://massa.net)
- [Massa Foundation website](https://massa.foundation)
- [Massa buildnet](https://buildnet.massa.net)
- [Massa station](https://station.massa.net/)
- [Massa Web3: massa-dart will have similar functionalities as massa-web3](https://github.com/massalabs/massa-web3)
- [Massa Dart SDK Repository](https://github.com/nafsilabs/massa-dart)
- [Massa Dart SDK documentation](https://pub.dev/documentation/massa/latest/massa/massa-library.html)

### Support
This project is supported by [massa](https://massa.net)

### Contribute
You can contribute to this package, request new features or report any bug by visiting the package repository at [dusa-dart](https://github.com/nafsilabs/dusa-dart)


## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[pub-dev-shield]: https://img.shields.io/pub/v/dusa?style=for-the-badge
[pub-dev-url]: https://pub.dev/packages/dusa
[stars-shield]: https://img.shields.io/github/stars/nafsilabs/dusa-dart.svg?style=for-the-badge&logo=github&colorB=deeppink&label=stars
[stars-url]: https://packagist.org/packages/nafsilabs/dusa-dart
[issues-shield]: https://img.shields.io/github/issues/nafsilabs/dusa-dart.svg?style=for-the-badge
[issues-url]: https://github.com/nafsilabs/dusa-dart/issues
[license-shield]: https://img.shields.io/github/license/nafsilabs/dusa-dart.svg?style=for-the-badge
[license-url]: https://github.com/nafsilabs/dusa-dart/blob/main/LICENSE
