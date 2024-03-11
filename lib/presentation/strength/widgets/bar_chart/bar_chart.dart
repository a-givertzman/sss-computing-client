import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart/chart_axis.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart/chart_bars.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart/chart_layout.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart/chart_legend.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart/chart_lines.dart';

class BarChart extends StatelessWidget {
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  final Color? _barColor;
  final Color? _limitColor;
  final String _caption;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final Stream<Map<String, dynamic>> _stream;
  const BarChart({
    super.key,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    Color? barColor,
    Color? limitColor,
    required String caption,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required Stream<Map<String, dynamic>> stream,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _barColor = barColor,
        _limitColor = limitColor,
        _caption = caption,
        _xAxis = xAxis,
        _yAxis = yAxis,
        _stream = stream;

  double _getMinX(List<(double, double)?> offsets) => offsets.isEmpty
      ? 0.0
      : offsets.fold(offsets[0]?.$1 ?? 0.0, (prev, offset) {
          if (offset != null) {
            final (left, right) = offset;
            return min(min(left, right), prev);
          }
          return prev;
        });

  double _getMaxX(List<(double, double)?> offsets) => offsets.isEmpty
      ? 0.0
      : offsets.fold(offsets[0]?.$1 ?? 0.0, (prev, offset) {
          if (offset != null) {
            final (left, right) = offset;
            return max(max(left, right), prev);
          }
          return prev;
        });

  double _getMinY(List<double?> values) => values.isEmpty
      ? 0.0
      : values.fold(values[0] ?? 0.0, (prev, value) {
          if (value != null) return min(prev, value);
          return prev;
        });

  double _getMaxY(List<double?> values) => values.isEmpty
      ? 0.0
      : values.fold(values[0] ?? 0.0, (prev, value) {
          if (value != null) return max(prev, value);
          return prev;
        });

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
    return StreamBuilder(
      stream: _stream,
      builder: (_, snapshot) {
        return Stack(
          children: [
            if (!snapshot.hasData)
              const Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            if (snapshot.hasData)
              ...() {
                final List<double?> yValues = snapshot.data!['yValues'] ?? [];
                final List<(double, double)?> xOffsets =
                    snapshot.data!['xOffsets'] ?? [];
                final List<String?> barCaptions =
                    snapshot.data!['barCaptions'] ?? [];
                final List<double?> lowLimits =
                    snapshot.data!['lowLimits'] ?? [];
                final List<double?> highLimits =
                    snapshot.data!['highLimits'] ?? [];
                final minX = _minX ?? _getMinX(xOffsets);
                final maxX = _maxX ?? _getMaxX(xOffsets);
                final minY = _minY ?? _getMinY(yValues);
                final maxY = _maxY ?? _getMaxY(yValues);
                return [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      layoutLetfPad,
                      verticalPad,
                      0.0,
                      layoutBottomPad,
                    ),
                    child: ChartLayout(
                      minX: minX,
                      maxX: maxX,
                      minY: minY,
                      maxY: maxY,
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
                        yValues: yValues,
                        lowLimits: lowLimits,
                        highLimits: highLimits,
                        xOffsets: xOffsets,
                        minX: minX,
                        maxX: maxX,
                        minY: minY,
                        maxY: maxY,
                        xAxis: _xAxis,
                        color: _barColor ?? theme.colorScheme.primary,
                        limitColor: _limitColor ?? theme.stateColors.alarm,
                        barCaptions: barCaptions,
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
                        minX: minX,
                        maxX: maxX,
                        minY: minY,
                        maxY: maxY,
                        yValues: lowLimits,
                        xOffsets: xOffsets,
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
                        minX: minX,
                        maxX: maxX,
                        minY: minY,
                        maxY: maxY,
                        yValues: highLimits,
                        xOffsets: xOffsets,
                        color: _limitColor ?? theme.stateColors.alarm,
                      ),
                    ),
                  ),
                ];
              }(),
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
                    const Setting('padding', factor: 0.25).toDouble,
              ),
            ),
          ],
        );
      },
    );
  }
}
