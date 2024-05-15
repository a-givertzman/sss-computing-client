import 'package:davi/davi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limited.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';
///
class StrengthForceTable extends StatefulWidget {
  final String _valueUnit;
  final Stream<List<StrengthForceLimited>> _stream;
  ///
  const StrengthForceTable({
    super.key,
    required String valueUnit,
    required Stream<List<StrengthForceLimited>> stream,
  })  : _valueUnit = valueUnit,
        _stream = stream;
  //
  @override
  State<StrengthForceTable> createState() => _StrengthForceTableState(
        valueUnit: _valueUnit,
        stream: _stream,
      );
}
///
class _StrengthForceTableState extends State<StrengthForceTable> {
  final String _valueUnit;
  final Stream<List<StrengthForceLimited>> _stream;
  late final DaviModel<StrengthForceLimited> _model;
  ///
  _StrengthForceTableState({
    required String valueUnit,
    required Stream<List<StrengthForceLimited>> stream,
  })  : _valueUnit = valueUnit,
        _stream = stream;
  //
  @override
  void initState() {
    _model = DaviModel(
      columns: [
        DaviColumn<StrengthForceLimited>(
          width: 42,
          name: '#',
          intValue: (data) => data.force.frame.index,
          resizable: false,
        ),
        DaviColumn<StrengthForceLimited>(
          grow: 1,
          name: '${const Localized('Value').v}\n[$_valueUnit]',
          doubleValue: (data) => _formatDoubleFraction(data.force.value),
          resizable: false,
        ),
        DaviColumn<StrengthForceLimited>(
          grow: 1,
          name: '${const Localized('Low limit').v}\n[$_valueUnit]',
          doubleValue: (data) => _formatDoubleFraction(data.lowLimit.value),
          resizable: false,
        ),
        DaviColumn<StrengthForceLimited>(
          grow: 1,
          name: '${const Localized('High limit').v}\n[$_valueUnit]',
          doubleValue: (data) => _formatDoubleFraction(data.highLimit.value),
          resizable: false,
        ),
        DaviColumn<StrengthForceLimited>(
          grow: 1,
          name: '${const Localized('Limits gap').v}\n[%]',
          doubleValue: (data) => _formatDoubleFraction(
            _extractGapFromLimits(data) * 100.0,
          ),
        ),
        DaviColumn<StrengthForceLimited>(
          width: 72,
          name: const Localized('Status').v,
          intValue: (force) => _extractPassStatus(force) ? 1 : 0,
          cellBuilder: (_, row) => _PassStatusWidget(
            force: row.data,
            isPassed: _extractPassStatus,
          ),
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
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) => snapshot.hasData
          ? TableView(
              model: _model..replaceRows(snapshot.data!),
              headerHeight: 48.0,
              tableBorderColor: Colors.transparent,
            )
          : const Center(child: CupertinoActivityIndicator()),
    );
  }
  //
  double _formatDoubleFraction(double value, {int fractionDigits = 1}) {
    return double.parse(value.toStringAsFixed(fractionDigits));
  }
  //
  double _extractGapFromLimits(StrengthForceLimited forceLimited) {
    final value = forceLimited.force.value;
    final valueFraction = value >= 0.0
        ? (value / forceLimited.highLimit.value)
        : (value / forceLimited.lowLimit.value);
    return valueFraction;
  }
  //
  bool _extractPassStatus(StrengthForceLimited forceLimited) {
    final value = forceLimited.force.value;
    return (value > forceLimited.lowLimit.value &&
        value < forceLimited.highLimit.value);
  }
}
///
class _PassStatusWidget extends StatelessWidget {
  final StrengthForceLimited force;
  final bool Function(StrengthForceLimited force) isPassed;
  ///
  const _PassStatusWidget({
    required this.force,
    required this.isPassed,
  });
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const passedColor = Colors.lightGreen;
    final errorColor = theme.alarmColors.class3;
    return isPassed(force)
        ? const Icon(
            Icons.done,
            color: passedColor,
          )
        : Icon(
            Icons.error_outline,
            color: errorColor,
          );
  }
}
