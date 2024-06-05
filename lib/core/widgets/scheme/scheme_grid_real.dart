import 'package:flutter/cupertino.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/models/scheme/scheme_axis_ticks_real.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_grid.dart';
///
class SchemeGridReal extends StatefulWidget {
  final ChartAxis _axis;
  final double _minValue;
  final double _maxValue;
  final double _thickness;
  final double Function(double) _transformValue;
  final Color _color;
  ///
  const SchemeGridReal({
    super.key,
    required ChartAxis axis,
    required double minValue,
    required double maxValue,
    double thickness = 1.0,
    required double Function(double) transformValue,
    required Color color,
  })  : _axis = axis,
        _minValue = minValue,
        _maxValue = maxValue,
        _thickness = thickness,
        _transformValue = transformValue,
        _color = color;
  //
  @override
  State<SchemeGridReal> createState() => _SchemeGridRealState();
}
class _SchemeGridRealState extends State<SchemeGridReal> {
  late final List<double> _offsets;
  //
  @override
  void initState() {
    _offsets = SchemeAxisTicksReal(
      minValue: widget._minValue,
      maxValue: widget._maxValue,
      valueInterval: widget._axis.valueInterval,
    ).ticks().map((tick) => tick.offset).toList();
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return SchemeGrid(
      color: widget._color,
      thickness: widget._thickness,
      offsets: _offsets,
      transformValue: widget._transformValue,
    );
  }
}
