import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/core/models/chart_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/ship_scheme.dart';

///
class ShipSchemeBody extends StatefulWidget {
  ///
  const ShipSchemeBody({super.key});

  ///
  @override
  State<ShipSchemeBody> createState() => _ShipSchemeBodyState();
}

///
class _ShipSchemeBodyState extends State<ShipSchemeBody> {
  final _minX = -100.0;
  final _maxX = 100.0;
  final _xAxis = const ChartAxis(
    caption: 'm',
    labelsSpaceReserved: 25.0,
    isLabelsVisible: true,
    valueInterval: 25.0,
    isGridVisible: true,
  );
  final _minY = 0.0;
  final _maxY = 25.0;
  final _yAxis = const ChartAxis(
    caption: 'm',
    labelsSpaceReserved: 25.0,
    isLabelsVisible: true,
    valueInterval: 25.0,
    isGridVisible: true,
  );
  final _frameTNumber = 20;
  final _frameRNumber = 100;
  final _controller = TransformationController();
  late final List<(double, double, String)> _framesTheoretic;
  late final List<(double, int)> _framesReal;

  ///
  @override
  // ignore: long-method
  void initState() {
    _framesTheoretic = List<(double, double, String)>.generate(
      _frameTNumber,
      (index) {
        final width = (_maxX - _minX) / _frameTNumber;
        return (
          _minX + index * width,
          _minX + (index + 1) * width,
          // '$index${index == 0 ? 'FT' : ''}'
          '${index}FT'
        );
      },
    );
    const framesRealIdxShift = -10;
    _framesReal = [
      ...List<(double, int)>.generate(25, (index) {
        final width = (_maxX - _minX) / 2 / _frameRNumber;
        // return (minX + index * width, '$index${index == 0 ? 'FR' : ''}');
        return (_minX + index * width, index + framesRealIdxShift);
      }),
      ...List<(double, int)>.generate(25, (index) {
        final width = (_maxX - _minX) / _frameRNumber;
        return (
          _minX + ((_maxX - _minX) / 2 / _frameRNumber) * 25 + (index) * width,
          index + 25 + framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(50, (index) {
        final width = (_maxX - _minX) / 2 / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 25 +
              ((_maxX - _minX) / _frameRNumber) * 25 +
              (index) * width,
          index + 50 + framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(25, (index) {
        final width = (_maxX - _minX) / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 75 +
              ((_maxX - _minX) / _frameRNumber) * 25 +
              (index) * width,
          index + 100 + framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(25, (index) {
        final width = (_maxX - _minX) / 2 / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 25 +
              ((_maxX - _minX) / _frameRNumber) * 75 +
              (index) * width,
          index + 125 + framesRealIdxShift,
        );
      }),
    ];
    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: SizedBox(
            width: 1100.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LayoutBuilder(builder: (_, constraints) {
                  final BoxConstraints(
                    maxWidth: width,
                    maxHeight: height,
                  ) = constraints;
                  final (scaleX, scaleY) = (
                    (width -
                            (_yAxis.isLabelsVisible
                                ? _yAxis.labelsSpaceReserved
                                : 0.0)) /
                        (_maxX - _minX + _xAxis.valueInterval),
                    (height -
                            (_xAxis.isLabelsVisible
                                ? _xAxis.labelsSpaceReserved
                                : 0.0)) /
                        (_maxY - _minY + _yAxis.valueInterval),
                  );
                  final scale = min(scaleX, scaleY);
                  return ShipScheme(
                    minX: _minX - _xAxis.valueInterval / 2.0,
                    maxX: _maxX + _xAxis.valueInterval / 2.0,
                    scaleX: scale,
                    xAxis: _xAxis,
                    invertHorizontal: false,
                    minY: _minY - _yAxis.valueInterval / 2.0,
                    maxY: _maxY + _yAxis.valueInterval / 2.0,
                    scaleY: scale,
                    yAxis: _yAxis,
                    invertVertical: true,
                    framesReal: _framesReal,
                    framesRealAxis: const ChartAxis(
                      caption: 'FR',
                      labelsSpaceReserved: 25.0,
                      isLabelsVisible: true,
                      valueInterval: 10.0,
                    ),
                    framesTheoretic: _framesTheoretic,
                    transformationController: _controller,
                    body: ('assets/img/side3.svg', -100.0, 100.0),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
