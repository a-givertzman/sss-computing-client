import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_axis.dart';
import 'package:sss_computing_client/presentation/strength/widgets/live_bar_chart.dart';

class StrengthPage extends StatelessWidget {
  const StrengthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          height: 400,
          child: LiveBarChart(
            caption: 'ShearForce',
            barColor: Colors.lightGreenAccent,
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
            dataStream: Stream<Map<String, dynamic>>.periodic(
              const Duration(seconds: 5),
              (_) {
                final (min, max) = (-100, 100);
                return {
                  'yValues': List.generate(
                    4,
                    (_) => min + Random().nextInt(max - min).toDouble(),
                  ),
                  'xOffsets': [
                    (-100.0, -50.0),
                    (-50.0, 0.0),
                    (0.0, 50.0),
                    (50.0, 100.0),
                  ],
                  'lowLimits': [-50.0, -75.0, -100.0, -75.0],
                  'highLimits': [50.0, 75.0, 100.0, 75.0],
                  'barCaptions': List.generate(
                    4,
                    (idx) => 'Frames [${idx * 2}-${(idx + 1) * 2}]',
                  ),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}
