import 'dart:math';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';
///
class TableWidget extends StatefulWidget {
  final String _valueUnit;
  final List<StrengthForce> _strengthForces;
  ///
  const TableWidget({
    super.key,
    required String valueUnit,
    required List<StrengthForce> strengthForces,
  })  : _valueUnit = valueUnit,
        _strengthForces = strengthForces;
  @override
  State<TableWidget> createState() => _TableWidgetState();
}
class _TableWidgetState extends State<TableWidget> {
  late final DaviModel<StrengthForce> _model;
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
          name: '${const Localized('Value').v} [${widget._valueUnit}]',
          doubleValue: (force) => force.value,
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('Low limit').v} [${widget._valueUnit}]',
          doubleValue: (force) => force.lowLimit,
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('High limit').v} [${widget._valueUnit}]',
          doubleValue: (force) => force.highLimit,
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('Limits gap').v} [%]',
          stringValue: (force) =>
              (_extractGapFromLimits(force) * 100).toStringAsFixed(1),
        ),
        DaviColumn(
          name: const Localized('Status').v,
          cellBuilder: (_, row) => _PassStatusWidget(force: row.data),
        ),
      ],
      rows: widget._strengthForces,
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
    return TableView(model: _model);
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
