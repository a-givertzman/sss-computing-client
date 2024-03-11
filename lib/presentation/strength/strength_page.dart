import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/models/field/field_data.dart';
import 'package:sss_computing_client/models/field/field_stored.dart';
import 'package:sss_computing_client/models/field/field_type.dart';
import 'package:sss_computing_client/presentation/strength/widgets/ShipParameters/ship_parameters.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart/bar_chart.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart/chart_axis.dart';

class StrengthPage extends StatelessWidget {
  const StrengthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(const Setting('blockPadding').toDouble),
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
                        barColor: Colors.lightGreenAccent,
                        minX: -100.0,
                        maxX: 100.0,
                        minY: -200.0,
                        maxY: 200.0,
                        xAxis: ChartAxis(
                          valueInterval: 25,
                          labelsSpaceReserved: 25.0,
                          captionSpaceReserved: 0.0,
                          isLabelsVisible: false,
                        ),
                        yAxis: ChartAxis(
                          valueInterval: 50,
                          labelsSpaceReserved: 60.0,
                          captionSpaceReserved: 15.0,
                          caption: '[${const Localized('kN')}]',
                        ),
                        stream: Stream<Map<String, dynamic>>.periodic(
                          const Duration(seconds: 5),
                          (_) {
                            final (min, max) = (-100, 100);
                            return {
                              'yValues': List.generate(
                                4,
                                (_) =>
                                    min +
                                    Random().nextInt(max - min).toDouble(),
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
                                (idx) =>
                                    '${const Localized('Frames').v} [${idx * 2}-${(idx + 1) * 2}]',
                              ),
                            };
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: const Setting('blockPadding').toDouble,
                ),
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
                        barColor: Colors.lightGreenAccent,
                        minX: -100.0,
                        maxX: 100.0,
                        minY: -500.0,
                        maxY: 500.0,
                        xAxis: ChartAxis(
                          valueInterval: 25,
                          labelsSpaceReserved: 25.0,
                          captionSpaceReserved: 0.0,
                          isLabelsVisible: false,
                        ),
                        yAxis: ChartAxis(
                          valueInterval: 100,
                          labelsSpaceReserved: 60.0,
                          captionSpaceReserved: 15.0,
                          caption: '[${const Localized('kNm')}]',
                        ),
                        stream: Stream<Map<String, dynamic>>.periodic(
                          const Duration(seconds: 5),
                          (_) {
                            final (min, max) = (-250, 250);
                            return {
                              'yValues': List.generate(
                                4,
                                (_) =>
                                    min +
                                    Random().nextInt(max - min).toDouble(),
                              ),
                              'xOffsets': [
                                (-100.0, -50.0),
                                (-50.0, 0.0),
                                (0.0, 50.0),
                                (50.0, 100.0),
                              ],
                              'lowLimits': [-250.0, -250.0, -250.0, -250.0],
                              'highLimits': [200.0, 250.0, 250.0, 200.0],
                              'barCaptions': List.generate(
                                4,
                                (idx) =>
                                    '${const Localized('Frames').v} [${idx * 2}-${(idx + 1) * 2}]',
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
          SizedBox(
            width: const Setting('blockPadding').toDouble,
          ),
          Expanded(
            flex: 1,
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(const Setting('padding').toDouble),
                child: ShipParameters(
                  fieldData: [
                    FieldData(
                      id: "ship_length",
                      label: const Localized('Ship length').v,
                      unit: const Localized('m').v,
                      type: FieldType.real,
                      initialValue: "200.0",
                      record: FieldStored(data: "200.0"),
                    ),
                    FieldData(
                      id: "water_density",
                      label: const Localized('Water density').v,
                      unit: const Localized('g/ml').v,
                      type: FieldType.real,
                      initialValue: "1.025",
                      record: FieldStored(data: "1.025"),
                    ),
                    FieldData(
                      id: "n_parts",
                      label: const Localized('Number of parts').v,
                      unit: "",
                      type: FieldType.int,
                      initialValue: "20",
                      record: FieldStored(data: "20"),
                    ),
                  ],
                  onSave: (fieldDatas) async {
                    try {
                      final fieldsPersisted = await Future.wait(fieldDatas.map(
                        (field) async {
                          switch (await field.save()) {
                            case Ok(:final value):
                              return field.copyWith(initialValue: value);
                            case Err(:final error):
                              Log('$runtimeType | _persistAll').error(error);
                              throw error;
                          }
                        },
                      ));
                      return Ok(fieldsPersisted);
                    } on Err<List<FieldData>,
                        Failure<List<FieldData>>> catch (err) {
                      return err;
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
