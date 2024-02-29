import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_axis.dart';

class ChartLayout extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  const ChartLayout({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _yAxis = yAxis,
        _xAxis = xAxis;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: _minX,
        minY: _minY,
        maxX: _maxX,
        maxY: _maxY,
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: _yAxis.isLabelsVisible,
              reservedSize: _yAxis.labelsSpaceReserved,
              interval: _yAxis.valueInterval,
              getTitlesWidget: (value, meta) => _AxisLabel(value: value),
            ),
            drawBelowEverything: true,
            axisNameWidget: switch (_yAxis.caption) {
              String caption => _AxisCaption(caption: caption),
              _ => null,
            },
            axisNameSize: _yAxis.captionSpaceReserved,
          ),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: _xAxis.isLabelsVisible,
              reservedSize: _xAxis.labelsSpaceReserved,
              interval: _xAxis.valueInterval,
              getTitlesWidget: (value, meta) => _AxisLabel(value: value),
            ),
            axisNameWidget: switch (_xAxis.caption) {
              String caption => _AxisCaption(caption: caption),
              _ => null,
            },
            axisNameSize: _xAxis.captionSpaceReserved,
          ),
          rightTitles: const AxisTitles(),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.fromBorderSide(
            BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        gridData: FlGridData(
          drawHorizontalLine: _yAxis.isGridVisible,
          getDrawingHorizontalLine: (_) => _line(context),
          horizontalInterval: _yAxis.valueInterval,
          drawVerticalLine: _xAxis.isGridVisible,
          getDrawingVerticalLine: (_) => _line(context),
          verticalInterval: _xAxis.valueInterval,
        ),
        lineBarsData: [
          // fl_chart requires it to draw grid lines
          LineChartBarData(),
        ],
      ),
    );
  }

  FlLine _line(BuildContext context) {
    return FlLine(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      strokeWidth: 0.5,
    );
  }
}

class _AxisLabel extends StatelessWidget {
  final double _value;
  const _AxisLabel({
    required double value,
  }) : _value = value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        _value.toStringAsFixed(0),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.0,
          height: 1.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _AxisCaption extends StatelessWidget {
  final String _caption;
  const _AxisCaption({
    required String caption,
  }) : _caption = caption;

  @override
  Widget build(BuildContext context) {
    return Text(
      _caption,
      style: TextStyle(
        fontSize: 12.0,
        height: 1.0,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
