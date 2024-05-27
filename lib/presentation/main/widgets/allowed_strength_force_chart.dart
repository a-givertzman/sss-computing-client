import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/charts/chart_axis.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_allow.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limited.dart';
import 'package:sss_computing_client/core/widgets/bar_chart_widget/bar_chart_widget.dart';
import 'package:sss_computing_client/core/widgets/bar_chart_widget/chart_legend.dart';
///
class AllowedStrengthForceChart extends StatelessWidget {
  final Color? _axisColor;
  final Color? _limitColor;
  final TextStyle? _textStyle;
  final List<StrengthForceLimited> _strengthForcesLimited;
  final List<StrengthForceLimited> _bendingMomentsLimited;
  ///
  const AllowedStrengthForceChart({
    super.key,
    Color? axisColor,
    Color? limitColor,
    TextStyle? textStyle,
    required List<StrengthForceLimited> strengthForcesLimited,
    required List<StrengthForceLimited> bendingMomentsLimited,
  })  : _axisColor = axisColor,
        _limitColor = limitColor,
        _textStyle = textStyle,
        _strengthForcesLimited = strengthForcesLimited,
        _bendingMomentsLimited = bendingMomentsLimited;
  //
  @override
  Widget build(BuildContext context) {
    const barColor = Colors.lightGreenAccent;
    const xAxis = ChartAxis(
      labelsSpaceReserved: 25.0,
      captionSpaceReserved: 0.0,
    );
    const yAxis = ChartAxis(
      valueInterval: 25.0,
      labelsSpaceReserved: 60.0,
      captionSpaceReserved: 15.0,
      isCaptionVisible: true,
      isLabelsVisible: true,
      isGridVisible: true,
      caption: '[%]',
    );
    final theme = Theme.of(context);
    final limitColor = _limitColor ?? theme.stateColors.alarm;
    final axisColor = _axisColor ?? theme.colorScheme.primary;
    final textStyle = _textStyle ?? theme.textTheme.bodySmall;
    return Stack(
      children: [
        Positioned.fill(
          child: BarChartWidget(
            minY: 0.0,
            maxY: 125.0,
            barColor: barColor,
            axisColor: axisColor,
            limitColor: limitColor,
            textStyle: textStyle,
            xAxis: xAxis,
            yAxis: yAxis,
            columns: _mapForcesToColumns(
              _strengthForcesLimited,
              _bendingMomentsLimited,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ChartLegend(
            names: [
              'Strength force, Allow',
              const Localized('Limit').v,
            ],
            colors: [
              barColor,
              limitColor,
            ],
            height: xAxis.labelsSpaceReserved +
                xAxis.captionSpaceReserved -
                const Setting('padding', factor: 0.5).toDouble,
          ),
        ),
      ],
    );
  }
  ///
  List<BarChartColumn> _mapForcesToColumns(
    List<StrengthForceLimited> shearForces,
    List<StrengthForceLimited> bendingMoments,
  ) {
    return IterableZip([shearForces, bendingMoments]).map((forces) {
      final [shearForce, bendingMoment] = forces;
      final shearForceAllow = StrengthForceAllow(
            force: shearForce,
          ).value() ??
          0.0;
      final bendingMomentAllow = StrengthForceAllow(
            force: bendingMoment,
          ).value() ??
          0.0;
      return BarChartColumn(
        value: max(shearForceAllow, bendingMomentAllow),
        xBoundaries: (
          shearForce.force.frame.index.toDouble(),
          (shearForce.force.frame.index + 1).toDouble(),
        ),
        highLimit: 100.0,
        lowLimit: null,
        caption: shearForce.force.frame.index.toString(),
      );
    }).toList();
  }
}
