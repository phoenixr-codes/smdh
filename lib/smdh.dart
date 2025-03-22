// TODO: missing trailing zeroes on icons

import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';

bool _bitAt(int bytes, int position) {
  return ((bytes >> position) & 1) == 1;
}

void _writeStringToByteData(ByteData data, int offset, String s) {
  for (final (index, codeUnit) in s.codeUnits.indexed) {
    data.setUint16(offset + index * 2, codeUnit, Endian.little);
  }
}

final magic = utf8.encode('SMDH');
const shortDescriptionMaxLength = 0x80;
const longDescriptionMaxLength = 0x100;
const publisherMaxLength = 0x80;

enum Language {
  japanese,
  english,
  french,
  german,
  italian,
  spanish,
  simplifiedChinese,
  korean,
  dutch,
  portuguese,
  russian,
  traditionalChinese,
}

enum RegionSpecificGameAgeRating {
  /// CERO (Japan)
  cero,

  /// ESRB (USA)
  esrb,

  /// USK (German)
  usk,

  /// PEGI GEN (Europe)
  pegiGen,

  /// PEGI PRT (Portugal)
  pegiPrt,

  /// PEGI BBFC (England)
  pegiBbfc,

  /// COB (Australia)
  cob,

  /// GRB (SouthKorea)
  grb,

  /// CGSRR (Taiwan)
  cgsrr,
}

enum RegionLockout {
  /// Japan.
  japan,

  /// North America.
  northAmerica,

  /// Europe.
  ///
  /// NOTE: To enable `europe` also enable `australia`.
  europe,

  /// Australia.
  australia,

  /// China.
  china,

  /// Korea.
  korea,

  /// Taiwan.
  taiwan,
}

class ApplicationTitle {
  final String shortDescription;
  final String longDescription;
  final String publisher;

  ApplicationTitle({
    required this.shortDescription,
    required this.longDescription,
    required this.publisher,
  })  : assert(shortDescription.codeUnits.length <= shortDescriptionMaxLength),
        assert(longDescription.codeUnits.length <= longDescriptionMaxLength),
        assert(publisher.codeUnits.length <= publisherMaxLength);

  @override
  String toString() =>
      'ApplicationTitle(shortDescription: "$shortDescription", longDescription: "$longDescription", publisher: "$publisher")';

  @override
  bool operator ==(Object other) =>
      other is ApplicationTitle &&
      other.shortDescription == shortDescription &&
      other.longDescription == longDescription &&
      other.publisher == publisher;

  @override
  int get hashCode => Object.hash(shortDescription, longDescription, publisher);
}

class MatchMakerIDs {
  final int matchMakerID;
  final int matchMakerBitID;

  MatchMakerIDs({required this.matchMakerID, required this.matchMakerBitID});

  @override
  String toString() =>
      'MatchMakerIDs(matchMakerID: $matchMakerID, matchMakerBitID: $matchMakerBitID)';

  @override
  bool operator ==(Object other) =>
      other is MatchMakerIDs &&
      other.matchMakerID == matchMakerID &&
      other.matchMakerBitID == matchMakerBitID;

  @override
  int get hashCode => Object.hash(matchMakerID, matchMakerBitID);
}

class ApplicationSettings {
  final Set<RegionSpecificGameAgeRating> regionSpecificGameAgeRatings;
  final Set<RegionLockout> regionLockout;
  final MatchMakerIDs matchMakerIDs;

  /// Visibility Flag (eequired for visibility on the Home Menu).
  final bool visible;

  /// Whether to auto-boot this gamecard title.
  final bool autoBoot;

  /// Whether the use of 3D is allowed.
  ///
  /// This flag is only used in context of parental controls. An application
  /// can still use the 3D effct, even when this flag is not set.
  final bool allow3d;

  /// Require accepting CTR EULA before being launched by Home.
  final bool requireAcceptingCtrEulaBeforeLaunch;

  /// Whether autosave happens on exit.
  final bool autosave;

  /// Whether an extended banner is used.
  final bool extendedBanner;

