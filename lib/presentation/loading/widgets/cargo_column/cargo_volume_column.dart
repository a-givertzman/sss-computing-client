import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class CargoVolumeColumn implements TableColumn<Cargo, double?> {
  final bool _isEditable;
  final ValueRecord<double?> Function(
    Cargo data,
    double? Function(String text) toValue,
  )? _buildRecord;
  ///
  const CargoVolumeColumn({
    bool isEditable = false,
    ValueRecord<double?> Function(
      Cargo,
      double? Function(String),
    )? buildRecord,
  })  : _isEditable = isEditable,
        _buildRecord = buildRecord;
  //
  @override
  String get key => 'volume';
  //
  @override
  FieldType get type => FieldType.real;
  //
  @override
  String get name =>
      '${const Localized('Volume').v} [${const Localized('m^3').v}]';
  //
  @override
  String get nullValue => '—';
  //
  @override
  double? get defaultValue => 0.0;
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
  double? extractValue(Cargo cargo) => cargo.volume;
  //
  @override
  double? parseToValue(String text) => double.tryParse(text);
  //
  @override
  String parseToString(double? value) {
    return (value ?? 0.0).toStringAsFixed(1);
  }
  //
  @override
  Cargo copyRowWith(Cargo cargo, String text) => JsonCargo(
        json: cargo.asMap()..['volume'] = parseToValue(text),
      );
  //
  @override
  ValueRecord<double?>? buildRecord(
    Cargo cargo,
    double? Function(String text) toValue,
  ) =>
      _buildRecord?.call(cargo, toValue);
  //
  @override
  Widget? buildCell(BuildContext context, Cargo cargo) => null;
}
