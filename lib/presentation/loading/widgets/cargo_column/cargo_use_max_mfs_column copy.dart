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
/// [TableColumn] for [Cargo] useMaxMfs.
class CargoUseMaxMfsColumn implements TableColumn<Cargo, bool> {
  final ValueRecord<bool> Function(
    Cargo data,
    bool Function(String text) toValue,
  ) _buildRecord;

  ///
  /// Creates [TableColumn] for hold [Cargo] shiftable.
  ///
  ///   `buildRecord` build [ValueRecord] for hold [Cargo] shiftable field.
  const CargoUseMaxMfsColumn({
    required ValueRecord<bool> Function(
      Cargo,
      bool Function(String),
    ) buildRecord,
  }) : _buildRecord = buildRecord;
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
  Cargo copyRowWith(Cargo cargo, String text) => JsonCargo(
        json: cargo.asMap()..['useMaxMfs'] = parseToValue(text),
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
  Widget? buildCell(context, cargo, updateValue) => _CargoUseMaxMfsWidget(
        isShiftable: cargo.useMaxMfs,
        color: Theme.of(context).colorScheme.primary,
        onUpdate: (value) => _buildRecord(cargo, parseToValue)
            .persist(value.toString())
            .then(
              (result) => switch (result) {
                Ok(:final value) => () {
                    updateValue(value.toString());
                    return const Ok<void, Failure>(null);
                  }(),
                Err(:final error) => Err<void, Failure>(error),
              },
            )
            .onError(
              (error, stackTrace) => Err(Failure(
                message: '$error',
                stackTrace: stackTrace,
              )),
            ),
      );
}

///
class _CargoUseMaxMfsWidget extends StatelessWidget {
  final bool _isUseMaxMfs;
  final Color _color;
  final Future<ResultF<void>> Function(bool value) _onUpdate;

  ///
  const _CargoUseMaxMfsWidget({
    required bool isShiftable,
    required Color color,
    required Future<ResultF<void>> Function(bool value) onUpdate,
  })  : _isUseMaxMfs = isShiftable,
        _color = color,
        _onUpdate = onUpdate;
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 2.0,
      ),
      child: Tooltip(
        message: switch (_isUseMaxMfs) {
          true => const Localized('mfsModMax').v,
          false => const Localized('mfsModCurrent').v,
        },
        child: Center(
          child: Checkbox(
            activeColor: _color,
            splashRadius: 14.0,
            value: _isUseMaxMfs,
            onChanged: (value) => _updateValue(context, value),
          ),
        ),
      ),
    );
  }

  //
  void _updateValue(BuildContext context, bool? value) {
    if (value == null) return;
    _onUpdate(value)
        .then((result) => switch (result) {
              Ok() => const Log('_CargoUseMaxMfsWidget | _onUpdate')
                  .info('value updated'),
              Err(:final error) =>
                _showErrorMessage(context, '${error.message}')
            })
        .onError(
          (error, _) => _showErrorMessage(context, '$error'),
        );
  }

  //
  void _showErrorMessage(BuildContext context, String message) async {
    if (!context.mounted) return;
    BottomMessage.error(message: message).show(context);
  }
}
