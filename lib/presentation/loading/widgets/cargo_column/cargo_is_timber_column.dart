import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/future_result_extension.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/check_box_cell_widget.dart';
///
/// [TableColumn] for [Cargo] isTimber field.
class CargoIsTimberColumn implements TableColumn<Cargo, bool> {
  final ThemeData _theme;
  final ValueRecord<bool> Function(
    Cargo data,
    bool Function(String text) toValue,
  ) _buildRecord;
  ///
  /// Creates [TableColumn] for [Cargo] isTimber.
  ///
  ///  * [buildRecord] build [ValueRecord] for [Cargo] isTimber field.
  const CargoIsTimberColumn({
    required ValueRecord<bool> Function(
      Cargo,
      bool Function(String),
    ) buildRecord,
    required ThemeData theme,
  })  : _buildRecord = buildRecord,
        _theme = theme;
  //
  @override
  String get key => 'isTimber';
  //
  @override
  FieldType get type => FieldType.bool;
  //
  @override
  String get name => const Localized('isTimber').v;
  //
  @override
  String get nullValue => '—';
  //
  @override
  bool get defaultValue => false;
  //
  @override
  Alignment get headerAlignment => Alignment.centerRight;
  //
  @override
  Alignment get cellAlignment => Alignment.centerRight;
  //
  @override
  double? get grow => 1;
  //
  @override
  double? get width => null;
  //
  @override
  bool get useDefaultEditing => false;
  //
  @override
  bool get isResizable => false;
  //
  @override
  Validator? get validator => null;
  //
  @override
  bool extractValue(Cargo cargo) => cargo.isTimber;
  //
  @override
  bool parseToValue(String text) =>
      bool.tryParse(text, caseSensitive: false) ?? false;
  //
  @override
  String parseToString(bool value) => '$value';
  //
  @override
  Cargo copyRowWith(Cargo cargo, bool value) => JsonCargo(
        json: cargo.asMap()..['isTimber'] = value,
      );
  //
  @override
  ValueRecord<bool>? buildRecord(
    Cargo cargo,
    bool Function(String text) toValue,
  ) =>
      _buildRecord.call(cargo, toValue);
  //
  @override
  Widget? buildCell(context, cargo, updateValue) {
    return Theme(
      data: _theme,
      child: CheckboxCellWidget(
        value: cargo.isTimber,
        onUpdate: (value) => _buildRecord(cargo, parseToValue)
            .persist(value.toString())
            .convertFailure()
            .then((result) => result.map((value) => updateValue(value))),
      ),
    );
  }
}
