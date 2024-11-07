import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/json_freight_container.dart';
import 'package:sss_computing_client/core/validation/int_validation_case.dart';
import 'package:sss_computing_client/core/validation/required_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// [TableColumn] for [FreightContainer] serial code.
class ContainerSerialColumn implements TableColumn<FreightContainer, int> {
  ///
  /// Creates [TableColumn] for [FreightContainer] serial code.
  const ContainerSerialColumn();
  //
  @override
  String get key => 'serialCode';
  //
  @override
  FieldType get type => FieldType.int;
  //
  @override
  String get name => const Localized('').v;
  //
  @override
  String get nullValue => '—';
  //
  @override
  int get defaultValue => 0;
  //
  @override
  Alignment get headerAlignment => Alignment.centerLeft;
  //
  @override
  Alignment get cellAlignment => Alignment.centerLeft;
  //
  @override
  double? get grow => null;
  //
  @override
  double? get width => 120.0;
  //
  @override
  bool get useDefaultEditing => true;
  //
  @override
  bool get isResizable => true;
  //
  @override
  Validator? get validator => const Validator(
        cases: [
          RequiredValidationCase(),
          MinLengthValidationCase(6),
          MaxLengthValidationCase(6),
          IntValidationCase(),
        ],
      );
  //
  @override
  int extractValue(FreightContainer container) => container.serialCode;
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
  FreightContainer copyRowWith(FreightContainer container, String text) {
    final newContainerData = container.asMap()
      ..['serialCode'] = parseToValue(text);
    return JsonFreightContainer.fromRow(newContainerData);
  }
  //
  @override
  ValueRecord<int>? buildRecord(
    FreightContainer container,
    int Function(String text) toValue,
  ) =>
      null;
  //
  @override
  Widget? buildCell(context, cargo, updateValue) => null;
}
