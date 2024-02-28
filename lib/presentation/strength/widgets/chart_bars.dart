import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_axis.dart';

class ChartBars extends StatelessWidget {
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final List<double?> _values;
  final List<double?> _widths;
  const ChartBars({
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
      final xAxisScale =
          contstraints.maxWidth / (_xAxis.maxValue! - _xAxis.minValue!);
      return BarChart(
        BarChartData(
          minY: _yAxis.minValue,
          maxY: _yAxis.maxValue,
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
                      toY: _yAxis.maxValue ?? 0.0,
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
