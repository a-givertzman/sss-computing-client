import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class FCircularValueIndicator extends StatelessWidget {
  final Future<ResultF<num>>? _future;
  final String _title;
  final String? _valueUnit;
  final int _fractionDigits;
  final double _minValue;
  final double _maxValue;
  final double? _low;
  final double? _high;
  ///
  const FCircularValueIndicator({
    super.key,
    required Future<ResultF<num>>? future,
    required String title,
    String? valueUnit,
    int fractionDigits = 0,
    double minValue = 0,
    double maxValue = 100,
    double? low,
    double? high,
  })  : _future = future,
        _title = title,
        _valueUnit = valueUnit,
        _fractionDigits = fractionDigits,
        _minValue = minValue,
        _maxValue = maxValue,
        _low = low,
        _high = high;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final future = _future;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_title),
        SizedBox(height: padding),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            final BoxConstraints(
              maxWidth: width,
              maxHeight: height,
            ) = constraints;
            return CircularValueIndicator(
              // fix overflow caused by widget
              size: min(width, height) * 0.93,
              valueUnit: _valueUnit,
              fractionDigits: _fractionDigits,
              min: _minValue,
              max: _maxValue,
              low: _low,
              high: _high,
              stream: future != null
                  ? Stream.fromFuture(
                      future.then(
                        (result) => switch (result) {
                          Ok(:final value) => DsDataPoint<num>(
                              type: DsDataType.real,
                              name: DsPointName('/value'),
                              value: value,
                              status: DsStatus.ok,
                              timestamp: '',
                              cot: DsCot.inf,
                            ),
                          Err(:final error) => throw Exception(error),
                        },
                      ),
                    )
                  : null,
            );
          }),
        ),
      ],
    );
  }
}
