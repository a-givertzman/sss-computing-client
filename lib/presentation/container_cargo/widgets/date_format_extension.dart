///
/// Format DateTime to 'dd.mm.yy hh:mm'
extension DateTimeFormatExtension on DateTime {
  ///
  /// Returns [DateTime] in format 'dd.mm.yy hh:mm'
  String formatRU() {
    final dayFormatted = _padNumber(day);
    final monthFormatted = _padNumber(month);
    final yearFormatted = _padNumber(year);
    final hourFormatted = _padNumber(hour);
    final minuteFormatted = _padNumber(minute);
    final timeZone =
        '${timeZoneOffset.isNegative ? '' : '+'}${timeZoneOffset.inHours}';
    return '$dayFormatted.$monthFormatted.$yearFormatted $hourFormatted:$minuteFormatted $timeZone';
  }
  //
  String _padNumber(int number, {int width = 2}) =>
      '$number'.padLeft(width, '0');
}
