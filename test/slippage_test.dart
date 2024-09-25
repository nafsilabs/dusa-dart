import 'package:dusa/dusa.dart';
import 'package:test/test.dart';

void main() {
  group('Slippage tests: ', () {
    test('maximum input / exact', () async {
      final input = 10.5;
      final slippage = 0.5; // 0.5 %
      final expected = 10.5;
      expect(expected, maximumAmoutIn(input, slippage, isExactIn: true));
    });

    test('maximum input / not exact', () async {
      final input = 10.5;
      final slippage = 0.5; // 0.5 %
      final expected = 10.5525;
      expect(expected, maximumAmoutIn(input, slippage));
    });
    test('minimum output / exact', () async {
      final output = 10.5;
      final slippage = 1.0; // 1.0 %
      final expected = 10.5;
      expect(expected, minimumAmoutOut(output, slippage, isExactOut: true));
    });

    test('minimum output / not exact', () async {
      final output = 10.5;
      final slippage = 1.0; // 1.0 %
      final expected = 10.395;
      expect(expected, minimumAmoutOut(output, slippage));
    });
  });
}
