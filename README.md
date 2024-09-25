
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
- [ ] getAllLBPairs
- [ ] getAvailableLBPairBinSteps
- [ ] getLBPairInformation
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
- [ ] constructor
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
1. Navigate to the example folder and open `constants.dart`.
2. Replace grpc address and port, e.g address: test.massa.net', grpc port: 33037. Note this information may be changed as Massa Blockchain Technology development progresses. Check the correct information on [Massa Documentation Website](https://docs.massa.net). Further note that, testnet or buildernet must be active for some examples to work, depending on your grpc configuration.
3. Generate private key and address using Massa Station, Bearby, or by running the test in the section below. Please do not use your massa mainnet address for testing purposes.
4. Request test tokens from massa discord server.
5. To run a specific example, navigate to the given folder, and run the command `dart run example_filename.dart`

NOTE that all examples are tested and working with MASSA DEVNET 27.3.

## Testing
To run the test cases, navigate to the project root folder and run `dart test`
You need to have flutter/dart sdk installed in your machine.
Please note that for grpc test, you need to configure grpc address and port. For some test, e.g getOperation test, you need to provide correct operation. Without proding correct information, grpc test will likely fail.

## Usage

View more examples in `/example` folder. 

NOTE: For smart contract examples, all the smart contracts are already deployed on the buildnet, so you do not need to deploy them.

The example below shows how to get list of stakers
```dart
import 'package:massa/massa.dart';

Future<void> main() async {
  const ipAddress = 'buildnet.massa.net';
  const port = 33037;
  var grpc = GRPCPublicClient(ipAddress, port);
  final stakers = await grpc.getStakers(limit: Int64(10));
  if (stakers.isEmpty) {
    print('No stakers found');
    return;
  }

  final totalAddresses = stakers.length;
  Int64 totalRolls = Int64(0);
  for (var staker in stakers) {
    print('${staker.address}:${staker.rolls}');
    totalRolls += staker.rolls;
  }
  print('Total addresses: $totalAddresses');
  print('Total rolls: $totalRolls');
  await grpc.shutDown();
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
You can contribute to this package, request new features or report any bug by visiting the package repository at [massa-dart](https://github.com/jwmdev/massa-dart)


## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[pub-dev-shield]: https://img.shields.io/pub/v/massa?style=for-the-badge
[pub-dev-url]: https://pub.dev/packages/massa
[stars-shield]: https://img.shields.io/github/stars/jwmdev/massa-dart.svg?style=for-the-badge&logo=github&colorB=deeppink&label=stars
[stars-url]: https://packagist.org/packages/jwmdev/massa-dart
[issues-shield]: https://img.shields.io/github/issues/jwmdev/massa-dart.svg?style=for-the-badge
[issues-url]: https://github.com/jwmdev/massa-dart/issues
[license-shield]: https://img.shields.io/github/license/jwmdev/massa-dart.svg?style=for-the-badge
[license-url]: https://github.com/jwmdev/massa-dart/blob/main/LICENSE