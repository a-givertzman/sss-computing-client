import 'package:sss_computing_client/core/extensions/strings.dart';

/// DateTime extensions
extension DateTimeExt on DateTime {
  ///
  /// Formats the [DateTime] into a 'dd.mm.yy hh:mm tz' string.
  /// The timezone is set to local zone.
  String formatRU() {
    final tz =
        '${timeZoneOffset.isNegative ? '' : '+'}${timeZoneOffset.inHours}';
    return '${'$day'.padNumber()}.${'$month'.padNumber()}.${'$year'.substring(2)} ${'$hour'.padNumber()}:${'$minute'.padNumber()} $tz';
  }
}
