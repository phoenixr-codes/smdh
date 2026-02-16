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

  group("morton image", () {
    final red = Rgb565(int.parse("11111", radix: 2), 0, 0);
    final green = Rgb565(0, int.parse("111111", radix: 2), 0);
    final blue = Rgb565(0, 0, int.parse("11111", radix: 2));
    final black = Rgb565(0, 0, 0);

    // TODO
  });
}
