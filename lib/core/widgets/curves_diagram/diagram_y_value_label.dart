import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
///
/// Object that holds value label data and converts it to
/// [FlLine] for display on [LineChart] as horizontal line
/// with label over it.
class DiagramYValueLabel {
  final String caption;
  final double value;
  final Color color;
  final TextStyle style;
  ///
  /// Creates object that holds value label data and converts it to
  /// [FlLine] for display on [LineChart] as horizontal line
  /// for provided `value` with label over it .
  DiagramYValueLabel({
    required this.caption,
    required this.value,
    required this.color,
    required this.style,
  });
  ///
  /// Returns [HorizontalLine] to be displayed on [LineChart].
  HorizontalLine label() => HorizontalLine(
        y: value,
        dashArray: [5, 10],
        color: color,
        label: HorizontalLineLabel(
          show: true,
          alignment: Alignment.topRight,
          style: style.copyWith(color: color),
          labelResolver: (_) => caption,
        ),
      );
}
