import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:smdh/icon.dart';
import 'package:smdh/smdh.dart';

import 'large_icon.dart';
import 'small_icon.dart';

SmdhIcon imageForData(List<int> pixels) {
  final size = sqrt(pixels.length).round();
  final buffer = ByteData(size * size * 2);
  final icon = SmdhIcon(buffer);
  int i = 0;
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      final rgb888 = pixels[i];
      final r = (rgb888 >> 16) & 0xFF;
      final g = (rgb888 >> 8) & 0xFF;
      final b = rgb888 & 0xFF;
      icon.setPixelAt(x, y, Rgb565.fromRgb888(r, g, b));
      i++;
    }
  }
  return icon;
}

void main() async {
  final smallIcon = imageForData(smallIconData);
  final largeIcon = imageForData(largeIconData);
  final Map<Language, ApplicationTitle> applicationTitles = {};
  for (final language in Language.values) {
    applicationTitles[language] = ApplicationTitle(
      shortDescription: 'Hello in ${language.name}',
      longDescription: 'Hello in ${language.name}',
      publisher: '${language.name} world',
    );
  }
  final smdh = Smdh(
    version: 0,
    applicationTitles: applicationTitles,
    applicationSettings: ApplicationSettings(
      regionSpecificGameAgeRatings: {},
      matchMakerIDs: MatchMakerIDs(matchMakerID: 0, matchMakerBitID: 0),
      autosave: false,
      usesSaveData: false,
      eulaVersion: (1, 0),
      optimalAnimationFrame: 0.0,
      cecID: 0,
    ),
    smallIcon: smallIcon,
    largeIcon: largeIcon,
  );
  stdout.add(smdh.toByteData().buffer.asUint8List().toList());
}