  /// Whether region game rating is required.
  final bool requireRegionGameRating;

  /// Whether save data is used.
  final bool usesSaveData;

  /// Whether application usage is to be recorded.
  ///
  /// If this is not set, it causes the application's usage to be omitted from
  /// the Home Menu's icon cache, as well as in other places.
  final bool record;

  /// Disables SD Savedata Backups for this title.
  ///
  /// This is in addition to the blacklist.
  final bool sdSavedataBackup;

  /// Whether this is a New 3DS exclusive title.
  ///
  /// Shows an error if used on Old 3DS.
  final bool new3dsExclusive;

  /// The EULA version (major, minor).
  final (int, int) eulaVersion;

  /// The preferred (or 'most representative') frame for the banner animation.
  final double optimalAnimationFrame;

  /// CEC (StreetPass) ID.
  final int cecID;

  ApplicationSettings({
    this.regionSpecificGameAgeRatings = const {},
    this.regionLockout = const {},
    required this.matchMakerIDs,
    this.visible = true,
    this.autoBoot = false,
    this.allow3d = true,
    this.requireAcceptingCtrEulaBeforeLaunch = false,
    required this.autosave,
    this.extendedBanner = false,
    this.requireRegionGameRating = false,
    required this.usesSaveData,
    this.record = true,
    this.sdSavedataBackup = true,
    this.new3dsExclusive = false,
    required this.eulaVersion,
    required this.optimalAnimationFrame,
    required this.cecID,
  });

  @override
  String toString() =>
      'ApplicationSettings(regionSpecificGameAgeRatings: $regionSpecificGameAgeRatings, regionLockout: $regionLockout, matchMakerIDs: $matchMakerIDs, visible: $visible, autoBoot: $autoBoot, allow3d: $allow3d, requireAcceptingCtrEulaBeforeLaunch: $requireAcceptingCtrEulaBeforeLaunch, autosave: $autosave, extendedBanner: $extendedBanner, requireRegionGameRating: $requireRegionGameRating, usesSaveData: $usesSaveData, record: $record, sdSavedataBackup: $sdSavedataBackup, new3dsExclusive: $new3dsExclusive, eulaVersion: $eulaVersion, optimalAnimationFrame: $optimalAnimationFrame, cecID: $cecID)';

  @override
  bool operator ==(Object other) =>
      other is ApplicationSettings &&
      SetEquality().equals(
          other.regionSpecificGameAgeRatings, regionSpecificGameAgeRatings) &&
      SetEquality().equals(other.regionLockout, regionLockout) &&
      other.matchMakerIDs == matchMakerIDs &&
      other.visible == visible &&
      other.autoBoot == autoBoot &&
      other.allow3d == allow3d &&
      other.requireAcceptingCtrEulaBeforeLaunch ==
          requireAcceptingCtrEulaBeforeLaunch &&
      other.autosave == autosave &&
      other.extendedBanner == extendedBanner &&
      other.usesSaveData == usesSaveData &&
      other.record == record &&
      other.sdSavedataBackup == sdSavedataBackup &&
      other.new3dsExclusive == new3dsExclusive &&
      other.eulaVersion == eulaVersion &&
      other.optimalAnimationFrame == optimalAnimationFrame &&
      other.cecID == cecID;

  @override
  int get hashCode => Object.hash(
        regionSpecificGameAgeRatings,
        regionLockout,
        matchMakerIDs,
        visible,
        autoBoot,
        allow3d,
        requireAcceptingCtrEulaBeforeLaunch,
        autosave,
        extendedBanner,
        regionSpecificGameAgeRatings,
        usesSaveData,
        record,
        sdSavedataBackup,
        new3dsExclusive,
        eulaVersion,
        optimalAnimationFrame,
        cecID,
      );
}

typedef Icon = Uint8List;

class Smdh {
  // TODO: is it really in (major, minor) format?
  late (int, int) version;

  late Map<Language, ApplicationTitle> applicationTitles;

