import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartBars extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final List<double?> _values;
  final List<double?> _widths;
  const ChartBars({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required List<double?> values,
    required List<double?> widths,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _values = values,
        _widths = widths;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contstraints) {
      final xAxisScale = contstraints.maxWidth / (_maxX - _minX);
      return BarChart(
        BarChartData(
          minY: _minY,
          maxY: _maxY,
          alignment: BarChartAlignment.start,
          groupsSpace: 0.0,
          gridData: const FlGridData(
            show: false,
          ),
          titlesData: const FlTitlesData(
            show: false,
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: [
            ..._values.indexed.map(
              (indexedValue) {
                final index = indexedValue.$1;
                final value = indexedValue.$2 ?? 0.0;
                final width = _widths[index] ?? 0.0;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: _maxY,
                      width: width * xAxisScale,
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.zero),
                      rodStackItems: [
                        BarChartRodStackItem(
                          0.0,
                          value,
                          Colors.blue,
                        ),
                      ],
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
