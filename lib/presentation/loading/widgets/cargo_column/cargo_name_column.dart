import 'package:ext_rw/ext_rw.dart' hide FieldType;
import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class CargoNameColumn implements TableColumn<Cargo, String?> {
  final bool _isEditable;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const CargoNameColumn({
    bool isEditable = false,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
  })  : _isEditable = isEditable,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
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
  ValueRecord? buildRecord(Cargo cargo) => FieldRecord<String?>(
        fieldName: 'name',
        tableName: 'compartment',
        toValue: (text) => parseToValue(text),
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
        filter: {'space_id': cargo.id},
      );
  //
  @override
  Widget? buildCell(BuildContext context, Cargo cargo) => null;
}
