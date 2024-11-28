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
/// [TableColumn] for [Cargo] useMaxMfs.
class CargoUseMaxMfsColumn implements TableColumn<Cargo, bool> {
  final ThemeData _theme;
  final ValueRecord<bool> Function(
    Cargo data,
    bool Function(String text) toValue,
  ) _buildRecord;
  ///
  /// Creates [TableColumn] for [Cargo] useMaxMfs.
  ///
  ///   [buildRecord] build [ValueRecord] for [Cargo] useMaxMfs field.
  const CargoUseMaxMfsColumn({
    required ValueRecord<bool> Function(
      Cargo,
      bool Function(String),
    ) buildRecord,
    required ThemeData theme,
  })  : _theme = theme,
        _buildRecord = buildRecord;
  //
  @override
  String get key => 'useMaxMfs';
  //
  @override
  FieldType get type => FieldType.bool;
  //
  @override
  String get name => const Localized('useMaxMfs').v;
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
  bool extractValue(Cargo cargo) => cargo.useMaxMfs;
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
        json: cargo.asMap()..['useMaxMfs'] = value,
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
        value: cargo.useMaxMfs,
        activateMessage: const Localized('mfsModCurrent').v,
        deactivateMessage: const Localized('mfsModMax').v,
        onUpdate: (value) => _buildRecord(cargo, parseToValue)
            .persist(value.toString())
            .convertFailure()
            .then((result) => result.map((value) => updateValue(value))),
      ),
    );
  }
}
