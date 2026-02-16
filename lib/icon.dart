import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';

/// A 16-bit color.
class Rgb565 {
  /// The red value in the range 0 - 2^5.
  late final int red;

  /// The green value in the range 0 - 2^6.
  late final int green;

  /// The blue value in the range 0 - 2^5.
  late final int blue;

  Rgb565(this.red, this.green, this.blue)
      : assert(red >= 0 && red <= int.parse("11111", radix: 2)),
        assert(green >= 0 && green <= int.parse("111111", radix: 2)),
        assert(blue >= 0 && blue <= int.parse("11111", radix: 2));

  Rgb565.fromInt(int value) {
    red = value >> 11 & int.parse("0000000000011111", radix: 2);
    green = value >> 5 & int.parse("0000000000111111", radix: 2);
    blue = value & int.parse("0000000000011111", radix: 2);
  }

  Rgb565.fromRgb888(int r, int g, int b) {
    red = ((r * 31 + 127) / 255).round();
    green = ((g * 63 + 127) / 255).round();
    blue = ((b * 31 + 127) / 255).round();
  }

  /// Returns the 16-bit integer representation of this color.
  int toInt() {
    return (red << 11) | (green << 5) | blue;
  }

  /// Converts the RGB565 color to the closest representable RGB888 color.
  ({int r, int g, int b}) toRgb888() {
    return (
      r: (red * 255 / 31).round(),
      g: (green * 255 / 63).round(),
      b: (blue * 255 / 31).round()
    );
  }

  @override
  int get hashCode => Object.hashAll([red, green, blue]);

  @override
  bool operator ==(Object other) {
    if (other is! Rgb565) throw UnimplementedError();
    return red == other.red && green == other.green && blue == other.blue;
  }

  @override
  String toString() => "$runtimeType($red, $green, $blue)";
}

final _bytesPerPixel = 2;

/// Quadratic [Z-shaped](https://en.wikipedia.org/wiki/Z-order_curve) image
/// with tiles.
///
/// For convenience, methods and fields of this class use the classical x-y
/// coordinate system and uses the Z-shaped coordinate system internally.
///
/// See also: https://www.3dbrew.org/wiki/SMDH#Icon_graphics
class SmdhIcon {
  /// Low-level access to the underlying buffer.
  final ByteData buffer;

  /// The size of each tile.
  final int tileSize = 8;

  final Endian endianness = Endian.little;

  /// The buffer must not have unrelated trailing data. All data is interpreted
  /// as image data.
  SmdhIcon(this.buffer);

  /// The amount of pixels in each direction.
  int get size => sqrt(pixels).floor();

  /// The total amount of pixels.
  int get pixels => (buffer.lengthInBytes / _bytesPerPixel).floor();

  /// The maximum amount of bits needed to represent a coordinate index.
  ///
  /// Assuming there are 32 pixels = 16 tiles in each direction, then the
  /// largest index being 15 is represented by `0b1111` meaning 4 bits are
  /// required per coordinate index.
  int get _bitsPerCoordinateIndex => size.bitLength;

  /// Returns the RGB pixel at the given coordinate.
  ///
  /// The origin is the top left corner. Indices are zero-based.
  Rgb565 getPixelAt(int x, int y) {
    (x, y) = (y, x);
    final index = _memoryIndex(x, y);
    final color = buffer.getUint16(index * _bytesPerPixel, endianness);
    return Rgb565.fromInt(color);
  }

  /// Set the RGB pixel at the given coordinate.
  ///
  /// The origin is the top left corner. Indices are zero-based.
  void setPixelAt(int x, int y, Rgb565 pixel) {
    (x, y) = (y, x);
    final index = _memoryIndex(x, y);
    buffer.setUint16(index * _bytesPerPixel, pixel.toInt(), endianness);
  }

  int _memoryIndex(int x, int y) {
    final xWithinTile = x % tileSize;
    final yWithinTile = y % tileSize;
    final tileIndex = _tileIndex(x, y);
    final mortonIndex = _mortonIndex(xWithinTile, yWithinTile);
    final index = tileSize * tileSize * tileIndex + mortonIndex;
    assert (index >= 0);
    return index;
  }

  int _tileIndex(int x, int y) {
    int i = 0, j = 0;
    while (tileSize * i <= x) {
      i++;
    }
    while (tileSize * j <= y) {
      j++;
    }
    final int tilesPerRow = (size / tileSize).round();
    final int index = (i - 1) + (j - 1) * tilesPerRow;
    assert (index >= 0);
    return index;
  }

  /// Returns the morton index within a tile.
  int _mortonIndex(int x, int y) {
    assert(x >= 0 && x < tileSize, "$x not within tile size");
    assert(y >= 0 && y < tileSize, "$y not within tile size");

    int index = 0;
    for (int i = 0; i < _bitsPerCoordinateIndex; i++) {
      index |= ((x >> i) & 1) << (2 * i);
      index |= ((y >> i) & 1) << (2 * i + 1);
    }
    assert (index >= 0);
    return index;
  }

  @override
  int get hashCode => buffer.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! SmdhIcon) throw UnimplementedError();
    return ListEquality().equals(
        buffer.buffer.asUint16List(), other.buffer.buffer.asUint16List());
  }
}
