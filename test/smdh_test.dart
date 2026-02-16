import 'dart:io';
import 'dart:typed_data';
import 'package:smdh/icon.dart';
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
  test("application title", () {
    final appTitle1 = ApplicationTitle(
        shortDescription: "foo", longDescription: "bar", publisher: "baz");
    final appTitle2 = ApplicationTitle(
        shortDescription: "foo", longDescription: "bar", publisher: "baz");
    expect(appTitle1, equals(appTitle2));
  });

  test("application settings", () {
    final appSettings1 = ApplicationSettings(
        requireRegionGameRating: true,
        matchMakerIDs: MatchMakerIDs(matchMakerID: 0, matchMakerBitID: 0),
        autosave: false,
        usesSaveData: false,
        eulaVersion: (1, 0),
        optimalAnimationFrame: 0.0,
        cecID: 0);
    final appSettings2 = ApplicationSettings(
        matchMakerIDs: MatchMakerIDs(matchMakerID: 0, matchMakerBitID: 0),
        autosave: false,
        usesSaveData: false,
        eulaVersion: (1, 0),
        optimalAnimationFrame: 0.0,
        cecID: 0);
    expect(appSettings1, equals(appSettings2));
  });

  test("matchmaker IDs", () {
    final mmIds1 = MatchMakerIDs(matchMakerID: 42, matchMakerBitID: 50);
    final mmIds2 = MatchMakerIDs(matchMakerID: 42, matchMakerBitID: 50);
    expect(mmIds1, equals(mmIds2));
  });

  group('round trip', () {
    test('write and read', () async {
      final smallIcon = SmdhIcon(ByteData(24 * 24 * 2));
      final largeIcon = SmdhIcon(ByteData(48 * 48 * 2));
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
      expect(smdhInput.largeIcon, smdhOutput.largeIcon);
      expect(smdhOutput, equals(smdhInput));
    });
  });
}
