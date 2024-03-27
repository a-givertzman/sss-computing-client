import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/chart_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/grid_line.dart';

///
class ShipScheme extends StatelessWidget {
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final List<(double, double, String)> _framesTheoretic;
  final List<(double, String)> _framesReal;
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  const ShipScheme({
    super.key,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required List<(double, double, String)> framesTheoretic,
    required List<(double, String)> framesReal,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
  })  : _yAxis = yAxis,
        _framesTheoretic = framesTheoretic,
        _framesReal = framesReal,
        _maxX = maxX,
        _minX = minX,
        _maxY = maxY,
        _minY = minY,
        _xAxis = xAxis;

  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = (_maxX ?? 0.0) - (_minX ?? 0.0) + _xAxis.valueInterval;
        final height = (_maxY ?? 0.0) - (_minY ?? 0.0) + _yAxis.valueInterval;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotatedBox(
                  quarterTurns: 1,
                  child: Container(
                    width: height,
                    height: _yAxis.labelsSpaceReserved,
                    decoration: const BoxDecoration(
                        // color: Colors.amber,
                        ),
                    child: _ShipSchemeYAxis(
                      axis: _yAxis,
                      minY: (_minY ?? 0.0) - _yAxis.valueInterval / 2,
                      maxY: (_maxY ?? 0.0) + _yAxis.valueInterval / 2,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      // color: Colors.pink,
                      ),
                  child: SizedBox(
                    height: _xAxis.labelsSpaceReserved,
                    width: _yAxis.labelsSpaceReserved,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: [
                  Positioned(
                    top: height * 1 / 2,
                    child: Container(
                      width: width,
                      height: 25.0,
                      decoration: const BoxDecoration(
                          // color: Colors.amber,
                          ),
                      child: _ShipSchemeRealFrames(
                        frames: _framesReal,
                        axis: const ChartAxis(
                          labelsSpaceReserved: 25.0,
                          caption: 'FR.R',
                          valueInterval: 10.0,
                        ),
                        minX: (_minX ?? 0.0) -
                            _xAxis.valueInterval / 2 -
                            (_minX ?? 0.0),
                        maxX: (_maxX ?? 0.0) +
                            _xAxis.valueInterval / 2 -
                            (_minX ?? 0.0),
                        minValue: 0,
                        maxValue: _framesReal.length - 1,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: _xAxis.labelsSpaceReserved,
                    child: Container(
                      width: width,
                      height: _xAxis.labelsSpaceReserved,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: const BoxDecoration(
                          // color: Colors.lightGreen,
                          ),
                      child: _ShipSchemeTheoreticFrames(
                        minX: (_minX ?? 0.0) - _xAxis.valueInterval / 2,
                        maxX: (_maxX ?? 0.0) + _xAxis.valueInterval / 2,
                        frames: _framesTheoretic,
                      ),
                    ),
                  ),
                  // X-Axis
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: width,
                      height: _xAxis.labelsSpaceReserved,
                      decoration: const BoxDecoration(
                          // color: Colors.amber,
                          ),
                      child: _ShipSchemeXAxis(
                        axis: _xAxis,
                        minX: (_minX ?? 0.0) - _xAxis.valueInterval / 2,
                        maxX: (_maxX ?? 0.0) + _xAxis.valueInterval / 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

///
class _ShipSchemeTheoreticFrames extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final List<(double, double, String)> _frames;
  final double _thickness;
  final Color? _color;

  ///
  const _ShipSchemeTheoreticFrames({
    required double minX,
    required double maxX,
    required List<(double, double, String)> frames,
    double thickness = 1.0,
    Color? color,
  })  : _maxX = maxX,
        _minX = minX,
        _frames = frames,
        _thickness = thickness,
        _color = color;

  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (_, __) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          ..._frames.map((frame) {
            return Positioned(
              left: frame.$1 - _minX - _thickness / 2.0,
              top: 0.0,
              bottom: 0.0,
              child: GridLine(
                direction: Direction.vertical,
                thickness: _thickness,
                color: _color ?? theme.colorScheme.primary,
              ),
            );
          }),
          ..._frames.map((frame) {
            return Positioned(
              left: frame.$2 - _minX - _thickness / 2.0,
              top: 0.0,
              bottom: 0.0,
              child: GridLine(
                direction: Direction.vertical,
                thickness: _thickness,
                color: _color ?? theme.colorScheme.primary,
              ),
            );
          }),
          ..._frames.map((frame) {
            return Positioned(
              left: frame.$1 - _minX,
              right: _maxX - frame.$2,
              top: 0.0,
              bottom: 0.0,
              child: Text(
                frame.$3,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _color ?? theme.colorScheme.primary,
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}

class _ShipSchemeRealFrames extends StatelessWidget {
  final ChartAxis _axis;
  final double _minX;
  final double _maxX;
  final int _minValue;
  final int _maxValue;
  final List<(double, String)> _frames;
  final double _thickness;
  final Color? _color;

  ///
  const _ShipSchemeRealFrames({
    required ChartAxis axis,
    required double minX,
    required double maxX,
    required int minValue,
    required int maxValue,
    required List<(double, String)> frames,
    double thickness = 1.0,
    Color? color,
  })  : _frames = frames,
        _maxValue = maxValue,
        _minValue = minValue,
        _thickness = thickness,
        _color = color,
        _minX = maxX,
        _maxX = minX,
        _axis = axis;

  ///
  List<int> _getMultiples(double divisor, double offset) {
    final size = (_maxValue - _minValue) - offset;
    return List<int>.generate(
      size ~/ divisor + 1,
      (idx) => (idx * divisor).toInt(),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (_, constraints) {
      Log('$runtimeType').warning(_getMultiples(_axis.valueInterval, 0.0));
      final BoxConstraints(maxHeight: height) = constraints;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: GridLine(
              direction: Direction.horizontal,
              color: _color ?? theme.colorScheme.primary,
            ),
          ),
          // Major axis ticks
          ..._getMultiples(_axis.valueInterval, 0.0).map(
            (value) => Positioned(
              left: _frames[value].$1 - _thickness / 2.0,
              top: 0.0,
              bottom: height * 1 / 2,
              child: GridLine(
                direction: Direction.vertical,
                color: _color ?? theme.colorScheme.primary,
                thickness: _thickness,
              ),
            ),
          ),
          // Minor axis ticks
          // ..._getMultiples(_axis.valueInterval / 4.0, 0.0).map(
          //   (value) => Positioned(
          //     left: value - _thickness / 2.0,
          //     top: 0.0,
          //     bottom: height * 3 / 4,
          //     child: GridLine(
          //       direction: Direction.vertical,
          //       color: _color ?? theme.colorScheme.primary,
          //       thickness: _thickness,
          //     ),
          //   ),
          // ),
          // Value marks
          ..._getMultiples(_axis.valueInterval, 0.0).map(
            (value) => Positioned(
              left: _frames[value].$1 -
                  _thickness / 2.0 -
                  _axis.valueInterval / 2,
              top: height * 1 / 2,
              bottom: 0.0,
              child: SizedBox(
                width: _axis.valueInterval,
                height: height * 1 / 2,
                child: Text(
                  _frames[value].$2,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: (_color ?? theme.colorScheme.primary),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

///
class _ShipSchemeXAxis extends StatelessWidget {
  final ChartAxis _axis;
  final double _minX;
  final double _maxX;
  final double _thickness;
  final Color? _color;

  ///
  const _ShipSchemeXAxis({
    required ChartAxis axis,
    required double minX,
    required double maxX,
    double thickness = 1.0,
    Color? color,
  })  : _thickness = thickness,
        _color = color,
        _maxX = maxX,
        _minX = minX,
        _axis = axis;

  ///
  List<double> _getMultiples(double divisor, double offset) {
    final size = (_maxX - _minX) - offset;
    return List<double>.generate(
      size ~/ divisor + 1,
      (idx) => idx * divisor,
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (_, constraints) {
      final BoxConstraints(maxHeight: height) = constraints;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: GridLine(
              direction: Direction.horizontal,
              color: _color ?? theme.colorScheme.primary,
            ),
          ),
          // Major axis ticks
          ..._getMultiples(_axis.valueInterval, _axis.valueInterval).map(
            (value) => Positioned(
              left: value - _thickness / 2.0 + _axis.valueInterval / 2.0,
              top: 0.0,
              bottom: height * 1 / 2,
              child: GridLine(
                direction: Direction.vertical,
                color: _color ?? theme.colorScheme.primary,
                thickness: _thickness,
              ),
            ),
          ),
          // Minor axis ticks
          ..._getMultiples(_axis.valueInterval / 4.0, 0.0).map(
            (value) => Positioned(
              left: value - _thickness / 2.0,
              top: 0.0,
              bottom: height * 3 / 4,
              child: GridLine(
                direction: Direction.vertical,
                color: _color ?? theme.colorScheme.primary,
                thickness: _thickness,
              ),
            ),
          ),
          // Value marks
          ..._getMultiples(_axis.valueInterval, _axis.valueInterval)
              .indexed
              .map(
                (value) => Positioned(
                  left: value.$2 - _thickness / 2.0,
                  top: height * 1 / 2,
                  bottom: 0.0,
                  child: SizedBox(
                    width: _axis.valueInterval,
                    height: height * 1 / 2,
                    child: Text(
                      '${(value.$2 + _minX + _axis.valueInterval / 2.0).toInt()}${value.$1 == 0 ? '${_axis.caption}' : ''}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: (_color ?? theme.colorScheme.primary),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
        ],
      );
    });
  }
}

///

class _ShipSchemeYAxis extends StatelessWidget {
  final ChartAxis _axis;
  final double _minX;
  final double _maxX;
  final double _thickness;
  final Color? _color;

  ///
  const _ShipSchemeYAxis({
    required ChartAxis axis,
    required double minY,
    required double maxY,
    double thickness = 1.0,
    Color? color,
  })  : _thickness = thickness,
        _color = color,
        _maxX = maxY,
        _minX = minY,
        _axis = axis;

  ///
  List<double> _getMultiples(double divisor, double offset) {
    final size = (_maxX - _minX) - offset;
    return List<double>.generate(
      size ~/ divisor + 1,
      (idx) => idx * divisor,
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (_, constraints) {
      final BoxConstraints(maxHeight: height) = constraints;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: GridLine(
              direction: Direction.horizontal,
              color: _color ?? theme.colorScheme.primary,
            ),
          ),
          // Major axis ticks
          ..._getMultiples(_axis.valueInterval, _axis.valueInterval).map(
            (value) => Positioned(
              right: value - _thickness / 2.0 + _axis.valueInterval / 2.0,
              top: 0.0,
              bottom: height * 1 / 2,
              child: GridLine(
                direction: Direction.vertical,
                color: _color ?? theme.colorScheme.primary,
                thickness: _thickness,
              ),
            ),
          ),
          // Minor axis ticks
          ..._getMultiples(_axis.valueInterval / 4.0, 0.0).map(
            (value) => Positioned(
              right: value - _thickness / 2.0,
              top: 0.0,
              bottom: height * 3 / 4,
              child: GridLine(
                direction: Direction.vertical,
                color: _color ?? theme.colorScheme.primary,
                thickness: _thickness,
              ),
            ),
          ),
          // Value marks
          ..._getMultiples(_axis.valueInterval, _axis.valueInterval)
              .indexed
              .map(
                (value) => Positioned(
                  right: value.$2 - _thickness / 2.0,
                  top: height * 1 / 2,
                  bottom: 0.0,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: SizedBox(
                      width: _axis.valueInterval,
                      height: height * 1 / 2,
                      child: Text(
                        '${(value.$2 + _minX + _axis.valueInterval / 2.0).toInt()}${value.$1 == 0 ? '${_axis.caption}' : ''}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: (_color ?? theme.colorScheme.primary),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
        ],
      );
    });
  }
}
