import 'dart:io';
import 'dart:typed_data';
import 'package:smdh/icon.dart';
import 'package:smdh/smdh.dart';

/// Export SMDH icon to ppm file for easy inspection.
String ppm(SmdhIcon image) {
  String result = "P3\n${image.size} ${image.size}\n255\n";
  for (int x = 0; x < image.size; x++) {
    for (int y = 0; y < image.size; y++) {
      final color = image.getPixelAt(x, y).toRgb888();
      result += " ${color.r} ${color.g} ${color.b}";
    }
  }
  return result;
}

void main() {
  final data = File('pixel_city.smdh').readAsBytesSync();
  final smdh = Smdh.parse(ByteData.sublistView(data));
  File('extracted-small-icon.ppm').writeAsStringSync(ppm(smdh.smallIcon));
  File('extracted-large-icon.ppm').writeAsStringSync(ppm(smdh.largeIcon));
  print(smdh);
}
