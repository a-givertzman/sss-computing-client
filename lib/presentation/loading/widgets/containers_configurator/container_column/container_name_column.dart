import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// [TableColumn] for [FreightContainer] name.
///
/// Displays name of [FreightContainer].
class ContainerNameColumn implements TableColumn<FreightContainer, String?> {
  ///
  /// Creates [TableColumn] for [FreightContainer] name.
  ///
  /// Displays name of [FreightContainer].
  const ContainerNameColumn();
  //
  @override
  String get key => 'name';
  //
  @override
  FieldType get type => FieldType.string;
  //
  @override
  String get name => const Localized('Name').v;
  //
  @override
  String get nullValue => '—';
  //
  @override
  String? get defaultValue => '';
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
  double? get width => 350.0;
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
      '${container.ownerCode} U ${container.serialCode.toString().padLeft(6, '0')} ${container.checkDigit}';
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
    String text,
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
