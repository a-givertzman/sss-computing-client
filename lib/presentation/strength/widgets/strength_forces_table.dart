import 'dart:math';
import 'package:davi/davi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';
///
class StrengthForceTable extends StatefulWidget {
  final String _valueUnit;
  final Stream<List<StrengthForce>> _stream;
  ///
  const StrengthForceTable({
    super.key,
    required String valueUnit,
    required Stream<List<StrengthForce>> stream,
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
  final Stream<List<StrengthForce>> _stream;
  late final DaviModel<StrengthForce> _model;
  ///
  _StrengthForceTableState({
    required String valueUnit,
    required Stream<List<StrengthForce>> stream,
  })  : _valueUnit = valueUnit,
        _stream = stream;
  //
  @override
  void initState() {
    _model = DaviModel(
      columns: [
        DaviColumn<StrengthForce>(
          name: const Localized('Spatium').v,
          intValue: (force) => force.frameSpace.index,
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('Value').v} [$_valueUnit]',
          doubleValue: (force) => force.value,
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('Low limit').v} [$_valueUnit]',
          doubleValue: (force) => force.lowLimit,
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('High limit').v} [$_valueUnit]',
          doubleValue: (force) => force.highLimit,
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('Limits gap').v} [%]',
          stringValue: (force) =>
              (_extractGapFromLimits(force) * 100).toStringAsFixed(1),
        ),
        DaviColumn<StrengthForce>(
          name: const Localized('Status').v,
          cellBuilder: (_, row) => _PassStatusWidget(force: row.data),
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
          ? TableView(model: _model..replaceRows(snapshot.data!))
          : const Center(child: CupertinoActivityIndicator()),
    );
  }
  //
  double _extractGapFromLimits(StrengthForce forceData) {
    final value = forceData.value ?? 0.0;
    final valueRange = forceData.highLimit - forceData.lowLimit;
    final gapFromHigh = forceData.highLimit - value;
    final gapFromLow = value - forceData.lowLimit;
    return min(gapFromHigh / valueRange, gapFromLow / valueRange);
  }
}
///
class _PassStatusWidget extends StatelessWidget {
  final StrengthForce force;
  ///
  const _PassStatusWidget({required this.force});
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const passedColor = Colors.lightGreen;
    final errorColor = theme.alarmColors.class3;
    final value = force.value ?? 0.0;
    return (value > force.lowLimit && value < force.highLimit)
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
