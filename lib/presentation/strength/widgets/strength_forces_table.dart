import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_allow.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limited.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';
///
class StrengthForceTable extends StatefulWidget {
  final String _valueUnit;
  final List<StrengthForceLimited> _forcesLimited;
  ///
  const StrengthForceTable({
    super.key,
    required String valueUnit,
    required List<StrengthForceLimited> forcesLimited,
  })  : _valueUnit = valueUnit,
        _forcesLimited = forcesLimited;
  //
  @override
  State<StrengthForceTable> createState() => _StrengthForceTableState(
        valueUnit: _valueUnit,
        forcesLimited: _forcesLimited,
      );
}
///
class _StrengthForceTableState extends State<StrengthForceTable> {
  final String _valueUnit;
  final List<StrengthForceLimited> _forcesLimited;
  late final DaviModel<StrengthForceLimited> _model;
  ///
  _StrengthForceTableState({
    required String valueUnit,
    required List<StrengthForceLimited> forcesLimited,
  })  : _valueUnit = valueUnit,
        _forcesLimited = forcesLimited;
  //
  @override
  void initState() {
    _model = DaviModel(
      columns: [
        DaviColumn<StrengthForceLimited>(
          width: 42,
          name: '#',
          intValue: (data) => data.force.frame.index,
        ),
        DaviColumn<StrengthForceLimited>(
          grow: 1,
          name: '${const Localized('Value').v}\n[$_valueUnit]',
          doubleValue: (data) => _formatDouble(data.force.value),
        ),
        DaviColumn<StrengthForceLimited>(
          grow: 1,
          name: '${const Localized('Low limit').v}\n[$_valueUnit]',
          doubleValue: (data) => data.lowLimit.value,
          cellBuilder: (_, row) => _NullableCellWidget(
            value: _formatDouble(row.data.lowLimit.value),
          ),
        ),
        DaviColumn<StrengthForceLimited>(
          grow: 1,
          name: '${const Localized('High limit').v}\n[$_valueUnit]',
          doubleValue: (data) => data.highLimit.value,
          cellBuilder: (_, row) => _NullableCellWidget(
            value: _formatDouble(row.data.highLimit.value),
          ),
        ),
        DaviColumn<StrengthForceLimited>(
          grow: 1,
          name: '${const Localized('Limits gap').v}\n[%]',
          doubleValue: (data) => StrengthForceAllow(force: data).value(),
          cellBuilder: (_, row) => _NullableCellWidget(
            value: _formatDouble(StrengthForceAllow(force: row.data).value()),
          ),
        ),
        DaviColumn<StrengthForceLimited>(
          width: 72,
          name: const Localized('Status').v,
          sortable: false,
          cellBuilder: (_, row) {
            final isPassed = _extractPassStatus(row.data);
            return isPassed != null
                ? _PassStatusWidget(isPassed: isPassed)
                : const _NullableCellWidget();
          },
        ),
      ],
    );
    super.initState();
  }
  //
  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return TableView(
      model: _model..replaceRows(_forcesLimited),
      headerHeight: 48.0,
      tableBorderColor: Colors.transparent,
    );
  }
  //
  double? _formatDouble(double? value, {int fractionDigits = 1}) {
    return value != null
        ? double.parse(value.toStringAsFixed(fractionDigits))
        : null;
  }
  //
  bool? _extractPassStatus(StrengthForceLimited forceLimited) {
    final lowLimit = forceLimited.lowLimit.value;
    final highLimit = forceLimited.highLimit.value;
    final value = forceLimited.force.value;
    return switch (value) {
      >= 0.0 => highLimit != null ? value < highLimit : null,
      < 0.0 => lowLimit != null ? value > lowLimit : null,
      _ => null,
    };
  }
}
///
class _NullableCellWidget<T> extends StatelessWidget {
  final T? value;
  ///
  const _NullableCellWidget({
    this.value,
  });
  //
  @override
  Widget build(BuildContext context) {
    return Text(
      '${value ?? '—'}',
      overflow: TextOverflow.ellipsis,
    );
  }
}
///
class _PassStatusWidget extends StatelessWidget {
  final bool isPassed;
  ///
  const _PassStatusWidget({
    required this.isPassed,
  });
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final passedColor = Theme.of(context).stateColors.on;
    final errorColor = theme.alarmColors.class3;
    return isPassed
        ? Icon(
            Icons.done,
            color: passedColor,
          )
        : Icon(
            Icons.error_outline,
            color: errorColor,
          );
  }
}
