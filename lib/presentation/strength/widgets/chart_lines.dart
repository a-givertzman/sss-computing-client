import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartLines extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final List<double?> _values;
  final List<double?> _widths;
  final Color _color;
  const ChartLines({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required List<double?> values,
    required List<double?> widths,
    required Color color,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _values = values,
        _widths = widths,
        _color = color;

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
            ..._values.indexed.map(
              (indexedValue) {
                final index = indexedValue.$1;
                final value = indexedValue.$2 ?? 0.0;
                final width = _widths[index] ?? 0.0;
                return LineChartBarData(
                  dotData: const FlDotData(
                    show: false,
                  ),
                  color: _color,
                  spots: [
                    FlSpot(
                      _minX + width * index,
                      value,
                    ),
                    FlSpot(
                      _minX + width * (index + 1),
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
