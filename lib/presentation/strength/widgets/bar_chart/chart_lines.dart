import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
///
class ChartLines extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final List<double?> _yValues;
  final List<(double, double)?> _xOffsets;
  final Color _valueColor;
  ///
  const ChartLines({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required List<double?> yValues,
    required List<(double, double)?> xOffsets,
    required Color valueColor,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _yValues = yValues,
        _xOffsets = xOffsets,
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
            ..._yValues.indexed.map(
              (indexedValue) {
                final index = indexedValue.$1;
                final value = indexedValue.$2 ?? 0.0;
                final (offsetL, offsetR) = _xOffsets[index] ?? (0.0, 0.0);
                return LineChartBarData(
                  dotData: const FlDotData(
                    show: false,
                  ),
                  color: _valueColor,
                  spots: [
                    FlSpot(
                      offsetL,
                      value,
                    ),
                    FlSpot(
                      offsetR,
                      value,
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
}
