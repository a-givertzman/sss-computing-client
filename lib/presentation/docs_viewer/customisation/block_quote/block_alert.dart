import 'package:flutter/material.dart';

final regex = RegExp(
  r'\[!??(note|tip|important|caution|warning)\]',
  caseSensitive: false,
);

/// Block quote alerts
enum BlockQuoteAlert {
  note,
  tip,
  important,
  caution,
  warning;

  const BlockQuoteAlert();

  /// Create an alert from a quote, any text contains the Alert tag.
  factory BlockQuoteAlert.fromQuote(String quote) {
    final match = regex.firstMatch(quote)?.group(1);
    if (match == null) return BlockQuoteAlert.note;
    return BlockQuoteAlert.fromName(match);
  }

  /// Create an alert from a name
  /// The default is `Alert.note` if the name doesnt match any tag.
  factory BlockQuoteAlert.fromName(String name) {
    name = name.trim().toLowerCase();
    return values.firstWhere(
      (e) => name == e.name,
      orElse: () => BlockQuoteAlert.note,
    );
  }

  /// Returns true if the text contains the alert tag
  /// [exact] determines if the tag should be exact or not.
  ///
  bool matchQuote(String text, {bool exact = false}) {
    final quote = '[!${name.toUpperCase()}]';
    return switch (exact) {
      true => text == quote,
      false => text.contains(quote),
    };
  }

  /// Returns the text without the alert tag
  String extractPureText(String text) {
    return text.replaceAll(regex, '');
  }

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
