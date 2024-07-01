import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
///
/// Object that holds value label data and converts it to
/// [FlLine] for display on [LineChart] as vertical line
/// with label.
class DiagramXValueLabel {
  final String caption;
  final double value;
  final Color color;
  final TextStyle style;
  ///
  /// Creates object that holds value label data and converts it to
  /// [FlLine] for display on [LineChart] as vertical line
  /// with label for provided `value` with label to right of it.
  DiagramXValueLabel({
    required this.caption,
    required this.value,
    required this.color,
    required this.style,
  });
  ///
  /// Returns [VerticalLine] to be displayed on [LineChart].
  VerticalLine label() => VerticalLine(
        x: value,
        dashArray: [5, 10],
        color: color,
        label: VerticalLineLabel(
          show: true,
          alignment: Alignment.topRight,
          style: style.copyWith(color: color),
          labelResolver: (_) => caption,
        ),
      );
}
