import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class ContainerSlotColumn implements TableColumn<FreightContainer, String> {
  final StowageCollection collection;
  ///
  const ContainerSlotColumn({required this.collection});
  //
  @override
  String get key => 'slot';
  //
  @override
  FieldType get type => FieldType.string;
  //
  @override
  String get name =>
      '${const Localized('Slot').v} [${const Localized('BBRRTT').v}]';
  //
  @override
  String get nullValue => '—';
  //
  @override
  String get defaultValue => nullValue;
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
  bool get useDefaultEditing => false;
  //
  @override
  bool get isResizable => true;
  //
  @override
  Validator? get validator => null;
  //
  @override
  String extractValue(FreightContainer container) {
    final slot = _findSlot(container);
    if (slot == null) return nullValue;
    return '${slot.bay.toString().padLeft(2, '0')}${slot.row.toString().padLeft(2, '0')}${slot.tier.toString().padLeft(2, '0')}';
  }
  //
  @override
  String parseToValue(String text) => text;
  //
  @override
  String parseToString(String? value) => value ?? nullValue;
  Slot? _findSlot(FreightContainer container) => collection
      .toFilteredSlotList(
        shouldIncludeSlot: (s) => s.containerId == container.id,
      )
      .firstOrNull;
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
