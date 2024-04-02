import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/axis_painter.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/chart_axis.dart';

///
class ShipSchemeAxis extends StatelessWidget {
  final ChartAxis _axis;
  final double _crossAxisOffset;
  final double _minValue;
  final double _maxValue;
  final Color _color;
  final bool _reversed;
  final double _valueShift;
  final double _valueScale;
  final double _thickness;
  final TextStyle? _labelStyle;

  ///
  const ShipSchemeAxis({
    super.key,
    required ChartAxis axis,
    required double minValue,
    required double maxValue,
    required Color color,
    bool reversed = false,
    double crossAxisOffset = 0.0,
    double valueShift = 0.0,
    double valueScale = 1.0,
    double thickness = 1.0,
    TextStyle? labelStyle,
  })  : _reversed = reversed,
        _axis = axis,
        _crossAxisOffset = crossAxisOffset,
        _maxValue = maxValue,
        _minValue = minValue,
        _valueShift = valueShift,
        _valueScale = valueScale,
        _color = color,
        _labelStyle = labelStyle,
        _thickness = thickness;

  ///
  @override
  Widget build(BuildContext context) {
    final (majorTicks, minorTicks) = _getAxisLabels(
      _minValue,
      _maxValue,
      _axis,
    );
    return CustomPaint(
      painter: AxisPainter(
        axis: _axis,
        crossAxisOffset: _crossAxisOffset,
        reversed: _reversed,
        color: _color,
        thickness: _thickness,
        labelStyle: _labelStyle,
        valueShift: _valueShift,
        valueScale: _valueScale,
        majorAxisTicks: majorTicks,
        minorAxisTicks: minorTicks,
      ),
    );
  }

  /// Returns multiples of [divisor] less than or equal to [max]
  List<double> _getMultiples(double divisor, double max) {
    return List<double>.generate(
      max ~/ divisor + 1,
      (idx) => (idx * divisor),
    );
  }

  ///
  (List<(double, String)>, List<double>) _getAxisLabels(
    double minValue,
    double maxValue,
    ChartAxis axis,
  ) {
    final majorOffset = minValue.abs() % axis.valueInterval;
    final majorTicks = _getMultiples(
      axis.valueInterval,
      (maxValue - minValue),
    )
        .map((multiple) => (
              minValue + majorOffset + multiple,
              '${(minValue + multiple + majorOffset).toInt()}${axis.caption}',
            ))
        .toList();
    final minorOffset = minValue.abs() % (axis.valueInterval / 5.0);
    final minorTicks = _getMultiples(
      axis.valueInterval / 5.0,
      (maxValue - minValue),
    ).map((multiple) => minValue + minorOffset + multiple).toList();
    return (majorTicks, minorTicks);
  }
}
