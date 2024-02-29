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
  late List<double?> _values;
  late List<double?> _widths;
  late List<double?> _lowLimits;
  late List<double?> _highLimits;
  late final Stream<List<dynamic>> _subscription;
  late final Timer _updateTimer;
  @override
  void initState() {
    // initialize stream listener
    //
    _values = [10.0, -150.0, 10.0, 100.0];
    _widths = [50.0, 50.0, 50.0, 50.0];
    _lowLimits = [-50.0, -75.0, -100.0, -100.0];
    _highLimits = [100.0, 75.0, 100.0, 50.0];

    _updateTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => setState(() {
        final (min, max) = (-100, 100);
        _values = List.generate(
          _values.length,
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

  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: BarChart(
          color: Colors.lightGreenAccent,
          caption: 'ShearForce',
          values: _values,
          widths: _widths,
          lowLimits: _lowLimits,
          highLimits: _highLimits,
          minX: -100.0,
          maxX: 100.0,
          minY: -200.0,
          maxY: 200.0,
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
