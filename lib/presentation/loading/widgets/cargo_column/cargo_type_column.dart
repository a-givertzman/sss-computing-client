import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class CargoTypeColumn implements TableColumn<Cargo, String> {
  ///
  const CargoTypeColumn();
  //
  @override
  String get key => 'type';
  //
  @override
  FieldType get type => FieldType.string;
  //
  @override
  String get name => const Localized('Type').v;
  //
  @override
  String get nullValue => '—';
  //
  @override
  String get defaultValue => CargoType.other.key;
  //
  @override
  Alignment get headerAlignment => Alignment.centerLeft;
  //
  @override
  Alignment get cellAlignment => Alignment.centerLeft;
  //
  @override
  bool get isEditable => false;
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
  Validator? get validator => null;
  //
  @override
  String extractValue(Cargo cargo) => cargo.type.key;
  //
  @override
  String parseToValue(String text) => CargoType.from(text).key;
  //
  @override
  String parseToString(String value) {
    return CargoType.from(value).key;
  }
  //
  @override
  Cargo copyRowWith(Cargo cargo, String text) => JsonCargo(
        json: cargo.asMap()..['type'] = CargoType.from(text).key,
      );
  //
  @override
  ValueRecord? buildRecord(Cargo cargo) => null;
  //
  @override
  Widget? buildCell(BuildContext context, Cargo cargo) =>
      _CargoTypeWidget(type: cargo.type);
}
///
class _CargoTypeWidget extends StatelessWidget {
  final CargoType _type;
  ///
  const _CargoTypeWidget({required CargoType type}) : _type = type;
  //
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: Localized(_type.label).v,
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
