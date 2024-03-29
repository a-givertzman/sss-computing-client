import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/chart_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/grid_line.dart';

///
class ShipScheme extends StatefulWidget {
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final List<(double, double, String)> _framesTheoretic;
  final List<(double, String)> _framesReal;
  final (String, double, double) _body;
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  final String? _caption;
  final TransformationController? _trController;

  ///
  const ShipScheme({
    super.key,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required (String, double, double) body,
    required List<(double, double, String)> framesTheoretic,
    required List<(double, String)> framesReal,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    String? caption,
    TransformationController? trController,
  })  : _caption = caption,
        _trController = trController,
        _body = body,
        _yAxis = yAxis,
        _framesTheoretic = framesTheoretic,
        _framesReal = framesReal,
        _maxX = maxX,
        _minX = minX,
        _maxY = maxY,
        _minY = minY,
        _xAxis = xAxis;

  ///
  @override
  State<ShipScheme> createState() => _ShipSchemeState();
}

///
class _ShipSchemeState extends State<ShipScheme> {
  late final TransformationController _trController;
  late double _width;
  late double _height;
  double _trShiftX = 0.0;
  double _trShiftY = 0.0;
  double _trScaleX = 1.0;
  double _trScaleY = 1.0;

  ///
  void _handleTransform() {
    setState(() {
      _trScaleX = _trController.value[0];
      _trScaleY = _trController.value[5];
      _trShiftX = _trController.value.getTranslation()[0];
      _trShiftY = _trController.value.getTranslation()[1];
      // Log('$runtimeType').warning(widget._caption);
    });
  }

  ///
  @override
  void initState() {
    _trController = widget._trController ?? TransformationController();
    _trController.addListener(_handleTransform);
    _width = (widget._maxX ?? 0.0) -
        (widget._minX ?? 0.0) +
        widget._xAxis.valueInterval;
    _height = (widget._maxY ?? 0.0) -
        (widget._minY ?? 0.0) +
        widget._yAxis.valueInterval;
    super.initState();
  }

