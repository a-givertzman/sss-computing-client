import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
///
class ChartLayout extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final Color _axisColor;
  final TextStyle? _textStyle;
  ///
  const ChartLayout({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required Color axisColor,
    required TextStyle? textStyle,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _yAxis = yAxis,
        _xAxis = xAxis,
        _axisColor = axisColor,
        _textStyle = textStyle;
  //
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
              getTitlesWidget: (value, meta) => _AxisLabel(
                value: value,
                color: _axisColor,
                textStyle: _textStyle,
              ),
            ),
            drawBelowEverything: true,
            axisNameWidget: switch (_yAxis.caption) {
              String caption => _yAxis.isCaptionVisible
                  ? _AxisCaption(
                      caption: caption,
                      color: _axisColor,
                      textStyle: _textStyle,
                    )
                  : null,
              _ => null,
            },
            axisNameSize: _yAxis.captionSpaceReserved,
          ),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: _xAxis.isLabelsVisible,
              reservedSize: _xAxis.labelsSpaceReserved,
              interval: _xAxis.valueInterval,
              getTitlesWidget: (value, meta) => _AxisLabel(
                value: value,
                color: _axisColor,
                textStyle: _textStyle,
              ),
            ),
            axisNameWidget: switch (_xAxis.caption) {
              String caption => _xAxis.isCaptionVisible
                  ? _AxisCaption(
                      caption: caption,
                      color: _axisColor,
                      textStyle: _textStyle,
                    )
                  : null,
              _ => null,
            },
            axisNameSize: _xAxis.captionSpaceReserved,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.fromBorderSide(BorderSide(color: _axisColor)),
        ),
        gridData: FlGridData(
          drawHorizontalLine: _yAxis.isGridVisible,
          getDrawingHorizontalLine: (_) => _drawGridLine(context),
          horizontalInterval: _yAxis.valueInterval,
          drawVerticalLine: _xAxis.isGridVisible,
          getDrawingVerticalLine: (_) => _drawGridLine(context),
          verticalInterval: _xAxis.valueInterval,
        ),
        lineBarsData: [
          // fl_chart requires it to draw grid lines
          LineChartBarData(),
        ],
      ),
    );
  }
  ///
  FlLine _drawGridLine(BuildContext context) {
    return FlLine(
      color: _axisColor.withOpacity(0.5),
      strokeWidth: 0.5,
    );
  }
}
///
class _AxisLabel extends StatelessWidget {
  final double value;
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
        value.toStringAsFixed(0),
        textAlign: TextAlign.center,
        style: textStyle?.copyWith(color: color),
      ),
    );
  }
}
///
class _AxisCaption extends StatelessWidget {
  final String caption;
  final Color color;
  final TextStyle? textStyle;
  ///
  const _AxisCaption({
    required this.caption,
    required this.color,
    required this.textStyle,
  });
  //
  @override
  Widget build(BuildContext context) {
    return Text(
      caption,
      style: textStyle?.copyWith(color: color),
    );
  }
}
