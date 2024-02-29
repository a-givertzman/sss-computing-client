import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_axis.dart';

class LiveBarChart extends StatefulWidget {
  const LiveBarChart({super.key});

  @override
  State<LiveBarChart> createState() => _LiveBarChartState();
}

class _LiveBarChartState extends State<LiveBarChart> {
  late final List<double?> _values;
  late final List<double?> _widths;
  late final List<double?> _lowLimits;
  late final List<double?> _highLimits;
  late final Stream<List<dynamic>> _subscription;
  @override
  void initState() {
    // initialize stream listener
    //
    _values = [10.0, 24.0, 10.0, 100.0];
    _widths = [50.0, 50.0, 50.0, 50.0];
    _lowLimits = [-20.0, -25.0, -30.0, -20.0];
    _highLimits = [20.0, 25.0, 30.0, 20.0];
    super.initState();
  }

  @override
  void dispose() {
    // cancel steram listener
    //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
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
        labelsSpaceReserved: 30.0,
        captionSpaceReserved: 0.0,
        isLabelsVisible: false,
      ),
      yAxis: ChartAxis(
        valueInterval: 50,
        labelsSpaceReserved: 60.0,
        captionSpaceReserved: 15.0,
        caption: '[10^3 tonn]',
      ),
    );
  }
}
