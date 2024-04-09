import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/chart_axis.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/figure.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/figures_test.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_options.dart';

///
const Set<ShipSchemeOption> _initialOptions = {
  ShipSchemeOption.showGrid,
  ShipSchemeOption.showAxes,
  // ShipSchemeOption.showFrames,
  // ShipSchemeOption.showWaterline,
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
  // final _controller = TransformationController();
  late final List<Figure> _figures;
  late final Figure _body;
  late final List<(double, double, int)> _framesTheoretic;
  late final List<(double, int)> _framesReal;
  static const _frameTNumber = 20;
  static const _frameRNumber = 100;
  static const _framesRealIdxShift = -10;
  late int _currentRFrameIdx;
  late bool _isViewInteractive;

  ///
  @override
  // ignore: long-method
  void initState() {
    _framesTheoretic = List<(double, double, int)>.generate(
      _frameTNumber,
      (index) {
        const width = (_maxX - _minX) / _frameTNumber;
        return (
          _minX + index * width,
          _minX + (index + 1) * width,
          index,
        );
      },
    );
    _framesReal = [
      ...List<(double, int)>.generate(25, (index) {
        const width = (_maxX - _minX) / 2 / _frameRNumber;
        return (_minX + index * width, index + _framesRealIdxShift);
      }),
      ...List<(double, int)>.generate(25, (index) {
        const width = (_maxX - _minX) / _frameRNumber;
        return (
          _minX + ((_maxX - _minX) / 2 / _frameRNumber) * 25 + (index) * width,
          index + 25 + _framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(50, (index) {
        const width = (_maxX - _minX) / 2 / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 25 +
              ((_maxX - _minX) / _frameRNumber) * 25 +
              (index) * width,
          index + 50 + _framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(25, (index) {
        const width = (_maxX - _minX) / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 75 +
              ((_maxX - _minX) / _frameRNumber) * 25 +
              (index) * width,
          index + 100 + _framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(25, (index) {
        const width = (_maxX - _minX) / 2 / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 25 +
              ((_maxX - _minX) / _frameRNumber) * 75 +
              (index) * width,
          index + 125 + _framesRealIdxShift,
        );
      }),
    ];
    _currentRFrameIdx = (_framesReal.length / 2.0).ceil();
    _figures = [
      ...compartments.map(
        (compartment) => BoundedFigure(figure: compartment, bounder: shipBody),
      ),
    ];
    _body = shipBody;
    _isViewInteractive = true;
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
      caption: 'F',
      labelsSpaceReserved: _axesSpaceReserved,
      isLabelsVisible: _options.contains(ShipSchemeOption.showRealFrames),
      valueInterval: 10.0,
    );
    final framesTheoreticAxis = ChartAxis(
      caption: 'FT',
      labelsSpaceReserved: _axesSpaceReserved / 2.0,
      isLabelsVisible: _options.contains(ShipSchemeOption.showTheoreticFrames),
    );
    final waterlines = [
      if (_options.contains(ShipSchemeOption.showWaterline)) ...{
        const WaterineFigure(
          begin: Offset(_minX * 2, 2.5),
          end: Offset(_maxX * 2, 2.5),
          axes: (FigureAxis.x, FigureAxis.z),
          borderColor: Colors.blue,
        ),
        const WaterineFigure(
          begin: Offset(_minY * 3, 2.5),
          end: Offset(_maxY * 3, 2.5),
          axes: (FigureAxis.y, FigureAxis.z),
          borderColor: Colors.blue,
        ),
      },
    ];
    final figures = [
      ..._figures,
    ];
    return Center(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: SizedBox(
            width: 1150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Switch(
                        value: _isViewInteractive,
                        onChanged: (val) => setState(() {
                          _isViewInteractive = val;
                        }),
                      ),
                    ),
                    ShipSchemeOptions(
                      initialOptions: _options,
                      onOptionsChanged: (newOptions) => setState(() {
                        _options = newOptions;
                      }),
                    ),
                    const Spacer(),
                  ],
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
                    framesTheoreticAxis: framesTheoreticAxis,
                    // transformationController: _controller,
                    shipBody: _body,
                    figures: [
                      ...figures,
                      ...waterlines,
                    ],
                    isViewInteractive: _isViewInteractive,
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
                    framesTheoreticAxis: framesTheoreticAxis,
                    // transformationController: _controller,
                    shipBody: _body,
                    figures: [
                      ...figures,
                      ...waterlines,
                    ],
                    isViewInteractive: _isViewInteractive,
                  ),
                ),
                SizedBox(
                  height: padding,
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShipScheme(
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
                          isLabelsVisible: false,
                        ),
                        framesTheoretic: _framesTheoretic,
                        framesTheoreticAxis: const ChartAxis(
                          isLabelsVisible: false,
                        ),
                        // transformationController: _controller,
                        shipBody: _body,
                        figures: [
                          ...figures,
                          ...waterlines,
                        ],
                        isViewInteractive: _isViewInteractive,
                      ),
                      SizedBox(
                        width: padding,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ShipScheme(
                            caption:
                                '${_currentRFrameIdx + _framesRealIdxShift} Fr. FWD→AFT',
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
                              isLabelsVisible: false,
                            ),
                            framesTheoretic: _framesTheoretic,
                            framesTheoreticAxis: const ChartAxis(
                              isLabelsVisible: false,
                            ),
                            // transformationController: _controller,
                            shipBody: _body,
                            figures: [
                              ...waterlines,
                              ...figures.where((figure) {
                                final dxCut = _framesReal[_currentRFrameIdx].$1;
                                final bounds = figure
                                    .getOrthoProjection(
                                      FigureAxis.x,
                                      FigureAxis.y,
                                    )
                                    .getBounds();
                                return (dxCut > bounds.left &&
                                    dxCut <= bounds.right);
                              }),
                            ],
                            isViewInteractive: _isViewInteractive,
                          ),
                          SizedBox(
                            width: padding,
                          ),
                          RotatedBox(
                            quarterTurns: -1,
                            child: SliderTheme(
                              data: SliderThemeData(
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                inactiveColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.25),
                                min: 0.0,
                                max: _framesReal.length.toDouble() - 1,
                                value: _currentRFrameIdx.toDouble(),
                                onChanged: (value) => setState(() {
                                  _currentRFrameIdx = value.toInt();
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
