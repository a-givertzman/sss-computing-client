import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container_port.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class ContainerPOLIndicatorColumn
    implements TableColumn<FreightContainer, String?> {
  ///
  const ContainerPOLIndicatorColumn();
  //
  @override
  String get key => 'pol';
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
  String? extractValue(FreightContainer container) => container.pol?.code;
  //
  @override
  String parseToValue(String text) => text;
  //
  @override
  String parseToString(String? value) => value ?? nullValue;
  //
  @override
  FreightContainer copyRowWith(FreightContainer container, String text) =>
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
  Widget? buildCell(context, container, updateValue) =>
      _ContainerPortWidget(port: container.pol);
}
///
class _ContainerPortWidget extends StatelessWidget {
  final FreightContainerPort? _port;
  ///
  const _ContainerPortWidget({
    required FreightContainerPort? port,
  }) : _port = port;
  //
  @override
  Widget build(BuildContext context) {
    return _port != null
        ? Tooltip(
            message: Localized(_port.name).v,
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: _port.color,
                borderRadius: const BorderRadius.all(Radius.circular(2.0)),
              ),
            ),
          )
        : const SizedBox();
  }
}
