import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart/bar_chart.dart';
import 'package:sss_computing_client/core/models/charts/chart_axis.dart';
///
class StrengthPageBody extends StatelessWidget {
  ///
  const StrengthPageBody({super.key});
  //
  @override
  Widget build(BuildContext context) {
    const valueBarColor = Colors.lightGreenAccent;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(
                        const Setting('padding').toDouble,
                      ),
                      child: BarChart(
                        caption: const Localized('Shear force').v,
                        barColor: valueBarColor,
                        minX: -100.0,
                        maxX: 100.0,
                        minY: -200.0,
                        maxY: 200.0,
                        xAxis: const ChartAxis(
                          labelsSpaceReserved: 25.0,
                          captionSpaceReserved: 0.0,
                        ),
                        yAxis: ChartAxis(
                          valueInterval: 50,
                          labelsSpaceReserved: 60.0,
                          captionSpaceReserved: 15.0,
                          isCaptionVisible: true,
                          isLabelsVisible: true,
                          isGridVisible: true,
                          caption: '[${const Localized('kN').v}]',
                        ),
                        stream: Stream<Map<String, dynamic>>.periodic(
                          const Duration(seconds: 5),
                          (_) {
                            const range = 50;
                            final (minY, maxY) = (-200 + range, 200 - range);
                            final (minX, _) = (-100, 100);
                            final firstY =
                                minY + Random().nextInt(maxY - minY).toDouble();
                            const firstLimit = 50;
                            return {
                              'yValues': List.generate(
                                20,
                                (_) =>
                                    firstY -
                                    range / 2 +
                                    Random().nextInt(range).toDouble(),
                              ),
                              'xOffsets': List.generate(
                                20,
                                (idx) => (
                                  (minX + 10 * idx).toDouble(),
                                  (minX + 10 * (idx + 1)).toDouble(),
                                ),
                              ),
                              'lowLimits': List.generate(
                                20,
                                (idx) => -(firstLimit.toDouble() +
                                    (idx < 10 ? idx : 20 - idx) * 10),
                              ),
                              'highLimits': List.generate(
                                20,
                                (idx) =>
                                    firstLimit.toDouble() +
                                    (idx < 10 ? idx : 20 - idx) * 10,
                              ),
                              'barCaptions': List.generate(
                                20,
                                (idx) => '[${idx + 1}]',
                                // (idx) => '',
                              ),
                            };
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: blockPadding),
                Expanded(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(
                        const Setting('padding').toDouble,
                      ),
                      child: BarChart(
                        caption: const Localized('Bending moment').v,
                        barColor: valueBarColor,
                        minX: -100.0,
                        maxX: 100.0,
                        minY: -500.0,
                        maxY: 500.0,
                        xAxis: const ChartAxis(
                          labelsSpaceReserved: 25.0,
                          captionSpaceReserved: 0.0,
                        ),
                        yAxis: ChartAxis(
                          valueInterval: 100,
                          labelsSpaceReserved: 60.0,
                          captionSpaceReserved: 15.0,
                          isCaptionVisible: true,
                          isLabelsVisible: true,
                          isGridVisible: true,
                          caption: '[${const Localized('kNm').v}]',
                        ),
                        stream: Stream<Map<String, dynamic>>.periodic(
                          const Duration(seconds: 5),
                          (_) {
                            const range = 100;
                            final (minY, maxY) = (-500 + range, 500 - range);
                            final (minX, _) = (-100, 100);
                            final firstY =
                                minY + Random().nextInt(maxY - minY).toDouble();
                            const firstLimit = 150;
                            return {
                              'yValues': List.generate(
                                20,
                                (_) =>
                                    firstY -
                                    range / 2 +
                                    Random().nextInt(range).toDouble(),
                              ),
                              'xOffsets': List.generate(
                                20,
                                (idx) => (
                                  (minX + 10 * idx).toDouble(),
                                  (minX + 10 * (idx + 1)).toDouble(),
                                ),
                              ),
                              'lowLimits': List.generate(
                                20,
                                (idx) => -(firstLimit.toDouble() +
                                    (idx < 10 ? idx : 20 - idx) * 10),
                              ),
                              'highLimits': List.generate(
                                20,
                                (idx) =>
                                    firstLimit.toDouble() +
                                    (idx < 10 ? idx : 20 - idx) * 10,
                              ),
                              'barCaptions': List.generate(
                                20,
                                (idx) => '[${idx + 1}]',
                              ),
                            };
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: blockPadding),
          const Expanded(
            flex: 1,
            child: Card(
              margin: EdgeInsets.zero,
              child: Text('[Empty]'),
            ),
          ),
        ],
      ),
    );
  }
}
