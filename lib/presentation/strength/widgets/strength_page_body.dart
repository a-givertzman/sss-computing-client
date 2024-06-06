import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limited.dart';
import 'package:sss_computing_client/presentation/strength/widgets/strength_forces_chart.dart';
import 'package:sss_computing_client/presentation/strength/widgets/strength_forces_table.dart';
///
class StrengthPageBody extends StatefulWidget {
  final List<StrengthForceLimited> _shearForces;
  final List<StrengthForceLimited> _bendingMoments;
  ///
  const StrengthPageBody({
    super.key,
    required List<StrengthForceLimited> shearForces,
    required List<StrengthForceLimited> bendingMoments,
  })  : _shearForces = shearForces,
        _bendingMoments = bendingMoments;
  //
  @override
  State<StrengthPageBody> createState() => _StrengthPageBodyState(
        shearForces: _shearForces,
        bendingMoments: _bendingMoments,
      );
}
///
class _StrengthPageBodyState extends State<StrengthPageBody> {
  final List<StrengthForceLimited> _shearForces;
  final List<StrengthForceLimited> _bendingMoments;
  ///
  _StrengthPageBodyState({
    required List<StrengthForceLimited> shearForces,
    required List<StrengthForceLimited> bendingMoments,
  })  : _shearForces = shearForces,
        _bendingMoments = bendingMoments;
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
                              forcesLimited: _bendingMoments,
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
                              forcesLimited: _bendingMoments,
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
                              forcesLimited: _shearForces,
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
                              forcesLimited: _shearForces,
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
