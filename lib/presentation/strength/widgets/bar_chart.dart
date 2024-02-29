import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_axis.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_bars.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_layout.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_lines.dart';

class BarChart extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final List<double?> _values;
  final List<double?> _widths;
  final List<double?> _lowLimits;
  final List<double?> _highLimits;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  const BarChart({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required List<double?> values,
    required List<double?> widths,
    required List<double?> lowLimits,
    required List<double?> highLimits,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _values = values,
        _widths = widths,
        _lowLimits = lowLimits,
        _highLimits = highLimits,
        _xAxis = xAxis,
        _yAxis = yAxis;

  @override
  Widget build(BuildContext context) {
    final verticalPad =
        _xAxis.labelsSpaceReserved + _xAxis.captionSpaceReserved;
    final horizontalPad =
        _yAxis.labelsSpaceReserved + _yAxis.captionSpaceReserved;
    final layoutBottomPad = verticalPad -
        (_xAxis.isLabelsVisible ? _xAxis.labelsSpaceReserved : 0.0) -
        (_xAxis.caption != null ? _xAxis.captionSpaceReserved : 0.0);
    final layoutLetfPad = horizontalPad -
        (_yAxis.isLabelsVisible ? _yAxis.labelsSpaceReserved : 0.0) -
        (_yAxis.caption != null ? _yAxis.captionSpaceReserved : 0.0);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPad,
            vertical: verticalPad,
          ),
          child: ChartBars(
            values: _values,
            widths: _widths,
            minX: _minX,
            maxX: _maxX,
            minY: _minY,
            maxY: _maxY,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPad,
            vertical: verticalPad,
          ),
          child: ChartLines(
            minX: _minX,
            maxX: _maxX,
            minY: _minY,
            maxY: _maxY,
            values: _lowLimits,
            widths: _widths,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPad,
            vertical: verticalPad,
          ),
          child: ChartLines(
            minX: _minX,
            maxX: _maxX,
            minY: _minY,
            maxY: _maxY,
            values: _highLimits,
            widths: _widths,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            layoutLetfPad,
            verticalPad,
            horizontalPad,
            layoutBottomPad,
          ),
          child: ChartLayout(
            minX: _minX,
            maxX: _maxX,
            minY: _minY,
            maxY: _maxY,
            xAxis: _xAxis,
            yAxis: _yAxis,
          ),
        ),
      ],
    );
  }
}
