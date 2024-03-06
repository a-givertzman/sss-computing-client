import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_axis.dart';

class LiveBarChart extends StatefulWidget {
  const LiveBarChart({super.key});

  @override
  State<LiveBarChart> createState() => _LiveBarChartState();
}

class _LiveBarChartState extends State<LiveBarChart> {
  late double? _minX;
  late double? _maxX;
  late double? _minY;
  late double? _maxY;
  late List<double?> _yValues;
  late List<(double, double)?> _xOffsets;
  late List<double?> _lowLimits;
  late List<double?> _highLimits;
  late List<String?> _barCaptions;
  late final Stream<List<dynamic>> _subscription;
  late final Timer _updateTimer;
  @override
  void initState() {
    // initialize stream listener
    //
    _minX = -100.0;
    _maxX = 100.0;
    _minY = -200.0;
    _maxY = 200.0;
    _yValues = [10.0, -150.0, 10.0, 100.0];
    _xOffsets = [(-100.0, -50.0), (-50.0, 0.0), (0.0, 50.0), (50.0, 100.0)];
    _lowLimits = [-50.0, -75.0, -100.0, -100.0];
    _highLimits = [100.0, 75.0, 100.0, 50.0];
    _barCaptions = List.generate(
      _yValues.length,
      (idx) => 'Frames [${idx * 2}-${(idx + 1) * 2}]',
    );

    _updateTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => setState(() {
        final (min, max) = (-100, 100);
        _yValues = List.generate(
          _yValues.length,
          (_) => min + Random().nextInt(max - min).toDouble(),
        );
      }),
    );

    super.initState();
  }

  @override
  void dispose() {
    // cancel steram listener
    //
    _updateTimer.cancel();
    super.dispose();
  }

  double _getMinX() => _xOffsets.fold(_xOffsets[0]?.$1 ?? 0.0, (prev, offset) {
        if (offset != null) {
          final (left, right) = offset;
          return min(min(left, right), prev);
        }
        return prev;
      });

  double _getMaxX() => _xOffsets.fold(_xOffsets[0]?.$1 ?? 0.0, (prev, offset) {
        if (offset != null) {
          final (left, right) = offset;
          return max(max(left, right), prev);
        }
        return prev;
      });

  double _getMinY() => _yValues.fold(_yValues[0] ?? 0.0, (prev, value) {
        if (value != null) return min(prev, value);
        return prev;
      });

  double _getMaxY() => _yValues.fold(_yValues[0] ?? 0.0, (prev, value) {
        if (value != null) return max(prev, value);
        return prev;
      });

  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: BarChart(
          color: Colors.lightGreenAccent,
          caption: 'ShearForce',
          barCaptions: _barCaptions,
          yValues: _yValues,
          xOffsets: _xOffsets,
          lowLimits: _lowLimits,
          highLimits: _highLimits,
          minX: _minX ?? _getMinX(),
          maxX: _maxX ?? _getMaxX(),
          minY: _minY ?? _getMinY(),
          maxY: _maxY ?? _getMaxY(),
          xAxis: ChartAxis(
            valueInterval: 25,
            labelsSpaceReserved: 55.0,
            captionSpaceReserved: 0.0,
            isLabelsVisible: false,
          ),
          yAxis: ChartAxis(
            valueInterval: 50,
            labelsSpaceReserved: 60.0,
            captionSpaceReserved: 15.0,
            caption: '[10^3 tonn]',
          ),
        ),
      ),
    );
  }
}
