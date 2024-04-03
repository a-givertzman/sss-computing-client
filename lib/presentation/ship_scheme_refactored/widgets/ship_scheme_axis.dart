import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/axis_painter.dart';
import 'package:sss_computing_client/presentation/core/models/chart_axis.dart';

///
class ShipSchemeAxis extends StatelessWidget {
  final ChartAxis _axis;
  final double _crossAxisOffset;
  final double _minValue;
  final double _maxValue;
  final Color _color;
  final Color? _gridColor;
  final double _thickness;
  final TextStyle? _labelStyle;
  final List<(double, String)>? _majorTicks;
  final List<double>? _minorTicks;
  final double Function(double) _transformValue;

  ///
  const ShipSchemeAxis({
    super.key,
    required ChartAxis axis,
    required double minValue,
    required double maxValue,
    required Color color,
    Color? gridColor,
    double crossAxisOffset = 0.0,
    double thickness = 1.0,
    TextStyle? labelStyle,
    List<(double, String)>? majorTicks,
    List<double>? minorTicks,
    required double Function(double) transformValue,
  })  : _transformValue = transformValue,
        _gridColor = gridColor,
        _axis = axis,
        _crossAxisOffset = crossAxisOffset,
        _maxValue = maxValue,
        _minValue = minValue,
        _color = color,
        _labelStyle = labelStyle,
        _thickness = thickness,
        _majorTicks = majorTicks,
        _minorTicks = minorTicks;

  ///
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AxisPainter(
        axis: _axis,
        crossAxisOffset: _crossAxisOffset,
        color: _color,
        gridColor: _gridColor,
        thickness: _thickness,
        labelStyle: _labelStyle,
        transformValue: _transformValue,
        majorAxisTicks: _majorTicks ??
            _getMajorTicks(
              _minValue,
              _maxValue,
              _axis,
            ),
        minorAxisTicks: _minorTicks ??
            _gitMinorTicks(
              _minValue,
              _maxValue,
              _axis,
            ),
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
  List<(double, String)> _getMajorTicks(
    double minValue,
    double maxValue,
    ChartAxis axis,
  ) {
    final offset = minValue.abs() % axis.valueInterval;
    return _getMultiples(axis.valueInterval, (maxValue - minValue))
        .map((multiple) => (
              minValue + offset + multiple,
              '${(minValue + multiple + offset).toInt()}${axis.caption}',
            ))
        .toList();
  }

  ///
  List<double> _gitMinorTicks(
    double minValue,
    double maxValue,
    ChartAxis axis,
  ) {
    final offset = minValue.abs() % (axis.valueInterval / 5.0);
    return _getMultiples(axis.valueInterval / 5.0, (maxValue - minValue))
        .map((multiple) => minValue + offset + multiple)
        .toList();
  }
}
