import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/charts/chart_axis.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart_widget/chart_bars.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart_widget/chart_layout.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart_widget/chart_lines.dart';
/// Common data for bar of [BarChartWidget]
class BarChartColumn {
  final double value;
  final (double, double) xBoundaries;
  final double lowLimit;
  final double highLimit;
  final String? caption;
  ///
  const BarChartColumn({
    required this.value,
    required this.xBoundaries,
    required this.lowLimit,
    required this.highLimit,
    this.caption,
  });
}
///
class BarChartWidget extends StatelessWidget {
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  final Color _barColor;
  final Color _axisColor;
  final Color _limitColor;
  final TextStyle? _textStyle;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final List<BarChartColumn> _columns;
  ///
  const BarChartWidget({
    super.key,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    required Color barColor,
    required Color axisColor,
    required Color limitColor,
    required TextStyle? textStyle,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required List<BarChartColumn> columns,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _barColor = barColor,
        _axisColor = axisColor,
        _limitColor = limitColor,
        _textStyle = textStyle,
        _xAxis = xAxis,
        _yAxis = yAxis,
        _columns = columns;
  //
  @override
  Widget build(BuildContext context) {
    final verticalPad =
        _xAxis.labelsSpaceReserved + _xAxis.captionSpaceReserved;
    final horizontalPad =
        _yAxis.labelsSpaceReserved + _yAxis.captionSpaceReserved;
    final layoutBottomPad = verticalPad -
        (_xAxis.isLabelsVisible ? _xAxis.labelsSpaceReserved : 0.0) -
        (_xAxis.isCaptionVisible ? _xAxis.captionSpaceReserved : 0.0);
    final layoutLetfPad = horizontalPad -
        (_yAxis.isLabelsVisible ? _yAxis.labelsSpaceReserved : 0.0) -
        (_yAxis.isCaptionVisible ? _yAxis.captionSpaceReserved : 0.0);
    final xBoundaries = _columns.map((col) => col.xBoundaries).toList();
    final yValues = _columns.map((col) => col.value).toList();
    final minX = _minX ?? _getMinX(xBoundaries);
    final maxX = _maxX ?? _getMaxX(xBoundaries);
    final minY = _minY ?? _getMinY(yValues);
    final maxY = _maxY ?? _getMaxY(yValues);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            layoutLetfPad,
            verticalPad,
            0.0,
            layoutBottomPad,
          ),
          child: ChartLayout(
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            xAxis: _xAxis,
            yAxis: _yAxis,
            axisColor: _axisColor,
            textStyle: _textStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPad,
            0.0,
            0.0,
            verticalPad,
          ),
          child: ClipRect(
            child: ChartBars(
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              xAxis: _xAxis,
              valueColor: _barColor,
              limitColor: _limitColor,
              axisColor: _axisColor,
              textStyle: _textStyle,
              columns: _columns,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPad,
            verticalPad,
            0.0,
            verticalPad,
          ),
          child: ClipRect(
            child: ChartLines(
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              columns: _columns,
              valueColor: _limitColor,
            ),
          ),
        ),
      ],
    );
  }
  ///
  double _getMinX(List<(double, double)?> offsets) => offsets.isEmpty
      ? 0.0
      : offsets.fold(offsets[0]?.$1 ?? 0.0, (prev, offset) {
          if (offset != null) {
            final (left, right) = offset;
            return min(min(left, right), prev);
          }
          return prev;
        });
  ///
  double _getMaxX(List<(double, double)?> offsets) => offsets.isEmpty
      ? 0.0
      : offsets.fold(offsets[0]?.$1 ?? 0.0, (prev, offset) {
          if (offset != null) {
            final (left, right) = offset;
            return max(max(left, right), prev);
          }
          return prev;
        });
  ///
  double _getMinY(List<double?> values) => values.isEmpty
      ? 0.0
      : values.fold(values[0] ?? 0.0, (prev, value) {
          if (value != null) return min(prev, value);
          return prev;
        });
  ///
  double _getMaxY(List<double?> values) => values.isEmpty
      ? 0.0
      : values.fold(values[0] ?? 0.0, (prev, value) {
          if (value != null) return max(prev, value);
          return prev;
        });
}
