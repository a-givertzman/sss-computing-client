import 'package:ext_rw/ext_rw.dart' hide FieldType;
import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class CargoStowageFactorColumn implements TableColumn<Cargo, double?> {
  final bool _isEditable;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String _tableName;
  final String? _authToken;
  ///
  const CargoStowageFactorColumn({
    bool isEditable = false,
    required ApiAddress apiAddress,
    required String dbName,
    required String tableName,
    required String? authToken,
  })  : _isEditable = isEditable,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _tableName = tableName,
        _authToken = authToken;
  //
  @override
  String get key => 'stowageFactor';
  //
  @override
  FieldType get type => FieldType.real;
  //
  @override
  String get name =>
      '${const Localized('Stowage factor').v} [${const Localized('m^3/t').v}]';
  //
  @override
  String get nullValue => '—';
  //
  @override
  double? get defaultValue => 1.0;
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
  bool get isEditable => _isEditable;
  //
  @override
  bool get isResizable => true;
  //
  @override
  Validator? get validator => const Validator(
        cases: [
          MinLengthValidationCase(1),
          RealValidationCase(),
        ],
      );
  //
  @override
  double? extractValue(Cargo cargo) => cargo.stowageFactor;
  //
  @override
  double? parseToValue(String text) => double.tryParse(text);
  //
  @override
  String parseToString(double? value) {
    return (value ?? 0.0).toStringAsFixed(3);
  }
  //
  @override
  Cargo copyRowWith(Cargo cargo, String text) => JsonCargo(
        json: cargo.asMap()..['density'] = parseToValue(text),
      );
  //
  @override
  ValueRecord? buildRecord(Cargo cargo) => FieldRecord<double?>(
        fieldName: 'stowage_factor',
        toValue: (text) => parseToValue(text),
        apiAddress: _apiAddress,
        dbName: _dbName,
        tableName: _tableName,
        authToken: _authToken,
        filter: {'id': cargo.id},
      );
  //
  @override
  Widget? buildCell(BuildContext context, Cargo cargo) => null;
}
