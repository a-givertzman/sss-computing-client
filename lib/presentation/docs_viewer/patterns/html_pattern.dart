import 'md_pattern.dart';
///
/// Pattern for markdown HTML.
final class HtmlPattern implements MDPattern {
  //
  @override
  bool isMatch(String text) => text.contains(pattern);
  //
  @override
  RegExp get pattern => RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
}
