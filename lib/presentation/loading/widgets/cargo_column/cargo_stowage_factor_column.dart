import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/validation/required_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// Creates [TableColumn] for [Cargo] stowage factor.
class CargoStowageFactorColumn implements TableColumn<Cargo, double?> {
  final bool _useDefaultEditing;
  final ValueRecord<double?> Function(
    Cargo data,
    double? Function(String text) toValue,
  )? _buildRecord;
  ///
  /// Creates [TableColumn] for [Cargo] stowage factor.
  ///
  ///   [useDefaultEditing] either standard [EditingTable] editor is used or not.
  ///   [buildRecord] build [ValueRecord] for [Cargo] stowage factor field.
  const CargoStowageFactorColumn({
    bool useDefaultEditing = false,
    ValueRecord<double?> Function(
      Cargo,
      double? Function(String),
    )? buildRecord,
  })  : _useDefaultEditing = useDefaultEditing,
        _buildRecord = buildRecord;
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
  bool get useDefaultEditing => _useDefaultEditing;
  //
  @override
  bool get isResizable => true;
  //
  @override
  Validator? get validator => const Validator(
        cases: [
          RequiredValidationCase(),
          RealValidationCase(),
        ],
      );
  //
  @override
  double? extractValue(Cargo cargo) => switch (cargo.density) {
        final double value => 1.0 / value,
        null => null,
      };
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
  Cargo copyRowWith(Cargo cargo, double? density) => JsonCargo(
        json: cargo.asMap()
          ..['density'] = switch (density) {
            final double value => 1.0 / value,
            null => null,
          },
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
  Widget? buildCell(context, cargo, updateValue) => null;
}
