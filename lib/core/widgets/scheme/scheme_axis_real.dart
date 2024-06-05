import 'package:flutter/cupertino.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/models/scheme/scheme_axis_ticks_real.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_axis.dart';
///
class SchemeAxisReal extends StatefulWidget {
  final ChartAxis _axis;
  final double _minValue;
  final double _maxValue;
  final double Function(double) _transformValue;
  final int _labelFractionDigits;
  final TextStyle? _labelStyle;
  final Color _color;
  ///
  const SchemeAxisReal({
    super.key,
    required ChartAxis axis,
    required double minValue,
    required double maxValue,
    required double Function(double) transformValue,
    int labelFractionDigits = 0,
    TextStyle? labelStyle,
    required Color color,
  })  : _axis = axis,
        _minValue = minValue,
        _maxValue = maxValue,
        _transformValue = transformValue,
        _labelFractionDigits = labelFractionDigits,
        _labelStyle = labelStyle,
        _color = color;
  //
  @override
  State<SchemeAxisReal> createState() => _SchemeAxisRealState();
}
class _SchemeAxisRealState extends State<SchemeAxisReal> {
  late final List<({double offset, String? label})> _majorTicks;
  late final List<({double offset, String? label})> _minorTicks;
  //
  @override
  void initState() {
    _majorTicks = SchemeAxisTicksReal(
      minValue: widget._minValue,
      maxValue: widget._maxValue,
      valueInterval: widget._axis.valueInterval,
      valueLabel: widget._axis.valueUnit,
      labelFractionDigits: widget._labelFractionDigits,
    ).ticks();
    _minorTicks = SchemeAxisTicksReal(
      minValue: widget._minValue,
      maxValue: widget._maxValue,
      valueInterval: widget._axis.valueInterval / 5.0,
    ).ticks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SchemeAxis(
      axis: widget._axis,
      color: widget._color,
      labelStyle: widget._labelStyle,
      majorTicks: _majorTicks,
      minorTicks: _minorTicks,
      transformValue: widget._transformValue,
    );
  }
}
