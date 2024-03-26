import 'dart:math';
import 'package:ext_rw/ext_rw.dart' hide FieldType;
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/models/field/field_data.dart';
import 'package:sss_computing_client/models/field/field_type.dart';
import 'package:sss_computing_client/models/field/value_record.dart';
import 'package:sss_computing_client/presentation/strength/widgets/ship_parameters/ship_parameters.dart';
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
                          labelsSpaceReserved: 25.0,
                          captionSpaceReserved: 0.0,
                          isLabelsVisible: false,
                          isGridVisible: false,
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
                          labelsSpaceReserved: 25.0,
                          captionSpaceReserved: 0.0,
                          isLabelsVisible: false,
                          isGridVisible: false,
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
                                // (idx) => '',
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
                      id: "name",
                      label: const Localized('Name').v,
                      unit: '',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'name',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "n_parts",
                      label: const Localized('Number of parts').v,
                      unit: "",
                      type: FieldType.int,
                      initialValue: "0",
                      record: ValueRecord(
                        key: 'n_parts',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                        onFetch: (str) =>
                            double.tryParse(str)!.toInt().toString(),
                      ),
                    ),
                    FieldData(
                      id: "navigation_area",
                      label: const Localized('Navigation area type').v,
                      unit: '',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'navigation_area',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "const_mass_shift_x",
                      label: const Localized('VCG').v,
                      unit: 'm',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'const_mass_shift_x',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "const_mass_shift_y",
                      label: const Localized('LCG').v,
                      unit: 'm',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'const_mass_shift_y',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "const_mass_shift_z",
                      label: const Localized('TCG').v,
                      unit: 'm',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'const_mass_shift_z',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "ship_length",
                      label: const Localized('Length').v,
                      unit: const Localized('m').v,
                      type: FieldType.real,
                      initialValue: "0.0",
                      record: ValueRecord(
                        key: 'ship_length',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "windage",
                      label: const Localized('Total widndage area').v,
                      unit: 'm^2',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'windage',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "windage_shift_x",
                      label: const Localized('Widndage VCG').v,
                      unit: 'm',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'windage_shift_x',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "windage_shift_z",
                      label: const Localized('Widndage TCG').v,
                      unit: 'm',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'windage_shift_z',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "windage_icing",
                      label: const Localized(
                        'Total widndage area with icing',
                      ).v,
                      unit: 'm^2',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'windage_icing',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "windage_icing_shift_x",
                      label: const Localized('Widndage icing VCG').v,
                      unit: 'm',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'windage_icing_shift_x',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "windage_icing_shift_z",
                      label: const Localized('Widndage icing TCG').v,
                      unit: 'm',
                      type: FieldType.string,
                      initialValue: "",
                      record: ValueRecord(
                        key: 'windage_icing_shift_z',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
                    ),
                    FieldData(
                      id: "water_density",
                      label: const Localized('Water density').v,
                      unit: const Localized('g/ml').v,
                      type: FieldType.real,
                      initialValue: "0.0",
                      isPersisted: false,
                      record: ValueRecord(
                        key: 'water_density',
                        tableName: 'ship',
                        dbName: 'sss-computing',
                        apiAddress: ApiAddress.localhost(port: 8080),
                      ),
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
