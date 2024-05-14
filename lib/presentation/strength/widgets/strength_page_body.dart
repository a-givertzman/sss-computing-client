import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
import 'package:sss_computing_client/core/models/charts/chart_axis.dart';
import 'package:sss_computing_client/presentation/strength/widgets/strength_forces_chart.dart';
import 'package:sss_computing_client/presentation/strength/widgets/strength_forces_table.dart';
///
class StrengthPageBody extends StatefulWidget {
  final Stream<List<StrengthForce>> _shearForceStream;
  final Stream<List<StrengthForce>> _bendingMomentStream;
  ///
  const StrengthPageBody({
    super.key,
    required Stream<List<StrengthForce>> shearForceStream,
    required Stream<List<StrengthForce>> bendingMomentStream,
  })  : _shearForceStream = shearForceStream,
        _bendingMomentStream = bendingMomentStream;
  //
  @override
  State<StrengthPageBody> createState() => _StrengthPageBodyState(
        shearForceStream: _shearForceStream,
        bendingMomentStream: _bendingMomentStream,
      );
}
///
class _StrengthPageBodyState extends State<StrengthPageBody> {
  final Stream<List<StrengthForce>> _shearForceStream;
  final Stream<List<StrengthForce>> _bendingMomentStream;
  ///
  _StrengthPageBodyState({
    required Stream<List<StrengthForce>> shearForceStream,
    required Stream<List<StrengthForce>> bendingMomentStream,
  })  : _shearForceStream = shearForceStream,
        _bendingMomentStream = bendingMomentStream;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    const barValueColor = Colors.lightGreenAccent;
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: EdgeInsets.all(padding),
                            child: StrengthForceChart(
                              caption: const Localized('Shear force').v,
                              barColor: barValueColor,
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
                                caption: '[${const Localized('MN').v}]',
                              ),
                              stream: _shearForceStream,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: blockPadding),
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: EdgeInsets.all(padding),
                            child: StrengthForceTable(
                              valueUnit: const Localized('MN').v,
                              stream: _shearForceStream,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: blockPadding),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: EdgeInsets.all(padding),
                            child: StrengthForceChart(
                              caption: const Localized('Bending moment').v,
                              barColor: barValueColor,
                              minY: -1500.0,
                              maxY: 1500.0,
                              xAxis: const ChartAxis(
                                labelsSpaceReserved: 25.0,
                                captionSpaceReserved: 0.0,
                              ),
                              yAxis: ChartAxis(
                                valueInterval: 250,
                                labelsSpaceReserved: 60.0,
                                captionSpaceReserved: 15.0,
                                isCaptionVisible: true,
                                isLabelsVisible: true,
                                isGridVisible: true,
                                caption: '[${const Localized('MN*m').v}]',
                              ),
                              stream: _bendingMomentStream,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: blockPadding),
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: EdgeInsets.all(padding),
                            child: StrengthForceTable(
                              valueUnit: const Localized('MN*m').v,
                              stream: _bendingMomentStream,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
