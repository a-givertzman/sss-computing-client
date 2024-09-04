import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class HoldCargoShiftableColumn implements TableColumn<Cargo, bool> {
  final ValueRecord<bool> Function(
    Cargo data,
    bool Function(String text) toValue,
  )? _buildRecord;
  ///
  const HoldCargoShiftableColumn({
    ValueRecord<bool> Function(
      Cargo,
      bool Function(String),
    )? buildRecord,
  }) : _buildRecord = buildRecord;
  //
  @override
  String get key => 'shiftable';
  //
  @override
  FieldType get type => FieldType.bool;
  //
  @override
  String get name => const Localized('Shiftable').v;
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
  Validator? get validator => const Validator(
        cases: [
          MinLengthValidationCase(1),
          RealValidationCase(),
        ],
      );
  //
  @override
  bool extractValue(Cargo cargo) => cargo.shiftable;
  //
  @override
  bool parseToValue(String text) =>
      bool.tryParse(text, caseSensitive: false) ?? false;
  //
  @override
  String parseToString(bool value) => '$value';
  //
  @override
  Cargo copyRowWith(Cargo cargo, String text) => JsonCargo(
        json: cargo.asMap()..['shiftable'] = parseToValue(text),
      );
  //
  @override
  ValueRecord<bool>? buildRecord(
    Cargo cargo,
    bool Function(String text) toValue,
  ) =>
      _buildRecord?.call(cargo, toValue);
  //
  @override
  Widget? buildCell(context, cargo, updateValue) => _CargoShiftableWidget(
        isShiftable: cargo.shiftable,
        color: Theme.of(context).colorScheme.primary,
        onUpdate: (value) => _buildRecord
            ?.call(cargo, parseToValue)
            .persist(value.toString())
            .then(
              (result) => switch (result) {
                Ok(:final value) => updateValue(value.toString()),
                Err(:final error) => print(error.message),
              },
            ),
      );
}
///
class _CargoShiftableWidget extends StatelessWidget {
  final bool _isShiftable;
  final Color _color;
  final void Function(bool value) _onUpdate;
  ///
  const _CargoShiftableWidget({
    required bool isShiftable,
    required Color color,
    required void Function(bool value) onUpdate,
  })  : _isShiftable = isShiftable,
        _color = color,
        _onUpdate = onUpdate;
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 2.0,
      ),
      child: Center(
        child: Checkbox(
          activeColor: _color,
          splashRadius: 14.0,
          value: _isShiftable,
          onChanged: (value) => _onUpdate(value!),
        ),
      ),
    );
  }
}
