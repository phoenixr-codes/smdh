import 'package:smdh/smdh.dart';
import 'package:test/test.dart';

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
}
