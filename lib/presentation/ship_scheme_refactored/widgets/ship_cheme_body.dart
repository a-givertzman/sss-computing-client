import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/chart_axis.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/figure.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/figures_test.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/ship_scheme.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/ship_scheme_options.dart';

const Set<ShipSchemeOption> _initialOptions = {
  ShipSchemeOption.showGrid,
  ShipSchemeOption.showAxes,
  ShipSchemeOption.showFramesReal,
};

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
  var _options = _initialOptions;
  static const _axesSpaceReserved = 25.0;
  static const _minX = -100.0;
  static const _maxX = 100.0;
  static const _minZ = 0.0;
  static const _maxZ = 25.0;
  static const _minY = -15.0;
  static const _maxY = 15.0;
  static const _frameTNumber = 20;
  static const _frameRNumber = 100;
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
        const width = (_maxX - _minX) / _frameTNumber;
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
        const width = (_maxX - _minX) / 2 / _frameRNumber;
        // return (minX + index * width, '$index${index == 0 ? 'FR' : ''}');
        return (_minX + index * width, index + framesRealIdxShift);
      }),
      ...List<(double, int)>.generate(25, (index) {
        const width = (_maxX - _minX) / _frameRNumber;
        return (
          _minX + ((_maxX - _minX) / 2 / _frameRNumber) * 25 + (index) * width,
          index + 25 + framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(50, (index) {
        const width = (_maxX - _minX) / 2 / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 25 +
              ((_maxX - _minX) / _frameRNumber) * 25 +
              (index) * width,
          index + 50 + framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(25, (index) {
        const width = (_maxX - _minX) / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 75 +
              ((_maxX - _minX) / _frameRNumber) * 25 +
              (index) * width,
          index + 100 + framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(25, (index) {
        const width = (_maxX - _minX) / 2 / _frameRNumber;
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
    final xAxis = ChartAxis(
      caption: 'm',
      labelsSpaceReserved: _axesSpaceReserved,
      isLabelsVisible: _options.contains(ShipSchemeOption.showAxes),
      valueInterval: 25.0,
      isGridVisible: _options.contains(ShipSchemeOption.showGrid),
    );
    final yAxis = ChartAxis(
      caption: 'm',
      labelsSpaceReserved: _axesSpaceReserved,
      isLabelsVisible: _options.contains(ShipSchemeOption.showAxes),
      valueInterval: 25.0,
      isGridVisible: _options.contains(ShipSchemeOption.showGrid),
    );
    final zAxis = ChartAxis(
      caption: 'm',
      labelsSpaceReserved: _axesSpaceReserved,
      isLabelsVisible: _options.contains(ShipSchemeOption.showAxes),
      valueInterval: 25.0,
      isGridVisible: _options.contains(ShipSchemeOption.showGrid),
    );
    final framesRealAxis = ChartAxis(
      caption: 'FR',
      labelsSpaceReserved: _axesSpaceReserved,
      isLabelsVisible: _options.contains(ShipSchemeOption.showFramesReal),
      valueInterval: 10.0,
    );
    return Center(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: SizedBox(
            width: 800,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ShipSchemeOptions(
                    initialOptions: _options,
                    onOptionsChanged: (newOptions) => setState(() {
                      _options = newOptions;
                    }),
                  ),
                ),
                SizedBox(
                  height: padding * 2,
                ),
                Flexible(
                  flex: 1,
                  child: ShipScheme(
                    caption: 'Side View',
                    projection: (FigureAxis.x, FigureAxis.z),
                    minX: _minX - xAxis.valueInterval / 2.0,
                    maxX: _maxX + xAxis.valueInterval / 2.0,
                    xAxis: xAxis,
                    invertHorizontal: false,
                    minY: _minZ - zAxis.valueInterval / 2.0,
                    maxY: _maxZ + zAxis.valueInterval / 2.0,
                    yAxis: zAxis,
                    invertVertical: true,
                    framesReal: _framesReal,
                    framesRealAxis: framesRealAxis,
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
                    caption: 'Top View',
                    projection: (FigureAxis.x, FigureAxis.y),
                    minX: _minX - xAxis.valueInterval / 2.0,
                    maxX: _maxX + xAxis.valueInterval / 2.0,
                    xAxis: xAxis,
                    invertHorizontal: false,
                    minY: _minY - yAxis.valueInterval / 2.0,
                    maxY: _maxY + yAxis.valueInterval / 2.0,
                    yAxis: zAxis,
                    invertVertical: false,
                    framesReal: _framesReal,
                    framesRealAxis: framesRealAxis,
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
                    caption: 'Front View',
                    projection: (FigureAxis.y, FigureAxis.z),
                    minX: _minY - yAxis.valueInterval / 2.0,
                    maxX: _maxY + yAxis.valueInterval / 2.0,
                    xAxis: yAxis,
                    invertHorizontal: false,
                    minY: _minZ - zAxis.valueInterval / 2.0,
                    maxY: _maxZ + zAxis.valueInterval / 2.0,
                    yAxis: zAxis,
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
