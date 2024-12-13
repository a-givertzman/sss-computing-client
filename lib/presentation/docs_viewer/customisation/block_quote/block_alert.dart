import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/docs_viewer/patterns/block_quote_pattern.dart';
///
/// Block quote alerts
enum BlockQuoteAlert {
  /// alert for notes and reminders.
  note,
  /// alert for tips and hints.
  tip,
  /// alert for important information
  important,
  /// alert for caution
  caution,
  /// alert for warnings.
  warning;
  //
  const BlockQuoteAlert();
  ///
  /// Create an alert from a quote, any text contains the Alert tag.
  factory BlockQuoteAlert.fromQuote(String quote) {
    final match = BlockQuotePattern().pattern.firstMatch(quote)?.group(1);
    if (match == null) return BlockQuoteAlert.note;
    return BlockQuoteAlert.fromName(match);
  }
  ///
  /// Create an alert from a name
  /// The default is `Alert.note` if the name doesnt match any tag.
  factory BlockQuoteAlert.fromName(String name) {
    name = name.trim().toLowerCase();
    return values.firstWhere(
      (e) => name == e.name,
      orElse: () => BlockQuoteAlert.note,
    );
  }
  ///
  /// Returns true if the text contains the alert tag
  /// [exact] determines if the tag should be exact or not.
  bool matchQuote(String text, {bool exact = false}) {
    final quote = '[!${name.toUpperCase()}]';
    return switch (exact) {
      true => text == quote,
      false => text.contains(quote),
    };
  }
  ///
  /// Returns the text without the alert tag
  String extractPureText(String text) {
    return text.replaceAll(BlockQuotePattern().pattern, '');
  }
  ///
  /// Returns the color of the alert
  Color get color {
    switch (this) {
      case BlockQuoteAlert.note:
        return Colors.blue;
      case BlockQuoteAlert.tip:
        return Colors.green;
      case BlockQuoteAlert.important:
        return Colors.purpleAccent;
      case BlockQuoteAlert.caution:
        return Colors.red;
      case BlockQuoteAlert.warning:
        return Colors.orange;
    }
  }
  ///
  /// Returns the icon of the alert.
  IconData get icon {
    switch (this) {
      case BlockQuoteAlert.note:
        return Icons.info_outline;
      case BlockQuoteAlert.tip:
        return Icons.lightbulb_outline;
      case BlockQuoteAlert.important:
        return Icons.feedback_outlined;
      case BlockQuoteAlert.caution:
        return Icons.report_outlined;
      case BlockQuoteAlert.warning:
        return Icons.warning_amber_rounded;
    }
  }
}
