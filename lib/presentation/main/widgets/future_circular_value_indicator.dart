import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        OverflowableText(_title),
        SizedBox(height: padding),
        Flexible(
          child: LayoutBuilder(builder: (context, constraints) {
            return FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                final BoxConstraints(
                  maxWidth: width,
                  maxHeight: height,
                ) = constraints;
                // fix overflow of CircularValueIndicator widget
                final size = min(width, height) * 0.93;
                if (snapshot.hasData) {
                  switch (snapshot.data!) {
                    case Ok(:final value):
                      return _buildIndicator(
                        size: size,
                        stream: Stream.value(DsDataPoint<num>(
                          value: value,
                          type: DsDataType.real,
                          name: DsPointName('/value'),
                          status: DsStatus.ok,
                          timestamp: '',
                          cot: DsCot.act,
                        )),
                      );
                    case Err(:final error):
                      return _buildIndicator(
                        size: size,
                        stream: Stream.error(error),
                      );
                  }
                }
                if (snapshot.hasError) {
                  return _buildIndicator(
                    size: size,
                    stream: Stream.error(snapshot.error!),
                  );
                }
                return _buildIndicator(
                  size: size,
                  stream: const Stream.empty(),
                );
              },
            );
          }),
        ),
      ],
    );
  }
  //
  Widget _buildIndicator({
    required double size,
    Stream<DsDataPoint<num>>? stream,
  }) {
    return CircularValueIndicator(
      stream: stream,
      size: size,
      valueUnit: _valueUnit,
      fractionDigits: _fractionDigits,
      min: _minValue,
      max: _maxValue,
      low: _low,
      high: _high,
    );
  }
}
