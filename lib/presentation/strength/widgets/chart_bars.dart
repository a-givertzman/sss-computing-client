import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartBars extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final List<double?> _values;
  final List<double?> _lowLimits;
  final List<double?> _highLimits;
  final List<double?> _widths;
  final Color? _color;
  const ChartBars({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required List<double?> values,
    required List<double?> lowLimits,
    required List<double?> highLimits,
    required List<double?> widths,
    required Color? color,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _values = values,
        _lowLimits = lowLimits,
        _highLimits = highLimits,
        _widths = widths,
        _color = color;

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
                final lowLimit = _lowLimits[index] ?? 0.0;
                final highLimit = _highLimits[index] ?? 0.0;
                return BarChartGroupData(
                  x: index,
                  groupVertically: true,
                  barRods: [
                    BarChartRodData(
                      fromY: _minY,
                      toY: _maxY,
                      width: width * xAxisScale,
                      color: Colors.transparent,
                      gradient: (value > lowLimit && value < highLimit)
                          ? null
                          : LinearGradient(
                              begin: const Alignment(0, 0),
                              end: const Alignment(0, -0.1),
                              transform: const GradientRotation(pi / 4),
                              stops: const [0.0, 0.5, 0.5, 1],
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.5),
                                Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.5),
                              ],
                              tileMode: TileMode.repeated,
                            ),
                      borderRadius: const BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    BarChartRodData(
                      fromY: 0.0,
                      toY: value,
                      width: width * xAxisScale,
                      color: _color ?? Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(Radius.zero),
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
