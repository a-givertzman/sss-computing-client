import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_axis.dart';

class LiveBarChart extends StatelessWidget {
  final Stream<Map<String, dynamic>> _dataStream;
  final String _caption;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  final Color? _barColor;
  final Color? _lineColor;
  const LiveBarChart({
    super.key,
    required Stream<Map<String, dynamic>> dataStream,
    required String caption,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    Color? barColor,
    Color? lineColor,
  })  : _dataStream = dataStream,
        _caption = caption,
        _xAxis = xAxis,
        _yAxis = yAxis,
        _maxY = maxY,
        _minY = minY,
        _maxX = maxX,
        _minX = minX,
        _barColor = barColor,
        _lineColor = lineColor;

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
    final padding = const Setting('padding').toDouble;
    return StreamBuilder(
      stream: _dataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          Log('$runtimeType | stream data').debug(snapshot.data);
          return Card(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: BarChart(
                barColor: _barColor,
                limitColor: _lineColor,
                caption: _caption,
                barCaptions: snapshot.data?['barCaptions'] ?? [],
                yValues: snapshot.data?['yValues'] ?? [],
                xOffsets: snapshot.data?['xOffsets'] ?? [],
                lowLimits: snapshot.data?['lowLimits'] ?? [],
                highLimits: snapshot.data?['highLimits'] ?? [],
                minX: _minX ?? _getMinX(snapshot.data?['xOffsets'] ?? []),
                maxX: _maxX ?? _getMaxX(snapshot.data?['xOffsets'] ?? []),
                minY: _minY ?? _getMinY(snapshot.data?['yValues'] ?? []),
                maxY: _maxY ?? _getMaxY(snapshot.data?['yValues'] ?? []),
                xAxis: _xAxis,
                yAxis: _yAxis,
              ),
            ),
          );
        }
        return const Card(
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      },
    );
  }
}
