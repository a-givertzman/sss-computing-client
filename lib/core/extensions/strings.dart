///
/// Extensions for [String]
extension StringExt on String {
  ///
  /// Pads [String] with [width] zeros
  String padNumber({int width = 2}) => padLeft(width, '0');
  ///
  /// If text is longer than [length] it will be truncated
  /// and [replaceText] will be added to the end
  String truncate({length = 150, replaceText = '...'}) {
    if (length >= this.length) {
      return this;
    }
    return replaceRange(length, this.length, replaceText);
  }
}
