import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/widgets/async_action_checkbox.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// [TableColumn] for [Cargo] useMaxMfs.
class CargoUseMaxMfsColumn implements TableColumn<Cargo, bool> {
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
    final theme = Theme.of(context);
    return _CargoUseMaxMfsWidget(
      isShiftable: cargo.useMaxMfs,
      activeColor: theme.colorScheme.primary,
      indicatorColor: theme.colorScheme.onSurface,
      onUpdate: (value) => _buildRecord(cargo, parseToValue)
          .persist(value.toString())
          .then(
            (result) => switch (result) {
              Ok(:final value) => () {
                  updateValue(value);
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
}
///
class _CargoUseMaxMfsWidget extends StatelessWidget {
  final bool _isUseMaxMfs;
  final Color _activeColor;
  final Color _indicatorColor;
  final Future<ResultF<void>> Function(bool value) _onUpdate;
  ///
  const _CargoUseMaxMfsWidget({
    required bool isShiftable,
    required Color activeColor,
    required Color indicatorColor,
    required Future<ResultF<void>> Function(bool value) onUpdate,
  })  : _isUseMaxMfs = isShiftable,
        _activeColor = activeColor,
        _indicatorColor = indicatorColor,
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
          child: AsyncActionCheckbox(
            activeColor: _activeColor,
            indicatorColor: _indicatorColor,
            initialValue: _isUseMaxMfs,
            onChanged: (value) => _updateValue(context, value),
          ),
        ),
      ),
    );
  }
  //
  Future<void> _updateValue(BuildContext context, bool? value) async {
    if (value == null) return;
    return _onUpdate(value)
        .then((result) => switch (result) {
              Ok() => const Log('_CargoUseMaxMfsWidget | _onUpdate')
                  .info('value updated'),
              Err(:final error) => context.mounted
                  ? _showErrorMessage(context, '${error.message}')
                  : null
            })
        .onError(
          (error, _) =>
              context.mounted ? _showErrorMessage(context, '$error') : null,
        );
  }
  //
  void _showErrorMessage(BuildContext context, String message) {
    BottomMessage.error(message: message).show(context);
  }
}
