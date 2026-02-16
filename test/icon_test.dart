import 'package:smdh/icon.dart';
import 'package:test/test.dart';

void main() {
  group('RGB565', () {
    test('integer conversion', () {
      final rgb = Rgb565.fromInt(int.parse("1111100000011111", radix: 2));
      expect(
          rgb,
          equals(Rgb565(int.parse("11111", radix: 2),
              int.parse("000000", radix: 2), int.parse("11111", radix: 2))));
    });
  });
}
