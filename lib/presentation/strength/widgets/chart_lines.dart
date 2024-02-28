import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_axis.dart';

class ChartLines extends StatelessWidget {
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final List<double?> _values;
  final List<double?> _widths;
  const ChartLines({
    super.key,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required List<double?> values,
    required List<double?> widths,
  })  : _yAxis = yAxis,
        _xAxis = xAxis,
        _values = values,
        _widths = widths;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contstraints) {
      return LineChart(
        LineChartData(
          minX: _xAxis.minValue,
          maxX: _xAxis.maxValue,
          minY: _yAxis.minValue,
          maxY: _yAxis.maxValue,
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
                  color: Colors.red,
                  spots: [
                    FlSpot(
                      (_xAxis.minValue ?? 0) + width * index,
                      value,
                    ),
                    FlSpot(
                      (_xAxis.minValue ?? 0) + width * (index + 1),
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
