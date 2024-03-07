import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/models/field/field_data.dart';
import 'package:sss_computing_client/models/field/field_stored.dart';
import 'package:sss_computing_client/models/field/field_type.dart';
import 'package:sss_computing_client/presentation/strength/widgets/ShipParameters/ship_parameters.dart';

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
                      padding:
                          EdgeInsets.all(const Setting('padding').toDouble),
                      child: const Text('Shear forces [BarChart]'),
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
                      padding:
                          EdgeInsets.all(const Setting('padding').toDouble),
                      child: const Text('Bending moments [BarChart]'),
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
                      label: "Ship length",
                      unit: "m",
                      type: FieldType.real,
                      initialValue: "200.0",
                      record: FieldStored(data: "200.0"),
                    ),
                    FieldData(
                      id: "water_density",
                      label: "Water density",
                      unit: "g/ml",
                      type: FieldType.real,
                      initialValue: "1.025",
                      record: FieldStored(data: "1.025"),
                    ),
                    FieldData(
                      id: "n_parts",
                      label: "Number of parts",
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
