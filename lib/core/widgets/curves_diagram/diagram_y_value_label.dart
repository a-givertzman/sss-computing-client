import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
///
/// Object that holds value label data and converts it to
/// [FlLine] for display on [LineChart] as horizontal line
/// with label over it.
class DiagramYValueLabel {
  final String _caption;
  final double _value;
  final Color _color;
  final TextStyle _style;
  ///
  /// Creates object that holds value label data and converts it to
  /// [FlLine] for display on [LineChart] as horizontal line
  /// for provided [value] with label over it .
  DiagramYValueLabel({
    required String caption,
    required double value,
    required Color color,
    required TextStyle style,
  })  : _caption = caption,
        _value = value,
        _color = color,
        _style = style;
  ///
  /// Returns [HorizontalLine] to be displayed on [LineChart].
  HorizontalLine label() => HorizontalLine(
        y: _value,
        dashArray: [5, 10],
        color: _color,
        label: HorizontalLineLabel(
          show: true,
          alignment: Alignment.topRight,
          style: _style.copyWith(color: _color),
          labelResolver: (_) => _caption,
        ),
      );
}
