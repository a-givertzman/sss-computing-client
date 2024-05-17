import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/charts/chart_axis.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limited.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart_widget/bar_chart_widget.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart_widget/chart_legend.dart';
///
class StrengthForceChart extends StatelessWidget {
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  final Color? _barColor;
  final Color? _axisColor;
  final Color? _limitColor;
  final TextStyle? _textStyle;
  final String _caption;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final List<StrengthForceLimited> _forcesLimited;
  ///
  const StrengthForceChart({
    super.key,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    Color? barColor,
    Color? axisColor,
    Color? limitColor,
    TextStyle? textStyle,
    required String caption,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required List<StrengthForceLimited> forcesLimited,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _barColor = barColor,
        _axisColor = axisColor,
        _limitColor = limitColor,
        _textStyle = textStyle,
        _caption = caption,
        _xAxis = xAxis,
        _yAxis = yAxis,
        _forcesLimited = forcesLimited;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = _barColor ?? theme.colorScheme.primary;
    final limitColor = _limitColor ?? theme.stateColors.alarm;
    final axisColor = _axisColor ?? theme.colorScheme.primary;
    final textStyle = _textStyle ?? theme.textTheme.bodySmall;
    return Stack(
      children: [
        Positioned.fill(
          child: BarChartWidget(
            minX: _minX,
            maxX: _maxX,
            minY: _minY,
            maxY: _maxY,
            barColor: barColor,
            axisColor: axisColor,
            limitColor: limitColor,
            textStyle: textStyle,
            xAxis: _xAxis,
            yAxis: _yAxis,
            columns: _mapForcesToColumns(_forcesLimited),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ChartLegend(
            names: [
              _caption,
              const Localized('Limit').v,
            ],
            colors: [
              barColor,
              limitColor,
            ],
            height: _xAxis.labelsSpaceReserved +
                _xAxis.captionSpaceReserved -
                const Setting('padding', factor: 0.5).toDouble,
          ),
        ),
      ],
    );
  }
  ///
  List<BarChartColumn> _mapForcesToColumns(List<StrengthForceLimited>? forces) {
    if (forces == null) return [];
    return forces
        .map(
          (data) => BarChartColumn(
            value: data.force.value,
            xBoundaries: (
              data.force.frame.index.toDouble(),
              (data.force.frame.index + 1).toDouble(),
            ),
            lowLimit: data.lowLimit.value,
            highLimit: data.highLimit.value,
            caption: data.force.frame.index.toString(),
          ),
        )
        .toList();
  }
}
