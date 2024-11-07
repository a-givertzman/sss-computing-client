import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/validation/required_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// [TableColumn] for [FreightContainer] code.
class ContainerCodeColumn implements TableColumn<FreightContainer, String> {
  ///
  /// Creates [TableColumn] for [FreightContainer] code.
  const ContainerCodeColumn();
  //
  @override
  String get key => 'code';
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
  String get defaultValue => 'U';
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
  double? get width => 25.0;
  //
  @override
  bool get useDefaultEditing => false;
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
        ],
      );
  //
  @override
  String extractValue(FreightContainer container) => defaultValue;
  //
  @override
  String parseToValue(String text) => text;
  //
  @override
  String parseToString(String value) => value;
  //
  @override
  FreightContainer copyRowWith(FreightContainer container, String text) =>
      container;
  //
  @override
  ValueRecord<String>? buildRecord(
    FreightContainer container,
    String Function(String text) toValue,
  ) =>
      null;
  //
  @override
  Widget? buildCell(context, cargo, updateValue) => null;
}
