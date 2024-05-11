import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/charts/chart_axis.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart/bar_chart.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart/chart_legend.dart';
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
  final Stream<List<StrengthForce>> _stream;
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
    required Stream<List<StrengthForce>> stream,
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
        _stream = stream;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = _barColor ?? theme.colorScheme.primary;
    final limitColor = _limitColor ?? theme.stateColors.alarm;
    final axisColor = _axisColor ?? theme.colorScheme.primary;
    final textStyle = _textStyle ?? theme.textTheme.bodySmall;
    return StreamBuilder(
      stream: _stream,
      builder: (_, snapshot) {
        return Stack(
          children: [
            if (!snapshot.hasData)
              const Positioned.fill(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            if (snapshot.hasData)
              Positioned.fill(
                child: BarChart(
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
                  strengthForces: snapshot.data!,
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
                  _barColor ?? theme.colorScheme.primary,
                  _limitColor ?? theme.stateColors.alarm,
                ],
                height: max(
                      _xAxis.labelsSpaceReserved,
                      _xAxis.captionSpaceReserved,
                    ) -
                    const Setting('padding', factor: 0.5).toDouble,
              ),
            ),
          ],
        );
      },
    );
  }
}
