import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_axis.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_bars.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_layout.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_legend.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_lines.dart';

class BarChart extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final List<double?> _yValues;
  final List<(double, double)?> _xOffsets;
  final List<double?> _lowLimits;
  final List<double?> _highLimits;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final Color? _barColor;
  final Color? _limitColor;
  final String _caption;
  final List<String?>? _barCaptions;
  const BarChart({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required List<double?> yValues,
    required List<(double, double)?> xOffsets,
    required List<double?> lowLimits,
    required List<double?> highLimits,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required String caption,
    List<String?>? barCaptions,
    Color? barColor,
    Color? limitColor,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _yValues = yValues,
        _xOffsets = xOffsets,
        _lowLimits = lowLimits,
        _highLimits = highLimits,
        _xAxis = xAxis,
        _yAxis = yAxis,
        _barColor = barColor,
        _limitColor = limitColor,
        _caption = caption,
        _barCaptions = barCaptions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verticalPad =
        _xAxis.labelsSpaceReserved + _xAxis.captionSpaceReserved;
    final horizontalPad =
        _yAxis.labelsSpaceReserved + _yAxis.captionSpaceReserved;
    final layoutBottomPad = verticalPad -
        (_xAxis.isLabelsVisible ? _xAxis.labelsSpaceReserved : 0.0) -
        (_xAxis.caption != null ? _xAxis.captionSpaceReserved : 0.0);
    final layoutLetfPad = horizontalPad -
        (_yAxis.isLabelsVisible ? _yAxis.labelsSpaceReserved : 0.0) -
        (_yAxis.caption != null ? _yAxis.captionSpaceReserved : 0.0);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            layoutLetfPad,
            verticalPad,
            0.0,
            layoutBottomPad,
          ),
          child: ChartLayout(
            minX: _minX,
            maxX: _maxX,
            minY: _minY,
            maxY: _maxY,
            xAxis: _xAxis,
            yAxis: _yAxis,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPad,
            0.0,
            0.0,
            verticalPad,
          ),
          child: ClipRect(
            child: ChartBars(
              yValues: _yValues,
              lowLimits: _lowLimits,
              highLimits: _highLimits,
              xOffsets: _xOffsets,
              minX: _minX,
              maxX: _maxX,
              minY: _minY,
              maxY: _maxY,
              xAxis: _xAxis,
              color: _barColor ?? theme.colorScheme.primary,
              limitColor: _limitColor ?? theme.stateColors.alarm,
              barCaptions: _barCaptions ??
                  List.generate(
                    _yValues.length,
                    (_) => '',
                  ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPad,
            verticalPad,
            0.0,
            verticalPad,
          ),
          child: ClipRect(
            child: ChartLines(
              minX: _minX,
              maxX: _maxX,
              minY: _minY,
              maxY: _maxY,
              yValues: _lowLimits,
              xOffsets: _xOffsets,
              color: _limitColor ?? theme.stateColors.alarm,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPad,
            verticalPad,
            0.0,
            verticalPad,
          ),
          child: ClipRect(
            child: ChartLines(
              minX: _minX,
              maxX: _maxX,
              minY: _minY,
              maxY: _maxY,
              yValues: _highLimits,
              xOffsets: _xOffsets,
              color: _limitColor ?? theme.stateColors.alarm,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ChartLegend(
            names: [
              _caption,
              'Limits',
            ],
            colors: [
              _barColor ?? theme.colorScheme.primary,
              _limitColor ?? theme.stateColors.alarm,
            ],
            width: 150.0,
          ),
        ),
      ],
    );
  }
}
