import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/charts/chart_axis.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart_widget/chart_bars.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart_widget/chart_layout.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart_widget/chart_lines.dart';
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
  final List<StrengthForce> _strengthForces;
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
    required List<StrengthForce> strengthForces,
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
        _strengthForces = strengthForces;
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
    final List<double?> yValues =
        _strengthForces.map((force) => force.value).toList();
    final List<(double, double)?> xOffsets = _strengthForces
        .map((force) => (force.frameSpace.start, force.frameSpace.end))
        .toList();
    final List<String?> barCaptions =
        _strengthForces.map((force) => '[${force.frameSpace.index}]').toList();
    final List<double?> lowLimits =
        _strengthForces.map((force) => force.lowLimit).toList();
    final List<double?> highLimits =
        _strengthForces.map((force) => force.highLimit).toList();
    final minX = _minX ?? _getMinX(xOffsets);
    final maxX = _maxX ?? _getMaxX(xOffsets);
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
              yValues: yValues,
              lowLimits: lowLimits,
              highLimits: highLimits,
              xOffsets: xOffsets,
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              xAxis: _xAxis,
              valueColor: _barColor,
              limitColor: _limitColor,
              axisColor: _axisColor,
              textStyle: _textStyle,
              barCaptions: barCaptions,
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
              yValues: lowLimits,
              xOffsets: xOffsets,
              valueColor: _limitColor,
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
              yValues: highLimits,
              xOffsets: xOffsets,
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