  late ApplicationSettings applicationSettings;

  /// Icon of size 24x24 displayed on top screen when pausing the app.
  late Icon smallIcon;

  /// Icon of size 48x48.
  late Icon largeIcon;

  Smdh({
    required this.version,
    required this.applicationTitles,
    required this.applicationSettings,
    required this.smallIcon,
    required this.largeIcon,
  })  : assert(smallIcon.length == 0x480, "Invalid length for small icon"),
        assert(largeIcon.length == 0x1200, "Invalid length for large icon");

  Smdh.parse(ByteData data) {
    final magicInData = [
      data.getUint8(0x0),
      data.getUint8(0x1),
      data.getUint8(0x2),
      data.getUint8(0x3),
    ];
    if (!ListEquality().equals(magicInData, magic)) {
      throw Exception('Invalid magic file header ($magicInData != $magic)');
    }

    final versionMajor = data.getUint8(0x4);
    final versionMinor = data.getUint8(0x5);
    version = (versionMinor, versionMajor);

    applicationTitles = {};
    for (final (i, language) in Language.values.indexed) {
      final offset = 0x8 + 0x200 * i;
      final List<int> codeUnits = [];
      for (int j = 0; j < shortDescriptionMaxLength / 2; j++) {
        final codeUnit = data.getUint16(offset + j * 2, Endian.little);
        if (codeUnit != 0) codeUnits.add(codeUnit);
      }
      final shortDescription = String.fromCharCodes(codeUnits);

      codeUnits.clear();
      for (int j = 0; j < longDescriptionMaxLength / 2; j++) {
        final codeUnit = data.getUint16(
            offset + shortDescriptionMaxLength + j * 2, Endian.little);
        if (codeUnit != 0) codeUnits.add(codeUnit);
      }
      final longDescription = String.fromCharCodes(codeUnits);

      codeUnits.clear();
      for (int j = 0; j < publisherMaxLength / 2; j++) {
        final codeUnit = data.getUint16(
            offset +
                shortDescriptionMaxLength +
                longDescriptionMaxLength +
                j * 2,
            Endian.little);
        if (codeUnit != 0) codeUnits.add(codeUnit);
      }
      final publisher = String.fromCharCodes(codeUnits);

      applicationTitles[language] = ApplicationTitle(
        shortDescription: shortDescription,
        longDescription: longDescription,
        publisher: publisher,
      );
    }

    int block;

    final regionSpecificGameAgeRatings = <RegionSpecificGameAgeRating>{};
    block = data.getUint16(0x2008, Endian.little);
    // FIXME: is the order below correct?
    if (_bitAt(block, 0)) {
      regionSpecificGameAgeRatings.add(RegionSpecificGameAgeRating.cero);
    }
    if (_bitAt(block, 1)) {
      regionSpecificGameAgeRatings.add(RegionSpecificGameAgeRating.esrb);
    }
    if (_bitAt(block, 3)) {
      regionSpecificGameAgeRatings.add(RegionSpecificGameAgeRating.usk);
    }
    if (_bitAt(block, 4)) {
      regionSpecificGameAgeRatings.add(RegionSpecificGameAgeRating.pegiGen);
    }
    if (_bitAt(block, 6)) {
      regionSpecificGameAgeRatings.add(RegionSpecificGameAgeRating.pegiPrt);
    }
    if (_bitAt(block, 7)) {
      regionSpecificGameAgeRatings.add(RegionSpecificGameAgeRating.pegiBbfc);
    }
    if (_bitAt(block, 8)) {
      regionSpecificGameAgeRatings.add(RegionSpecificGameAgeRating.cob);
    }
    if (_bitAt(block, 9)) {
      regionSpecificGameAgeRatings.add(RegionSpecificGameAgeRating.grb);
    }
    if (_bitAt(block, 10)) {
      regionSpecificGameAgeRatings.add(RegionSpecificGameAgeRating.cgsrr);
    }

    final regionLockout = <RegionLockout>{};
    block = data.getUint32(0x2018, Endian.little);
    if (block & 0x01 != 0) regionLockout.add(RegionLockout.japan);
    if (block & 0x02 != 0) regionLockout.add(RegionLockout.northAmerica);
    if (block & 0x04 != 0) regionLockout.add(RegionLockout.europe);
    if (block & 0x08 != 0) regionLockout.add(RegionLockout.australia);
    if (block & 0x10 != 0) regionLockout.add(RegionLockout.china);
    if (block & 0x20 != 0) regionLockout.add(RegionLockout.korea);
    if (block & 0x40 != 0) regionLockout.add(RegionLockout.taiwan);

    final matchMakerIDs = MatchMakerIDs(
      matchMakerID: data.getUint8(0x201C),
      matchMakerBitID: data.getUint16(0x2020),
    );

    applicationSettings = ApplicationSettings(
      regionSpecificGameAgeRatings: regionSpecificGameAgeRatings,
      regionLockout: regionLockout,
      matchMakerIDs: matchMakerIDs,
      visible: data.getUint32(0x2028, Endian.little) & 0x0001 != 0,
      autoBoot: data.getUint32(0x2028, Endian.little) & 0x0002 != 0,
      allow3d: data.getUint32(0x2028, Endian.little) & 0x0004 != 0,
      requireAcceptingCtrEulaBeforeLaunch:
          data.getUint32(0x2028, Endian.little) & 0x0008 != 0,
      autosave: data.getUint32(0x2028, Endian.little) & 0x0010 != 0,
      extendedBanner: data.getUint32(0x2028, Endian.little) & 0x0020 != 0,
      requireRegionGameRating:
          data.getUint32(0x2028, Endian.little) & 0x0040 != 0,
      usesSaveData: data.getUint32(0x2028, Endian.little) & 0x0080 != 0,
      record: data.getUint32(0x2028, Endian.little) & 0x0100 != 0,
      sdSavedataBackup: data.getUint32(0x2028, Endian.little) & 0x0400 ==
          0, // NOTE: `==` is intentional here
      new3dsExclusive: data.getUint32(0x2028, Endian.little) & 0x1000 != 0,
      eulaVersion: (data.getUint8(0x202C), data.getUint8(0x202D)),
      optimalAnimationFrame: data.getFloat32(0x2030),
      cecID: data.getUint32(0x2034),
    );

    final bytes = data.buffer.asUint8List();
    smallIcon =
        Uint8List.fromList(bytes.getRange(0x2040, 0x2040 + 0x480).toList());
    largeIcon =
        Uint8List.fromList(bytes.getRange(0x24C0, 0x24C0 + 0x1200).toList());
  }

