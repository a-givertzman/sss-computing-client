import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// [TableColumn] for [FreightContainer] type code.
///
/// Displays size code and type code of [FreightContainer].
class ContainerTypeCodeColumn
    implements TableColumn<FreightContainer, String?> {
  ///
  /// Creates [TableColumn] for [FreightContainer] type code.
  ///
  /// Displays size code and type code of [FreightContainer].
  const ContainerTypeCodeColumn();
  //
  @override
  String get key => 'code';
  //
  @override
  FieldType get type => FieldType.string;
  //
  @override
  String get name => const Localized('Code').v;
  //
  @override
  String get nullValue => '—';
  //
  @override
  String? get defaultValue => null;
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
  bool get useDefaultEditing => false;
  //
  @override
  bool get isResizable => true;
  //
  @override
  Validator? get validator => null;
  //
  @override
  String? extractValue(FreightContainer container) =>
      '${container.type.sizeCode} ${container.typeCode}';
  //
  @override
  String? parseToValue(String text) => text;
  //
  @override
  String parseToString(String? value) => value ?? nullValue;
  //
  @override
  FreightContainer copyRowWith(
    FreightContainer container,
    String? text,
  ) =>
      container;
  //
  @override
  ValueRecord<String?>? buildRecord(
    FreightContainer container,
    String? Function(String text) toValue,
  ) =>
      null;
  //
  @override
  Widget? buildCell(context, cargo, updateValue) => null;
}
