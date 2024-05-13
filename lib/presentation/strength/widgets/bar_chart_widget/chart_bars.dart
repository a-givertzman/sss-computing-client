import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/charts/chart_axis.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart_widget/bar_chart_widget.dart';
///
class ChartBars extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final ChartAxis _xAxis;
  final List<BarChartColumn> _columns;
  final Color _valueColor;
  final Color _limitColor;
  final Color _axisColor;
  final TextStyle? _textStyle;
  ///
  const ChartBars({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required ChartAxis xAxis,
    required List<BarChartColumn> columns,
    required Color valueColor,
    required Color limitColor,
    required Color axisColor,
    required TextStyle? textStyle,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _xAxis = xAxis,
        _columns = columns,
        _valueColor = valueColor,
        _limitColor = limitColor,
        _axisColor = axisColor,
        _textStyle = textStyle;
  //
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contstraints) {
      final xWidth = _maxX - _minX;
      final xAxisScale = contstraints.maxWidth / (xWidth == 0.0 ? 1.0 : xWidth);
      return BarChart(
        swapAnimationDuration: const Duration(milliseconds: 400),
        BarChartData(
          minY: _minY,
          maxY: _maxY,
          alignment: BarChartAlignment.start,
          groupsSpace: 0.0,
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize:
                    _xAxis.labelsSpaceReserved + _xAxis.captionSpaceReserved,
                getTitlesWidget: (value, _) => _AxisLabel(
                  value: _columns[value.toInt()].caption ?? '',
                  color: _axisColor,
                  textStyle: _textStyle,
                ),
              ),
            ),
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            bottomTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: [
            ..._columns.indexed.map(
              (columnIndexed) {
                final (index, column) = columnIndexed;
                final value = column.value;
                final (offsetL, offsetR) = column.xBoundaries;
                final lowLimit = column.lowLimit;
                final highLimit = column.highLimit;
                return BarChartGroupData(
                  x: index,
                  groupVertically: true,
                  barRods: [
                    BarChartRodData(
                      fromY: 0.0,
                      toY: value,
                      width: (offsetR - offsetL) * xAxisScale,
                      color: _valueColor,
                      borderRadius: const BorderRadius.all(Radius.zero),
                    ),
                    BarChartRodData(
                      fromY: highLimit,
                      toY: _maxY,
                      width: (offsetR - offsetL) * xAxisScale,
                      color: Colors.transparent,
                      gradient: (value < highLimit)
                          ? null
                          : _getLimitStripsGradient(
                              rawWidgetHeight: contstraints.maxHeight -
                                  contstraints.minHeight,
                              stripedBarHeight: (_maxY - highLimit),
                            ),
                      borderRadius: const BorderRadius.all(Radius.zero),
                    ),
                    BarChartRodData(
                      fromY: lowLimit,
                      toY: _minY,
                      width: (offsetR - offsetL) * xAxisScale,
                      color: Colors.transparent,
                      gradient: (value > lowLimit)
                          ? null
                          : _getLimitStripsGradient(
                              rawWidgetHeight: contstraints.maxHeight -
                                  contstraints.minHeight,
                              stripedBarHeight: (lowLimit - _minY),
                            ),
                      borderRadius: const BorderRadius.all(Radius.zero),
                    ),
                    BarChartRodData(
                      fromY: 0,
                      toY: _maxY,
                      width: (offsetR - offsetL) * xAxisScale,
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: _axisColor,
                      ),
                    ),
                    BarChartRodData(
                      fromY: _minY,
                      toY: 0,
                      width: (offsetR - offsetL) * xAxisScale,
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: _axisColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }
  ///
  LinearGradient _getLimitStripsGradient({
    required double rawWidgetHeight,
    required double stripedBarHeight,
  }) {
    const rawStripHeight = 5.0;
    final yAxisScale = (rawWidgetHeight -
            _xAxis.labelsSpaceReserved -
            _xAxis.captionSpaceReserved) /
        (_maxY - _minY);
    final stripFraction = rawStripHeight / (stripedBarHeight * yAxisScale);
    return LinearGradient(
      begin: const FractionalOffset(0, 0),
      end: FractionalOffset(0.0, 2 * stripFraction),
      transform: const GradientRotation(pi / 4),
      stops: const [0.0, 0.5, 0.5, 1],
      colors: [
        Colors.transparent,
        Colors.transparent,
        _limitColor.withOpacity(0.5),
        _limitColor.withOpacity(0.5),
      ],
      tileMode: TileMode.repeated,
    );
  }
}
///
class _AxisLabel extends StatelessWidget {
  final String value;
  final Color color;
  final TextStyle? textStyle;
  ///
  const _AxisLabel({
    required this.value,
    required this.color,
    required this.textStyle,
  });
  //
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: textStyle?.copyWith(color: color),
      ),
    );
  }
}
