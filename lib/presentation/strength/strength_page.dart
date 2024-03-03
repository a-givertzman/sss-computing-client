import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/models/field/field_data.dart';
import 'package:sss_computing_client/models/field/field_stored.dart';
import 'package:sss_computing_client/models/field/field_type.dart';
import 'package:sss_computing_client/presentation/strength/widgets/general_info_form.dart';

class StrengthPage extends StatelessWidget {
  const StrengthPage({super.key});

  Future<Result<List<FieldData>>> _pesistAll(List<FieldData> fieldDatas) async {
    final fieldsPersisted = await Future.wait(fieldDatas.map(
      (field) async {
        final fieldPersisted = await field.save();
        return field.copyWith(initialValue: fieldPersisted.data);
      },
    ));
    return Result(data: fieldsPersisted);
  }

  @override
  Widget build(BuildContext context) {
    final fieldDatas = [
      FieldData(
        id: "ship_length",
        label: "Ship length",
        unit: "m",
        type: FieldType.real,
        initialValue: "0.0",
        record: FieldStored(data: "200.0"),
      ),
      FieldData(
        id: "water_density",
        label: "Water density",
        unit: "g/ml",
        type: FieldType.real,
        initialValue: "0.0",
        record: FieldStored(data: "1.025"),
      ),
      FieldData(
        id: "n_parts",
        label: "Number of parts",
        unit: "",
        type: FieldType.int,
        initialValue: "0",
        record: FieldStored(data: "20"),
      ),
    ];

    return Center(
      child: SizedBox(
        width: 500,
        height: 500,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(const Setting('padding').toDouble),
            child: GeneralInfoForm(
              fieldData: fieldDatas,
              onSave: () => _pesistAll(fieldDatas),
            ),
          ),
        ),
      ),
    );
  }
}