  ///
  @override
  void dispose() {
    _trController.removeListener(_handleTransform);
    _trController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final BoxConstraints(
          :maxWidth,
          :maxHeight,
        ) = constraints;

        var (scaleX, scaleY) = (
          (maxWidth - widget._yAxis.labelsSpaceReserved) / _width,
          (maxHeight - widget._xAxis.labelsSpaceReserved) / _height,
        );
        scaleX = scaleX < scaleY ? scaleX : scaleY;
        scaleY = scaleY < scaleX ? scaleY : scaleX;
        return SizedBox(
          width: _width * scaleX + widget._yAxis.labelsSpaceReserved,
          height: _height * scaleY + widget._xAxis.labelsSpaceReserved,
          child: Stack(
            children: [
              // Grid
              Positioned(
                left: widget._yAxis.labelsSpaceReserved,
                bottom: widget._xAxis.labelsSpaceReserved,
                right: 0.0,
                top: 0.0,
                child: _ShipSchemeGrid(
                  xAxis: widget._xAxis,
                  scaleX: scaleX * _trScaleX,
                  shiftX: _trShiftX / _trScaleX / scaleX,
                  minX: (widget._minX ?? 0.0) - widget._xAxis.valueInterval / 2,
                  maxX: (widget._maxX ?? 0.0) + widget._xAxis.valueInterval / 2,
                  yAxis: widget._yAxis,
                  scaleY: scaleY * _trScaleY,
                  shiftY: _trShiftY / _trScaleY / scaleY,
                  minY: (widget._minY ?? 0.0) - widget._yAxis.valueInterval / 2,
                  maxY: (widget._maxY ?? 0.0) + widget._yAxis.valueInterval / 2,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.25),
                ),
              ),
              // Y-Axis
              Positioned(
                left: 0.0,
                bottom: widget._xAxis.labelsSpaceReserved,
                child: Container(
                  width: widget._yAxis.labelsSpaceReserved,
                  height: _height * scaleY,
                  decoration: const BoxDecoration(
                      // color: Colors.amber,
                      ),
                  child: _ShipSchemeYAxis(
                    axis: widget._yAxis,
                    scaleY: scaleY * _trScaleY,
                    shiftY: _trShiftY / _trScaleY / scaleY,
                    minY:
                        (widget._minY ?? 0.0) - widget._yAxis.valueInterval / 2,
                    maxY:
                        (widget._maxY ?? 0.0) + widget._yAxis.valueInterval / 2,
                  ),
                ),
              ),
              // Layout content
              Positioned(
                left: widget._yAxis.labelsSpaceReserved,
                bottom: widget._xAxis.labelsSpaceReserved,
                child: Container(
                  decoration: const BoxDecoration(
                      // color: Colors.amber,
                      ),
                  child: InteractiveViewer(
                    transformationController: _trController,
                    child: SizedBox(
                      width: _width * scaleX,
                      height: _height * scaleY,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0.0,
                            bottom: 0.0,
                            left: (widget._body.$2 -
                                    (widget._minX ?? 0.0) +
                                    widget._xAxis.valueInterval / 2.0) *
                                scaleX,
                            child: SvgPicture.asset(
                              widget._body.$1,
                              width:
                                  (widget._body.$3 - widget._body.$2) * scaleX,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Frames (real)
              Positioned(
                top: (-((widget._minY ?? 0.0) -
                                widget._yAxis.valueInterval / 2) *
                            _trScaleY *
                            scaleY +
                        _trShiftY)
                    .clamp(
                  0.0,
                  _height * scaleY - 2 * widget._xAxis.labelsSpaceReserved,
                ),
                left: widget._yAxis.labelsSpaceReserved,
                child: Container(
                  width: _width * scaleX,
                  height: 25.0,
                  decoration: const BoxDecoration(
                      // color: Colors.amber,
                      ),
                  child: _ShipSchemeRealFrames(
                    frames: widget._framesReal,
                    axis: const ChartAxis(
                      labelsSpaceReserved: 25.0,
                      valueInterval: 10.0,
                    ),
                    scaleX: scaleX * _trScaleX,
                    shiftX: _trShiftX / _trScaleX / scaleX,
                    minX:
                        (widget._minX ?? 0.0) - widget._xAxis.valueInterval / 2,
                    maxX:
                        (widget._maxX ?? 0.0) + widget._xAxis.valueInterval / 2,
                    minValue: 0,
                    maxValue: widget._framesReal.length - 1,
                  ),
                ),
              ),
              // Frames (theoretic)
              Positioned(
                bottom: widget._xAxis.labelsSpaceReserved,
                left: widget._yAxis.labelsSpaceReserved,
                child: Container(
                  width: _width * scaleX,
                  height: widget._xAxis.labelsSpaceReserved,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: const BoxDecoration(
                      // color: Colors.lightGreen,
                      ),
                  child: _ShipSchemeTheoreticFrames(
                    scaleX: scaleX * _trScaleX,
                    shiftX: _trShiftX / _trScaleX / scaleX,
                    minX:
                        (widget._minX ?? 0.0) - widget._xAxis.valueInterval / 2,
                    maxX:
                        (widget._maxX ?? 0.0) + widget._xAxis.valueInterval / 2,
                    frames: widget._framesTheoretic,
                  ),
                ),
              ),
              // X-Axis
              Positioned(
                bottom: 0.0,
                left: widget._yAxis.labelsSpaceReserved,
                child: Container(
                  width: _width * scaleX,
                  height: widget._xAxis.labelsSpaceReserved,
                  decoration: const BoxDecoration(
                      // color: Colors.amber,
                      ),
                  child: _ShipSchemeXAxis(
                    axis: widget._xAxis,
                    scaleX: scaleX * _trScaleX,
                    shiftX: _trShiftX / _trScaleX / scaleX,
                    minX:
                        (widget._minX ?? 0.0) - widget._xAxis.valueInterval / 2,
                    maxX:
                        (widget._maxX ?? 0.0) + widget._xAxis.valueInterval / 2,
                  ),
                ),
              ),
              // Caption
              if (widget._caption != null)
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Text(
                    widget._caption!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

///
class _ShipSchemeTheoreticFrames extends StatelessWidget {
  final double _minX;
  final double _maxX;
  final double _scaleX;
  final double _shiftX;
  final List<(double, double, String)> _frames;
  final double _thickness;
  final Color? _color;

  ///
  const _ShipSchemeTheoreticFrames({
    required double minX,
    required double maxX,
    required double scaleX,
    required double shiftX,
    required List<(double, double, String)> frames,
    double thickness = 1.0,
    Color? color,
  })  : _shiftX = shiftX,
        _scaleX = scaleX,
        _maxX = maxX,
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
        // clipBehavior: Clip.none,
        children: [
          ..._frames.map((frame) {
            return Positioned(
              left: (frame.$1 - _minX + _shiftX) * _scaleX - _thickness / 2.0,
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
              left: (frame.$2 - _minX + _shiftX) * _scaleX - _thickness / 2.0,
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
              left: (frame.$1 - _minX + _shiftX) * _scaleX,
              top: 0.0,
              bottom: 0.0,
              child: SizedBox(
                width: (frame.$2 - frame.$1) * _scaleX,
                child: Text(
                  frame.$3,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _color ?? theme.colorScheme.primary,
                  ),
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
  final double _scaleX;
  final double _shiftX;
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
    required double scaleX,
    required double shiftX,
    required int minValue,
    required int maxValue,
    required List<(double, String)> frames,
    double thickness = 1.0,
    Color? color,
  })  : _shiftX = shiftX,
        _scaleX = scaleX,
        _frames = frames,
        _maxValue = maxValue,
        _minValue = minValue,
        _thickness = thickness,
        _color = color,
        _minX = minX,
        _maxX = maxX,
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
      final BoxConstraints(maxHeight: height) = constraints;
      return Stack(
        // clipBehavior: Clip.none,
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
              left: (_frames[value].$1 - _minX + _shiftX) * _scaleX -
                  _thickness / 2.0,
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
          ..._getMultiples(1.0, 0.0).map(
            (value) => Positioned(
              left: (_frames[value].$1 - _minX + _shiftX) * _scaleX -
                  _thickness / 2.0,
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
          ..._getMultiples(_axis.valueInterval, 0.0).map(
            (value) => Positioned(
              left: (_frames[value].$1 - _minX + _shiftX) * _scaleX -
                  100.0 / 2 -
                  _thickness / 2.0,
              top: height * 1 / 2,
              bottom: 0.0,
              child: SizedBox(
                width: 100.0,
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
class _ShipSchemeGrid extends StatelessWidget {
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final double _scaleX;
  final double _shiftX;
  final double _scaleY;
  final double _shiftY;
  final double _thickness;
  final Color? _color;

  ///
  const _ShipSchemeGrid({
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required double scaleX,
    required double shiftX,
    required double scaleY,
    required double shiftY,
    double thickness = 1.0,
    Color? color,
  })  : _shiftY = shiftY,
        _scaleY = scaleY,
        _maxY = maxY,
        _minY = minY,
        _yAxis = yAxis,
        _shiftX = shiftX,
        _scaleX = scaleX,
        _thickness = thickness,
        _color = color,
        _maxX = maxX,
        _minX = minX,
        _xAxis = xAxis;

  ///
  List<double> _getMultiples(double divisor, double offset, double size) {
    return List<double>.generate(
      (size - offset) ~/ divisor + 1,
      (idx) => idx * divisor,
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (_, constraints) {
      // final BoxConstraints(maxHeight: height, max) = constraints;
      return Stack(
        children: [
          // Vertical lines
          ..._getMultiples(
            _xAxis.valueInterval,
            _xAxis.valueInterval,
            _maxX - _minX,
          ).map(
            (value) => Positioned(
              left: (value + _minX.abs() % _xAxis.valueInterval + _shiftX) *
                      _scaleX -
                  _thickness / 2.0,
              top: 0.0,
              bottom: 0.0,
              child: GridLine(
                direction: Direction.vertical,
                color: _color ?? theme.colorScheme.primary,
                thickness: _thickness,
              ),
            ),
          ),
          // Horizontal lines
          ..._getMultiples(
            _yAxis.valueInterval,
            _yAxis.valueInterval,
            _maxY - _minY,
          ).map(
            (value) => Positioned(
              top: (value + _minY.abs() % _yAxis.valueInterval + _shiftY) *
                      _scaleY -
                  _thickness / 2.0,
              right: 0.0,
              left: 0.0,
              child: GridLine(
                direction: Direction.horizontal,
                color: _color ?? theme.colorScheme.primary,
                thickness: _thickness,
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
  final double _scaleX;
  final double _shiftX;
  final double _thickness;
  final Color? _color;

  ///
  const _ShipSchemeXAxis({
    required ChartAxis axis,
    required double minX,
    required double maxX,
    required double scaleX,
    required double shiftX,
    double thickness = 1.0,
    Color? color,
  })  : _shiftX = shiftX,
        _scaleX = scaleX,
        _thickness = thickness,
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
        // clipBehavior: Clip.none,
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
              left: (value + _minX.abs() % _axis.valueInterval + _shiftX) *
                      _scaleX -
                  _thickness / 2.0,
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
              left: (value +
                          _minX.abs() % (_axis.valueInterval / 4.0) +
                          _shiftX) *
                      _scaleX -
                  _thickness / 2.0,
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
                  left: (value.$2 +
                              _minX.abs() % _axis.valueInterval -
                              _axis.valueInterval / 2.0 +
                              _shiftX) *
                          _scaleX -
                      _thickness / 2.0,
                  top: height * 1 / 2,
                  bottom: 0.0,
                  child: SizedBox(
                    width: _axis.valueInterval * _scaleX,
                    height: height * 1 / 2,
                    child: Text(
                      // '${(value.$2 + _minX + _minX.abs() % _axis.valueInterval).toInt()}${value.$1 == 0 ? '${_axis.caption}' : ''}',
                      '${(value.$2 + _minX + _minX.abs() % _axis.valueInterval).toInt()}${_axis.caption}',
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
  final double _minY;
  final double _maxY;
  final double _scaleY;
  final double _shiftY;
  final double _thickness;
  final Color? _color;

  ///
  const _ShipSchemeYAxis({
    required ChartAxis axis,
    required double minY,
    required double maxY,
    required double scaleY,
    required double shiftY,
    double thickness = 1.0,
    Color? color,
  })  : _shiftY = shiftY,
        _scaleY = scaleY,
        _thickness = thickness,
        _color = color,
        _maxY = maxY,
        _minY = minY,
        _axis = axis;

  ///
  List<double> _getMultiples(double divisor, double offset) {
    final size = (_maxY - _minY) - offset;
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
      final BoxConstraints(maxWidth: width) = constraints;
      return Stack(
        // clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0.0,
            bottom: 0.0,
            right: 0.0,
            child: GridLine(
              direction: Direction.vertical,
              color: _color ?? theme.colorScheme.primary,
            ),
          ),
          // Major axis ticks
          ..._getMultiples(_axis.valueInterval, _axis.valueInterval).map(
            (value) => Positioned(
              top: (value + _minY.abs() % _axis.valueInterval + _shiftY) *
                      _scaleY -
                  _thickness / 2.0,
              right: 0.0,
              left: width * 1 / 2,
              child: GridLine(
                direction: Direction.horizontal,
                color: _color ?? theme.colorScheme.primary,
                thickness: _thickness,
              ),
            ),
          ),
          // Minor axis ticks
          ..._getMultiples(_axis.valueInterval / 4.0, 0.0).map(
            (value) => Positioned(
              top: (value +
                          _minY.abs() % (_axis.valueInterval / 4.0) +
                          _shiftY) *
                      _scaleY -
                  _thickness / 2.0,
              right: 0.0,
              left: width * 3 / 4,
              child: GridLine(
                direction: Direction.horizontal,
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
                  top: (value.$2 +
                              _minY.abs() % _axis.valueInterval -
                              _axis.valueInterval / 2.0 +
                              _shiftY) *
                          _scaleY -
                      _thickness / 2.0,
                  right: width * 1 / 2,
                  left: 0.0,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: SizedBox(
                      width: _axis.valueInterval * _scaleY,
                      height: width * 1 / 2,
                      child: Text(
                        // '${(value.$2 + _minY + _minY.abs() % _axis.valueInterval).toInt()}${value.$1 == 0 ? '${_axis.caption}' : ''}',
                        '${(value.$2 + _minY + _minY.abs() % _axis.valueInterval).toInt()}${_axis.caption}',
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
