import 'dart:io';

import 'package:smdh/smdh.dart';

void main() async {
  final smallIcon = await File('smallIcon.jpg').readAsBytes();
  final largeIcon = await File('largeIcon.jpg').readAsBytes();
  final Map<Language, ApplicationTitle> applicationTitles = {};
  for (final language in Language.values) {
    applicationTitles[language] = ApplicationTitle(
      shortDescription: 'Hello in ${language.name}',
      longDescription: 'Hello in ${language.name}',
      publisher: 'World',
    );
  }
  final smdh = Smdh(
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
  stdout.add(smdh.toByteData().buffer.asUint8List().toList());
}
