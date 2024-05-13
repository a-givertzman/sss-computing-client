import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart_widget/bar_chart_widget.dart';
///
class ChartLines extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final List<BarChartColumn> _columns;
  final Color _valueColor;
  ///
  const ChartLines({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required List<BarChartColumn> columns,
    required Color valueColor,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _columns = columns,
        _valueColor = valueColor;
  //
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contstraints) {
      return LineChart(
        LineChartData(
          minX: _minX,
          maxX: _maxX,
          minY: _minY,
          maxY: _maxY,
          lineTouchData: const LineTouchData(
            enabled: false,
          ),
          gridData: const FlGridData(
            show: false,
          ),
          titlesData: const FlTitlesData(
            show: false,
          ),
          borderData: FlBorderData(
            show: false,
          ),
          lineBarsData: [
            ..._columns.map(
              (column) {
                final (leftOffset, rightOffset) = column.xBoundaries;
                return LineChartBarData(
                  dotData: const FlDotData(show: false),
                  color: _valueColor,
                  spots: [
                    FlSpot(leftOffset, column.lowLimit),
                    FlSpot(rightOffset, column.lowLimit),
                    FlSpot.nullSpot,
                    FlSpot(leftOffset, column.highLimit),
                    FlSpot(rightOffset, column.highLimit),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
