import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
import 'package:sss_computing_client/core/models/strength/strength_forces.dart';
import 'package:sss_computing_client/core/models/charts/chart_axis.dart';
import 'package:sss_computing_client/presentation/strength/widgets/strength_forces_chart.dart';
///
class StrengthPageBody extends StatefulWidget {
  ///
  const StrengthPageBody({super.key});
  //
  @override
  State<StrengthPageBody> createState() => _StrengthPageBodyState();
}
class _StrengthPageBodyState extends State<StrengthPageBody> {
  final _shearForcesController = StreamController<List<StrengthForce>>();
  final _bendingMomentsController = StreamController<List<StrengthForce>>();
  //
  @override
  void initState() {
    const FakeStrengthForces(
      valueRange: 50,
      nParts: 20,
      firstLimit: 50,
      minY: -200,
      maxY: 200,
      minX: -100,
    ).fetchAll().then((result) => switch (result) {
          Ok(value: final forces) => !_shearForcesController.isClosed
              ? _shearForcesController.add(forces)
              : null,
        });
    super.initState();
    const FakeStrengthForces(
      valueRange: 100,
      nParts: 20,
      firstLimit: 150,
      minY: -500,
      maxY: 500,
      minX: -100,
    ).fetchAll().then((result) => switch (result) {
          Ok(value: final forces) => !_bendingMomentsController.isClosed
              ? _bendingMomentsController.add(forces)
              : null,
        });
    super.initState();
  }
  //
  @override
  void dispose() {
    _shearForcesController.close();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    const barValueColor = Colors.lightGreenAccent;
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
                      child: StrengthForceChart(
                        caption: const Localized('Shear force').v,
                        barColor: barValueColor,
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
                        stream: _shearForcesController.stream,
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
                      child: StrengthForceChart(
                        caption: const Localized('Bending moment').v,
                        barColor: barValueColor,
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
                        stream: _bendingMomentsController.stream,
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
