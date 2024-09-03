import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class CargoNameColumn implements TableColumn<Cargo, String?> {
  final bool _isEditable;
  final ValueRecord<String?> Function(
    Cargo data,
    String? Function(String text) toValue,
  )? _buildRecord;
  ///
  const CargoNameColumn({
    bool isEditable = false,
    ValueRecord<String?> Function(
      Cargo,
      String? Function(String),
    )? buildRecord,
  })  : _isEditable = isEditable,
        _buildRecord = buildRecord;
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
  bool get isEditable => _isEditable;
  //
  @override
  bool get isResizable => true;
  //
  @override
  Validator? get validator => const Validator(
        cases: [
          MinLengthValidationCase(1),
        ],
      );
  //
  @override
  String? extractValue(Cargo cargo) => cargo.name;
  //
  @override
  String? parseToValue(String text) => text;
  //
  @override
  String parseToString(String? value) => value ?? nullValue;
  //
  @override
  Cargo copyRowWith(Cargo cargo, String text) => JsonCargo(
        json: cargo.asMap()..['name'] = parseToValue(text),
      );
  //
  @override
  ValueRecord<String?>? buildRecord(
    Cargo cargo,
    String? Function(String text) toValue,
  ) =>
      _buildRecord?.call(cargo, toValue);
  //
  @override
  Widget? buildCell(BuildContext context, Cargo cargo) => null;
}
