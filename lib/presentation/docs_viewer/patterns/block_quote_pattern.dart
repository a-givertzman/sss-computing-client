import 'md_pattern.dart';

///
/// Pattern for block quotes.
/// - [!note] - [!tip] - [!important] - [!caution] - [!warning]
final class BlockQuotePattern implements MDPattern {
  /// Get the regex pattern.
  @override
  RegExp get pattern => RegExp(
        r'\[!??(note|tip|important|caution|warning)\]',
        caseSensitive: false,
      );

  @override
  bool isMatch(String text) {
    return text.contains(pattern);
  }
}
