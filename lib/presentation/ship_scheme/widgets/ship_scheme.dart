import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/chart_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/grid_line.dart';

///
class ShipScheme extends StatelessWidget {
  final ChartAxis _xAxis;
  final List<(double, double, String)> _frames;
  final double? _minX;
  final double? _maxX;
  const ShipScheme({
    super.key,
    required ChartAxis xAxis,
    required List<(double, double, String)> frames,
    double? minX,
    double? maxX,
  })  : _frames = frames,
        _maxX = maxX,
        _minX = minX,
        _xAxis = xAxis;

  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = (_maxX ?? 0.0) - (_minX ?? 0.0) + _xAxis.valueInterval;
        final height = ((_maxX ?? 0.0) - (_minX ?? 0.0)) / 2.0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO: Ship body lines
            Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(
                  // color: Colors.purple,
                  ),
              child: const Stack(
                children: [
                  Text('-- ShipSchemeBody --'),
                ],
              ),
            ),
            // Ship frames labels
            Container(
              width: width,
              height: _xAxis.labelsSpaceReserved,
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: const BoxDecoration(
                  // color: Colors.lightGreen,
                  ),
              child: _ShipSchemeFrames(
                minX: (_minX ?? 0.0) - _xAxis.valueInterval / 2,
                maxX: (_maxX ?? 0.0) + _xAxis.valueInterval / 2,
                frames: _frames,
              ),
            ),
            // X-Axis
            Container(
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
            // X-Axis caption
            if (_xAxis.caption != null)
              Container(
                width: width,
                height: _xAxis.captionSpaceReserved,
                decoration: const BoxDecoration(
                    // color: Colors.teal,
                    ),
                child: Center(
                  child: Text(
                    '${_xAxis.caption}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

///
class _ShipSchemeFrames extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final List<(double, double, String)> _frames;
  final double _thickness;
  final Color? _color;

  ///
  const _ShipSchemeFrames({
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
          ..._getMultiples(_axis.valueInterval, _axis.valueInterval).map(
            (value) => Positioned(
              left: value - _thickness / 2.0,
              top: height * 1 / 2,
              bottom: 0.0,
              child: SizedBox(
                width: _axis.valueInterval,
                height: height * 1 / 2,
                child: Text(
                  '${value + _minX + _axis.valueInterval / 2.0}',
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