  ByteData toByteData() {
    final data = ByteData(0x2040 + 0x1680);
    data.setUint8(0x0, magic[0]);
    data.setUint8(0x1, magic[1]);
    data.setUint8(0x2, magic[2]);
    data.setUint8(0x3, magic[3]);
    data.setUint8(0x4, version.$2);
    data.setUint8(0x5, version.$1);

    applicationTitles.forEach((language, applicationTitle) {
      final offset = 0x8 + 0x200 * language.index;
      _writeStringToByteData(
        data,
        offset,
        applicationTitle.shortDescription,
      );
      _writeStringToByteData(
        data,
        offset + shortDescriptionMaxLength,
        applicationTitle.longDescription,
      );
      _writeStringToByteData(
        data,
        offset + shortDescriptionMaxLength + longDescriptionMaxLength,
        applicationTitle.publisher,
      );
    });

    for (final flag in applicationSettings.regionSpecificGameAgeRatings) {
      switch (flag) {
        case RegionSpecificGameAgeRating.cero:
          data.setUint8(0x2008, 1);
        case RegionSpecificGameAgeRating.esrb:
          data.setUint8(0x2009, 1);
        case RegionSpecificGameAgeRating.usk:
          data.setUint8(0x200B, 1);
        case RegionSpecificGameAgeRating.pegiGen:
          data.setUint8(0x200C, 1);
        case RegionSpecificGameAgeRating.pegiPrt:
          data.setUint8(0x200E, 1);
        case RegionSpecificGameAgeRating.pegiBbfc:
          data.setUint8(0x200F, 1);
        case RegionSpecificGameAgeRating.cob:
          data.setUint8(0x2010, 1);
        case RegionSpecificGameAgeRating.grb:
          data.setUint8(0x2011, 1);
        case RegionSpecificGameAgeRating.cgsrr:
          data.setUint8(0x2012, 1);
      }
    }

    var regionLockoutFlag = 0;
    for (final regionLockout in applicationSettings.regionLockout) {
      switch (regionLockout) {
        case RegionLockout.japan:
          regionLockoutFlag |= 0x01;
        case RegionLockout.northAmerica:
          regionLockoutFlag |= 0x02;
        case RegionLockout.europe:
          regionLockoutFlag |= 0x04;
        case RegionLockout.australia:
          regionLockoutFlag |= 0x08;
        case RegionLockout.china:
          regionLockoutFlag |= 0x10;
        case RegionLockout.korea:
          regionLockoutFlag |= 0x20;
        case RegionLockout.taiwan:
          regionLockoutFlag |= 0x40;
      }
    }
    data.setUint32(0x2018, regionLockoutFlag, Endian.little);

    data.setUint32(0x201C, applicationSettings.matchMakerIDs.matchMakerID);
    data.setUint64(0x2020, applicationSettings.matchMakerIDs.matchMakerBitID);

    var flags = 0;
    if (applicationSettings.visible) {
      flags |= 0x0001;
    }
    if (applicationSettings.autoBoot) {
      flags |= 0x0002;
    }
    if (applicationSettings.allow3d) {
      flags |= 0x0004;
    }
    if (applicationSettings.requireAcceptingCtrEulaBeforeLaunch) {
      flags |= 0x0008;
    }
    if (applicationSettings.autosave) {
      flags |= 0x0010;
    }
    if (applicationSettings.extendedBanner) {
      flags |= 0x0020;
    }
    if (applicationSettings.requireRegionGameRating) {
      flags |= 0x0040;
    }
    if (applicationSettings.usesSaveData) {
      flags |= 0x0080;
    }
    if (applicationSettings.record) {
      flags |= 0x0100;
    }
    if (!applicationSettings.sdSavedataBackup) {
      flags |= 0x0400;
    }
    if (applicationSettings.new3dsExclusive) {
      flags |= 0x1000;
    }
    data.setUint32(0x2028, flags, Endian.little);

    data.setUint8(0x202C, applicationSettings.eulaVersion.$1);
    data.setUint8(0x202D, applicationSettings.eulaVersion.$2);
    data.setFloat32(0x2030, applicationSettings.optimalAnimationFrame);
    data.setUint32(0x2034, applicationSettings.cecID);

    for (final (i, byte) in smallIcon.buffer.asUint8List().indexed) {
      data.setUint8(0x2040 + i, byte);
      if (i >= 0x480) throw 'Small icon is too large';
    }
    for (final (i, byte) in largeIcon.buffer.asUint8List().indexed) {
      data.setUint8(0x24C0 + i, byte);
      if (i >= 0x1200) throw 'Large icon is too large';
    }

    return data;
  }

  @override
  String toString() =>
      'Smdh(version: $version, applicationTitles: $applicationTitles, applicationSettings: $applicationSettings, smallIcon: $smallIcon, largeIcon: $largeIcon)';

  @override
  bool operator ==(Object other) =>
      other is Smdh &&
      other.version == version &&
      MapEquality().equals(other.applicationTitles, applicationTitles) &&
      other.applicationSettings == applicationSettings &&
      ListEquality().equals(other.smallIcon, smallIcon) &&
      ListEquality().equals(other.largeIcon, largeIcon);

  @override
  int get hashCode => Object.hash(
        version,
        applicationTitles,
        applicationSettings,
        smallIcon,
        largeIcon,
      );
}
