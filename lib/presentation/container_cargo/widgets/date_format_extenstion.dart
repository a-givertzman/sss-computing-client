extension DateTimeFormatExtension on DateTime {
  ///
  /// Returns [DateTime] in format 'dd.mm.yy hh:mm'
  String formatRU() {
    final dayFormatted = padNumber(day);
    final monthFormatted = padNumber(month);
    final yearFormatted = padNumber(year);
    final hourFormatted = padNumber(hour);
    final minuteFormatted = padNumber(minute);
    final timeZone =
        '${timeZoneOffset.isNegative ? '' : '+'}${timeZoneOffset.inHours}';
    return '$dayFormatted.$monthFormatted.$yearFormatted $hourFormatted:$minuteFormatted $timeZone';
  }
  //
  String padNumber(int number, {int width = 2}) =>
      '$number'.padLeft(width, '0');
}
