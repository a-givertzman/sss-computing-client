import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container_type.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class ContainerTypeColumn implements TableColumn<FreightContainer, String> {
  const ContainerTypeColumn();
  //
  @override
  String get key => 'type';
  //
  @override
  FieldType get type => FieldType.string;
  //
  @override
  String get name => '';
  //
  @override
  String get nullValue => '—';
  //
  @override
  String get defaultValue => '';
  //
  @override
  Alignment get headerAlignment => Alignment.centerLeft;
  //
  @override
  Alignment get cellAlignment => Alignment.centerLeft;
  //
  @override
  bool get isResizable => false;
  //
  @override
  double? get grow => null;
  //
  @override
  double? get width => 28.0;
  //
  @override
  bool get useDefaultEditing => false;
  //
  @override
  Validator? get validator => null;
  //
  @override
  String extractValue(FreightContainer container) => container.type.isoCode;
  //
  @override
  String parseToValue(String text) => text;
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
  ValueRecord<String>? buildRecord(
    FreightContainer container,
    String? Function(String text) toValue,
  ) =>
      null;
  //
  @override
  Widget? buildCell(context, container, updateValue) => _ContainerTypeWidget(
        type: container.type,
      );
}
///
class _ContainerTypeWidget extends StatelessWidget {
  final FreightContainerType _type;
  ///
  const _ContainerTypeWidget({
    required FreightContainerType type,
  }) : _type = type;
  //
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: Localized(_type.isoCode).v,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 2.0,
        ),
        decoration: BoxDecoration(
          color: _type.color,
          borderRadius: const BorderRadius.all(Radius.circular(2.0)),
        ),
      ),
    );
  }
}
