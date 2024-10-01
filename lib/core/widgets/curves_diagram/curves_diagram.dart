import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/widgets/bar_chart_widget/chart_legend.dart';
import 'package:sss_computing_client/core/widgets/curves_diagram/axis_name.dart';
import 'package:sss_computing_client/core/widgets/curves_diagram/axis_title.dart';
import 'package:sss_computing_client/core/widgets/curves_diagram/diagram_curve.dart';
import 'package:sss_computing_client/core/widgets/curves_diagram/diagram_x_value_label.dart';
import 'package:sss_computing_client/core/widgets/curves_diagram/diagram_y_value_label.dart';
///
/// Displays diagram with curves and value labels.
class CurvesDiagram extends StatefulWidget {
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  final List<DiagramCurve> _curves;
  final List<DiagramXValueLabel> _xLabels;
  final List<DiagramYValueLabel> _yLabels;
  final Color? _labelsColor;
  final Color? _gridColor;
  ///
  /// Widget that displays diagram with curves and value labels.
  ///
  /// [xAxis] and [yAxis] hold data about diagram axes and are used to define
  /// axes titles, labels and values intervals. [minX], [maxX], [minY] and [maxY]
  /// define border values for axes. [curves] are curves displayed on diagram.
  /// [xLabels] and [yLabels] used to show value labels on diagram.
  const CurvesDiagram({
    super.key,
    ChartAxis xAxis = const ChartAxis(),
    ChartAxis yAxis = const ChartAxis(),
    double? minX,
    double? maxX,
    double? maxY,
    double? minY,
    List<DiagramCurve> curves = const [],
    List<DiagramXValueLabel> xLabels = const [],
    List<DiagramYValueLabel> yLabels = const [],
    Color? labelsColor,
    Color? gridColor,
  })  : _xAxis = xAxis,
        _yAxis = yAxis,
        _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _curves = curves,
        _xLabels = xLabels,
        _yLabels = yLabels,
        _labelsColor = labelsColor,
        _gridColor = gridColor;
  //
  @override
  State<CurvesDiagram> createState() => _CurvesDiagramState();
}
///
class _CurvesDiagramState extends State<CurvesDiagram> {
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelsColor = widget._labelsColor ?? theme.colorScheme.primary;
    final gridColor = widget._gridColor ?? theme.colorScheme.primary;
    return Stack(
      children: [
        LineChart(
          LineChartData(
            minX: widget._minX,
            maxX: widget._maxX,
            minY: widget._minY,
            maxY: widget._maxY,
            titlesData: _titlesData(color: labelsColor),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(border: Border.all(color: gridColor)),
            lineTouchData: LineTouchData(touchTooltipData: _tooltipData()),
            lineBarsData: widget._curves
                .map(
                  (curve) => curve.lineBarData(),
                )
                .toList(),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: 0.0,
                  color: gridColor,
                ),
                ...widget._yLabels.map((label) => label.label()),
              ],
              verticalLines: [
                VerticalLine(
                  x: 0.0,
                  color: gridColor,
                ),
                ...widget._xLabels.map((label) => label.label()),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: ChartLegend(
            names: widget._curves.map((curve) => curve.caption).toList(),
            colors: widget._curves.map((curve) => curve.color).toList(),
            height: 20.0,
          ),
        ),
      ],
    );
  }
  //
  FlTitlesData _titlesData({required Color color}) => FlTitlesData(
        topTitles: _hiddenTitle(),
        rightTitles: _hiddenTitle(),
        leftTitles: _chartAxisTitle(axis: widget._yAxis, color: color),
        bottomTitles: _chartAxisTitle(axis: widget._xAxis, color: color),
      );
  //
  AxisTitles _hiddenTitle() => const AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      );
  //
  AxisTitles _chartAxisTitle({
    required ChartAxis axis,
    required Color color,
  }) =>
      AxisTitles(
        axisNameWidget: axis.isCaptionVisible
            ? AxisName(
                title: axis.caption ?? '',
                unit: axis.valueUnit,
                color: color,
              )
            : null,
        axisNameSize: axis.captionSpaceReserved,
        sideTitles: SideTitles(
          showTitles: axis.isLabelsVisible,
          reservedSize: axis.labelsSpaceReserved,
          interval: axis.valueInterval,
          getTitlesWidget: (value, meta) => AxisTitle(
            value: value,
            valueInterval: axis.valueInterval,
            meta: meta,
            color: color,
          ),
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
