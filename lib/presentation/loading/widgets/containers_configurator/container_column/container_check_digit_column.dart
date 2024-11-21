import 'package:flutter/widgets.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/json_freight_container.dart';
import 'package:sss_computing_client/core/validation/int_validation_case.dart';
import 'package:sss_computing_client/core/validation/required_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// [TableColumn] for [FreightContainer] check digit.
class ContainerCheckDigitColumn implements TableColumn<FreightContainer, int> {
  ///
  /// Creates [TableColumn] for [FreightContainer] check digit.
  const ContainerCheckDigitColumn();
  //
  @override
  String get key => 'checkDigit';
  //
  @override
  FieldType get type => FieldType.int;
  //
  @override
  String get name => '';
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
  double? get width => 75.0;
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
          MinLengthValidationCase(1),
          MaxLengthValidationCase(1),
          IntValidationCase(),
        ],
      );
  //
  @override
  int extractValue(FreightContainer container) => container.checkDigit;
  //
  @override
  int parseToValue(String text) => int.parse(text);
  //
  @override
  String parseToString(int value) => '$value';
  //
  @override
  FreightContainer copyRowWith(FreightContainer container, int value) {
    final newContainerData = container.asMap()..['checkDigit'] = value;
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
