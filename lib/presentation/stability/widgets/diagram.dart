import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
class Diagram extends StatefulWidget {
  final double xInterval;
  final double yInterval;
  final double metacentricHeight;
  final double theta0;
  final List<Offset> staticStabilityCurve;
  final List<Offset> dynamicStabilityCurve;
  final Color? labelsColor;
  final Color? gridColor;
  ///
  const Diagram({
    super.key,
    this.xInterval = 10.0,
    this.yInterval = 0.5,
    required this.metacentricHeight,
    required this.theta0,
    required this.staticStabilityCurve,
    required this.dynamicStabilityCurve,
    this.labelsColor,
    this.gridColor,
  });
  //
  @override
  State<Diagram> createState() => _DiagramState();
}
class _DiagramState extends State<Diagram> {
  static const _minX = 0.0;
  static const _maxX = 90.0;
  late final double _maxY;
  //
  @override
  void initState() {
    _maxY = _getMaxY();
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelsColor = widget.labelsColor ?? theme.colorScheme.primary;
    final gridColor = widget.gridColor ?? theme.colorScheme.primary;
    return LineChart(
      LineChartData(
        maxY: _maxY,
        minX: _minX,
        maxX: _maxX,
        titlesData: _titlesData(color: labelsColor),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(
          border: Border.all(color: gridColor),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: _tooltipData(),
        ),
        lineBarsData: [
          _lineBarData(
            spots: _metacentricHeightSpots(),
            color: Colors.purpleAccent,
          ),
          _lineBarData(
            spots: _curveSpots(widget.staticStabilityCurve),
            color: Colors.greenAccent,
          ),
          _lineBarData(
            spots: _curveSpots(widget.dynamicStabilityCurve),
            color: Colors.orangeAccent,
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0.0,
              color: gridColor,
            ),
            HorizontalLine(
              y: widget.metacentricHeight,
              dashArray: [5, 10],
              color: gridColor,
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: gridColor,
                ),
                labelResolver: (line) =>
                    '${const Localized('h').v}: ${line.y.toStringAsFixed(2)} ${const Localized('m').v}',
              ),
            ),
          ],
          verticalLines: [
            VerticalLine(
              x: 0.0,
              color: gridColor,
            ),
            VerticalLine(
              x: radians2Degrees + widget.theta0,
              dashArray: [5, 10],
              color: gridColor,
              label: VerticalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: gridColor,
                ),
                labelResolver: (line) =>
                    'θ₀ + 1 ${const Localized('radian').v} (${line.x.toStringAsFixed(1)}${const Localized('°').v})',
              ),
            ),
            VerticalLine(
              x: widget.theta0,
              dashArray: [5, 10],
              color: gridColor,
              label: VerticalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: gridColor,
                ),
                labelResolver: (line) =>
                    'θ₀ (${line.x.toStringAsFixed(1)}${const Localized('°').v})',
              ),
            ),
          ],
        ),
      ),
    );
  }
  //
  double _getMaxY({double gap = 1.0}) =>
      max(
        max(
          _getCurveMaxY(widget.staticStabilityCurve),
          _getCurveMaxY(widget.dynamicStabilityCurve),
        ),
        widget.metacentricHeight,
      ) +
      gap;
  //
  double _getCurveMaxY(List<Offset> curve) => curve
      .reduce(
        (curr, next) => curr.dy > next.dy ? curr : next,
      )
      .dy;
  //
  LineChartBarData _lineBarData({
    required List<FlSpot> spots,
    required Color color,
  }) =>
      LineChartBarData(
        spots: spots,
        dotData: const FlDotData(show: false),
        color: color,
      );
  //
  List<FlSpot> _curveSpots(List<Offset> curve) => curve
      .map((point) => FlSpot(
            point.dx,
            point.dy,
          ))
      .toList();
  //
  List<FlSpot> _metacentricHeightSpots() => List.generate(
        (widget.theta0 + radians2Degrees).floor() + 1,
        (i) => i,
      )
          .map((x) => FlSpot(
                x.toDouble(),
                (x - widget.theta0) *
                    widget.metacentricHeight /
                    (radians2Degrees),
              ))
          .toList()
        ..add(FlSpot(
          widget.theta0 + radians2Degrees,
          widget.metacentricHeight,
        ));
  //
  FlTitlesData _titlesData({required Color color}) => FlTitlesData(
        topTitles: _hiddenTitle(),
        rightTitles: _hiddenTitle(),
        leftTitles: AxisTitles(
          axisNameWidget: AxisName(
            title: const Localized('Righting lever').v,
            unit: const Localized('m').v,
            color: color,
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36.0,
            interval: widget.yInterval,
            getTitlesWidget: (value, meta) => AxisTitle(
              value: value,
              valueInterval: widget.yInterval,
              meta: meta,
              color: color,
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: AxisName(
            title: const Localized('Angle of heel').v,
            unit: const Localized('°').v,
            color: color,
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24.0,
            interval: widget.xInterval,
            getTitlesWidget: (value, meta) => AxisTitle(
              value: value,
              valueInterval: widget.xInterval,
              meta: meta,
              color: color,
            ),
          ),
        ),
      );
  //
  AxisTitles _hiddenTitle() => const AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      );
  //
  LineTouchTooltipData _tooltipData() {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelSmall ?? const TextStyle();
    return LineTouchTooltipData(
      tooltipBgColor: theme.colorScheme.surface.withOpacity(0.75),
      fitInsideVertically: true,
      fitInsideHorizontally: true,
      getTooltipItems: (touchedSpots) => touchedSpots
          .map((LineBarSpot touchedSpot) => LineTooltipItem(
                '(${touchedSpot.x.toStringAsFixed(2)}, ${touchedSpot.y.toStringAsFixed(2)})',
                textStyle.copyWith(color: touchedSpot.bar.color),
              ))
          .toList(),
    );
  }
}
///
class AxisName extends StatelessWidget {
  final String _title;
  final String _unit;
  final Color _color;
  ///
  const AxisName({
    super.key,
    required String title,
    required String unit,
    required Color color,
  })  : _title = title,
        _unit = unit,
        _color = color;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelMedium ?? const TextStyle();
    return Text(
      '$_title [$_unit]',
      style: textStyle.copyWith(color: _color),
    );
  }
}
///
class AxisTitle extends StatelessWidget {
  final double _value;
  final double _valueInterval;
  final TitleMeta _meta;
  final Color _color;
  ///
  const AxisTitle({
    super.key,
    required double value,
    required double valueInterval,
    required TitleMeta meta,
    required Color color,
  })  : _value = value,
        _valueInterval = valueInterval,
        _meta = meta,
        _color = color;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelSmall ?? const TextStyle();
    return SideTitleWidget(
      axisSide: _meta.axisSide,
      fitInside: SideTitleFitInsideData.fromTitleMeta(
        _meta,
        distanceFromEdge: 0.0,
      ),
      child: Text(
        _value % _valueInterval == 0 ? '$_value' : '',
        style: textStyle.copyWith(color: _color),
      ),
    );
  }
}
