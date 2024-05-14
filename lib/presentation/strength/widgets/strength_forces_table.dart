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
          width: 42,
          name: '#',
          intValue: (force) => force.frameIndex,
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('Value').v}\n[$_valueUnit]',
          doubleValue: (force) => _formatDoubleFraction(force.value),
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('Low limit').v}\n[$_valueUnit]',
          doubleValue: (force) => _formatDoubleFraction(force.lowLimit),
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('High limit').v}\n[$_valueUnit]',
          doubleValue: (force) => _formatDoubleFraction(force.highLimit),
          resizable: false,
        ),
        DaviColumn<StrengthForce>(
          grow: 1,
          name: '${const Localized('Limits gap').v}\n[%]',
          doubleValue: (force) => _formatDoubleFraction(
            _extractGapFromLimits(force) * 100.0,
          ),
        ),
        DaviColumn<StrengthForce>(
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
  double _extractGapFromLimits(StrengthForce force) {
    final value = force.value;
    final valueFraction =
        value >= 0.0 ? (value / force.highLimit) : (value / force.lowLimit);
    return valueFraction;
  }
  //
  bool _extractPassStatus(StrengthForce force) {
    final value = force.value;
    return (value > force.lowLimit && value < force.highLimit);
  }
}
///
class _PassStatusWidget extends StatelessWidget {
  final StrengthForce force;
  final bool Function(StrengthForce force) isPassed;
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
