///
/// A contract for markdown patterns.
abstract class MDPattern {
  /// The pattern to match.
  RegExp get pattern;
  /// Checks if the text matches the pattern.
  bool isMatch(String text);
}
///
/// Pattern for markdown SVG.
final class SVGPattern implements MDPattern {
  @override
  RegExp get pattern =>
      RegExp(r'<svg[^>]*>', multiLine: true, caseSensitive: true);
  ///
  @override
  bool isMatch(String text) {
    return text.contains(pattern);
  }
}
