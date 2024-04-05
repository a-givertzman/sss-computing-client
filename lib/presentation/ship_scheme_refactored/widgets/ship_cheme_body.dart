import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/chart_axis.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/figure.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/figures_test.dart';
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
  final _minZ = 0.0;
  final _maxZ = 25.0;
  final _zAxis = const ChartAxis(
    caption: 'm',
    labelsSpaceReserved: 25.0,
    isLabelsVisible: true,
    valueInterval: 25.0,
    isGridVisible: true,
  );
  final _minY = -15.0;
  final _maxY = 15.0;
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
  late final List<Figure> _figures;

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
    _figures = const [
      shipBody,
      ...compartments,
      ...tanks,
    ];
    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Center(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: SizedBox(
            width: 800,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: ShipScheme(
                    projection: (FigureAxis.x, FigureAxis.z),
                    minX: _minX - _xAxis.valueInterval / 2.0,
                    maxX: _maxX + _xAxis.valueInterval / 2.0,
                    xAxis: _xAxis,
                    invertHorizontal: false,
                    minY: _minZ - _zAxis.valueInterval / 2.0,
                    maxY: _maxZ + _zAxis.valueInterval / 2.0,
                    yAxis: _zAxis,
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
                    figures: _figures,
                  ),
                ),
                SizedBox(
                  height: padding,
                ),
                Flexible(
                  flex: 1,
                  child: ShipScheme(
                    projection: (FigureAxis.x, FigureAxis.y),
                    minX: _minX - _xAxis.valueInterval / 2.0,
                    maxX: _maxX + _xAxis.valueInterval / 2.0,
                    xAxis: _xAxis,
                    invertHorizontal: false,
                    minY: _minY - _yAxis.valueInterval / 2.0,
                    maxY: _maxY + _yAxis.valueInterval / 2.0,
                    yAxis: _zAxis,
                    invertVertical: false,
                    framesReal: _framesReal,
                    framesRealAxis: const ChartAxis(
                      caption: 'FR',
                      labelsSpaceReserved: 25.0,
                      isLabelsVisible: true,
                      valueInterval: 10.0,
                    ),
                    framesTheoretic: _framesTheoretic,
                    transformationController: _controller,
                    figures: _figures,
                  ),
                ),
                SizedBox(
                  height: padding,
                ),
                Flexible(
                  flex: 1,
                  child: ShipScheme(
                    projection: (FigureAxis.y, FigureAxis.z),
                    minX: _minY - _yAxis.valueInterval / 2.0,
                    maxX: _maxY + _yAxis.valueInterval / 2.0,
                    xAxis: _yAxis,
                    invertHorizontal: false,
                    minY: _minZ - _zAxis.valueInterval / 2.0,
                    maxY: _maxZ + _zAxis.valueInterval / 2.0,
                    yAxis: _zAxis,
                    invertVertical: true,
                    framesReal: _framesReal,
                    framesRealAxis: const ChartAxis(
                      caption: 'FR',
                      labelsSpaceReserved: 25.0,
                      isLabelsVisible: false,
                      isGridVisible: false,
                      valueInterval: 10.0,
                    ),
                    framesTheoretic: _framesTheoretic,
                    transformationController: _controller,
                    figures: _figures,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
