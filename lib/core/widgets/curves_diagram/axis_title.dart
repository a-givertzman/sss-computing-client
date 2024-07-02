import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
///
/// Displays title for axis value.
class AxisTitle extends StatelessWidget {
  final double _value;
  final double _valueInterval;
  final TitleMeta _meta;
  final Color _color;
  ///
  /// Creates widget displaying title for axis value.
  ///
  /// `value` is value for wich title is displayed.
  /// `meta` and `color` determine appearance for title and
  /// `valueInterval` used to filter displayed values,
  /// if `valueInterval` is divisor of `value` then title will be rendered.
  const AxisTitle({
    super.key,
    required double value,
    required double valueInterval,
    required TitleMeta meta,
    required Color color,
  })  : _value = value,
        _valueInterval = valueInterval,
        _meta = meta,
        _color = color;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelSmall ?? const TextStyle();
    return SideTitleWidget(
      axisSide: _meta.axisSide,
      fitInside: SideTitleFitInsideData.fromTitleMeta(
        _meta,
        distanceFromEdge: 0.0,
      ),
      child: Text(
        _value % _valueInterval == 0 ? '$_value' : '',
        style: textStyle.copyWith(color: _color),
      ),
    );
  }
}
