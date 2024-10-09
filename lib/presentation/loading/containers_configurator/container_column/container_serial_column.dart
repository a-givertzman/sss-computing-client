import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/validation/int_validation_case.dart';
import 'package:sss_computing_client/core/validation/required_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
import 'package:sss_computing_client/core/models/stowage/container/container.dart'
    as stowage;

///
class ContainerSerialColumn implements TableColumn<stowage.Container, int> {
  final bool _useDefaultEditing;

  ///
  const ContainerSerialColumn({
    bool useDefaultEditing = false,
  }) : _useDefaultEditing = useDefaultEditing;
  //
  @override
  String get key => 'serial';
  //
  @override
  FieldType get type => FieldType.real;
  //
  @override
  String get name => const Localized('Serial').v;
  //
  @override
  String get nullValue => '—';
  //
  @override
  int get defaultValue => 0;
  //
  @override
  Alignment get headerAlignment => Alignment.centerRight;
  //
  @override
  Alignment get cellAlignment => Alignment.centerRight;
  //
  @override
  double? get grow => null;
  //
  @override
  double? get width => 150.0;
  //
  @override
  bool get useDefaultEditing => _useDefaultEditing;
  //
  @override
  bool get isResizable => true;
  //
  @override
  Validator? get validator => const Validator(
        cases: [
          RequiredValidationCase(),
          MaxLengthValidationCase(6),
          IntValidationCase(),
        ],
      );
  //
  @override
  int extractValue(stowage.Container container) => container.serial;
  //
  @override
  int parseToValue(String text) => int.parse(text);
  //
  @override
  String parseToString(int value) {
    return '$value'.padLeft(6, '0');
  }

  //
  @override
  stowage.Container copyRowWith(stowage.Container container, String text) =>
      stowage.Container.fromSizeCode(
        container.type.isoName,
        id: container.id,
        tareWeight: container.tareWeight,
        cargoWeight: container.cargoWeight,
        serial: parseToValue(text),
      );
  //
  @override
  ValueRecord<int>? buildRecord(
    stowage.Container container,
    int Function(String text) toValue,
  ) =>
      null;
  //
  @override
  Widget? buildCell(context, cargo, updateValue) => null;
}
