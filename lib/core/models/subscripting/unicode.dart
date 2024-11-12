///
/// Unicode class for subscript and superscript
class AppUnicode {
  /// Unicode subscript
  final String subs;

  /// Unicode superscript
  final String sup;

  const AppUnicode(this.subs, this.sup);

  factory AppUnicode.fromMap(Map<String, dynamic> map) {
    return AppUnicode(map['subs'], map['sup']);
  }
}
