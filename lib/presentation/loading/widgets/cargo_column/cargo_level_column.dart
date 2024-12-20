import 'package:flutter/material.dart';
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
/// Creates [TableColumn] for [Cargo] level.
class CargoLevelColumn implements TableColumn<Cargo, double?> {
  final bool _useDefaultEditing;
  final ValueRecord<double?> Function(
    Cargo data,
    double? Function(String text) toValue,
  )? _buildRecord;
  ///
  /// Creates [TableColumn] for [Cargo] level.
  ///
  ///   [useDefaultEditing] either standard [EditingTable] editor is used or not.
  ///   [buildRecord] build [ValueRecord] for [Cargo] level field.
  const CargoLevelColumn({
    bool useDefaultEditing = false,
    ValueRecord<double?> Function(
      Cargo,
      double? Function(String),
    )? buildRecord,
  })  : _useDefaultEditing = useDefaultEditing,
        _buildRecord = buildRecord;
  //
  @override
  String get key => 'level';
  //
  @override
  FieldType get type => FieldType.real;
  //
  @override
  String get name => const Localized('%').v;
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
  double? extractValue(Cargo cargo) => cargo.level;
  //
  @override
  double? parseToValue(String text) => double.tryParse(text);
  //
  @override
  String parseToString(double? value) {
    return (value ?? 0.0).toStringAsFixed(0);
  }
  //
  @override
  Cargo copyRowWith(Cargo cargo, double? value) => JsonCargo(
        json: cargo.asMap()..['level'] = value,
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
  Widget? buildCell(context, cargo, _) => _CargoLevelWidget(
        level: cargo.level ?? 0.0,
        label: parseToString(cargo.level),
        color: Theme.of(context).colorScheme.primary,
      );
}
///
class _CargoLevelWidget extends StatelessWidget {
  final double _level;
  final String _label;
  final Color _color;
  ///
  const _CargoLevelWidget({
    required double level,
    required String label,
    required Color color,
  })  : _level = level,
        _label = label,
        _color = color;
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            _color,
            _color,
            _color.withOpacity(0.25),
            _color.withOpacity(0.25),
          ],
          stops: [
            0.0,
            _level / 100.0,
            _level / 100.0,
            1.0,
          ],
          tileMode: TileMode.clamp,
        ),
        border: Border.all(
          width: 1.0,
          color: _color,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(2.0),
        ),
      ),
      child: Center(
        child: Text(_label),
      ),
    );
  }
}
