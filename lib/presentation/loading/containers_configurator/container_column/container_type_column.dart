import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
import 'package:sss_computing_client/core/models/stowage/container/container.dart'
    as stowage;

///
class ContainerTypeColumn implements TableColumn<stowage.Container, String> {
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
  String extractValue(stowage.Container container) => container.type.isoName;
  //
  @override
  String parseToValue(String text) => text;
  //
  @override
  String parseToString(String? value) => value ?? nullValue;
  //
  @override
  stowage.Container copyRowWith(
    stowage.Container container,
    String text,
  ) =>
      container;
  //
  @override
  ValueRecord<String>? buildRecord(
    stowage.Container container,
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
  final stowage.ContainerType _type;

  ///
  const _ContainerTypeWidget({
    required stowage.ContainerType type,
  }) : _type = type;
  //
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: Localized(_type.isoName).v,
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
