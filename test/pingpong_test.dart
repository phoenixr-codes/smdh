import 'dart:io';
import 'dart:typed_data';
import 'package:smdh/smdh.dart';
import 'package:test/test.dart';

Uint8List _fillZeros(Uint8List list, int length) {
  final result = Uint8List(length);
  for (final (i, byte) in list.indexed) {
    result[i] = byte;
  }
  return result;
}

void main() {
  test('write and read', () async {
    final smallIcon = _fillZeros(await File('example/smallIcon.jpg').readAsBytes(), 0x480);
    final largeIcon = _fillZeros(await File('example/largeIcon.jpg').readAsBytes(), 0x1200);
    final Map<Language, ApplicationTitle> applicationTitles = {};
    for (final language in Language.values) {
      applicationTitles[language] = ApplicationTitle(
        shortDescription: 'Hello in ${language.name}',
        longDescription: 'Hello in ${language.name}',
        publisher: 'World',
      );
    }
    final smdhInput = Smdh(
      version: (1, 0),
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
    final data = smdhInput.toByteData();
    final smdhOutput = Smdh.parse(data);
    expect(smdhOutput, equals(smdhInput));
  });
}
