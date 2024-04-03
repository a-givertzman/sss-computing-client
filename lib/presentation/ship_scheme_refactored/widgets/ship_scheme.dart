import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sss_computing_client/presentation/core/models/chart_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/ship_scheme_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/ship_scheme_grid.dart';

class ShipScheme extends StatefulWidget {
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final ChartAxis _framesRealAxis;
  // final List<(double, double, String)> _framesTheoretic;
  final List<(double, int)> _framesReal;
  final (String, double, double) _body;
  final TransformationController? _transformationController;
  final bool _invertHorizontal;
  final bool _invertVertical;
  final double? _minX;
  final double? _maxX;
  final double _scaleX;
  final double? _minY;
  final double? _maxY;
  final double _scaleY;
  final Color? _axisColor;

  ///
  const ShipScheme({
    super.key,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required ChartAxis framesRealAxis,
    required (String, double, double) body,
    required List<(double, double, String)> framesTheoretic,
    required List<(double, int)> framesReal,
    TransformationController? transformationController,
    bool invertHorizontal = false,
    bool invertVertical = false,
    double? minX,
    double? maxX,
    double scaleX = 1.0,
    double? minY,
    double? maxY,
    double scaleY = 1.0,
    String? caption,
    Color? axisColor,
  })  : _scaleY = scaleY,
        _scaleX = scaleX,
        _invertVertical = invertVertical,
        _invertHorizontal = invertHorizontal,
        _framesRealAxis = framesRealAxis,
        _axisColor = axisColor,
        _body = body,
        _yAxis = yAxis,
        // _framesTheoretic = framesTheoretic,
        _framesReal = framesReal,
        _transformationController = transformationController,
        _maxX = maxX,
        _minX = minX,
        _maxY = maxY,
        _minY = minY,
        _xAxis = xAxis;

  ///
  @override
  State<ShipScheme> createState() => _ShipSchemeState();
}

class _ShipSchemeState extends State<ShipScheme> {
  late final double _minX;
  late final double _maxX;
  late final List<(double, String)> _xMajorTicks;
  late final List<double> _xMinorTicks;
  late final List<double> _xAxisGrid;
  late final double _minY;
  late final double _maxY;
  late final List<(double, String)> _yMajorTicks;
  late final List<double> _yMinorTicks;
  late final List<double> _yAxisGrid;
  late final double _contentWidth;
  late final double _contentHeight;
  late final double _xAxisSpaceReserved;
  late final double _yAxisSpaceReserved;
  late final TransformationController _transformationController;
  double _trShiftX = 0.0;
  double _trShiftY = 0.0;
  double _trScaleX = 1.0;
  double _trScaleY = 1.0;

  ///
  @override
  void initState() {
    _transformationController =
        widget._transformationController ?? TransformationController();
    _transformationController.addListener(_handleTransform);
    _minX = widget._minX ?? 0.0;
    _maxX = widget._maxX ?? 0.0;
    _minY = widget._minY ?? 0.0;
    _maxY = widget._maxY ?? 0.0;
    _contentWidth = _maxX - _minX;
    _contentHeight = _maxY - _minY;
    _xAxisSpaceReserved =
        widget._xAxis.isLabelsVisible ? widget._xAxis.labelsSpaceReserved : 0.0;
    _yAxisSpaceReserved =
        widget._yAxis.isLabelsVisible ? widget._yAxis.labelsSpaceReserved : 0.0;
    _xMajorTicks = _getMajorTicks(_minX, _maxX, widget._xAxis);
    _xMinorTicks = _getMinorTicks(_minX, _maxX, widget._xAxis);
    _yMajorTicks = _getMajorTicks(_minY, _maxY, widget._yAxis);
    _yMinorTicks = _getMinorTicks(_minY, _maxY, widget._yAxis);
    _xAxisGrid = _xMajorTicks.map((tick) => tick.$1).toList();
    _yAxisGrid = _yMajorTicks.map((tick) => tick.$1).toList();
    super.initState();
  }

  ///
  @override
  void dispose() {
    _transformationController.removeListener(_handleTransform);
    _transformationController.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (layoutWidth, layoutHeight) = (
      _contentWidth * widget._scaleX + _yAxisSpaceReserved,
      _contentHeight * widget._scaleY + _xAxisSpaceReserved,
    );
    return SizedBox(
      width: layoutWidth,
      height: layoutHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Y-Axis
          if (widget._yAxis.isLabelsVisible)
            Positioned(
              top: 0.0,
              bottom: _xAxisSpaceReserved,
              left: 0.0,
              child: RotatedBox(
                quarterTurns: 1,
                child: ShipSchemeAxis(
                  axis: widget._yAxis,
                  transformValue: _transformY,
                  color: widget._axisColor ?? theme.colorScheme.primary,
                  labelStyle: theme.textTheme.labelSmall?.copyWith(
                    color: widget._axisColor ?? theme.colorScheme.primary,
                  ),
                  majorTicks: _yMajorTicks,
                  minorTicks: _yMinorTicks,
                ),
              ),
            ),
          // Y-Axis Grid
          if (widget._yAxis.isGridVisible)
            Positioned(
              top: 0.0,
              bottom: _xAxisSpaceReserved,
              left: _yAxisSpaceReserved,
              right: 0.0,
              child: RotatedBox(
                quarterTurns: 1,
                child: ShipSchemeGrid(
                  transformValue: _transformY,
                  color: widget._axisColor?.withOpacity(0.25) ??
                      theme.colorScheme.primary.withOpacity(0.25),
                  axisGrid: _yAxisGrid,
                ),
              ),
            ),
          // X-Axis
          if (widget._xAxis.isLabelsVisible)
            Positioned(
              bottom: 0.0,
              left: _yAxisSpaceReserved,
              right: 0.0,
              child: ShipSchemeAxis(
                axis: widget._xAxis,
                transformValue: _transformX,
                color: widget._axisColor ?? theme.colorScheme.primary,
                labelStyle: theme.textTheme.labelSmall?.copyWith(
                  color: widget._axisColor ?? theme.colorScheme.primary,
                ),
                majorTicks: _xMajorTicks,
                minorTicks: _xMinorTicks,
              ),
            ),
          // X-Axis Grid
          if (widget._xAxis.isGridVisible)
            Positioned(
              top: 0.0,
              bottom: _xAxisSpaceReserved,
              left: _yAxisSpaceReserved,
              right: 0.0,
              child: ShipSchemeGrid(
                transformValue: _transformX,
                color: widget._axisColor?.withOpacity(0.25) ??
                    theme.colorScheme.primary.withOpacity(0.25),
                axisGrid: _xAxisGrid,
              ),
            ),
          // Layout content
          Positioned(
            top: 0.0,
            bottom: _xAxisSpaceReserved,
            left: _yAxisSpaceReserved,
            right: 0.0,
            child: Stack(
              children: [
                Positioned(
                  top: _transformY(15.0),
                  bottom: layoutHeight - _transformY(0.0) - _xAxisSpaceReserved,
                  left: _transformX(widget._body.$2),
                  right: layoutWidth -
                      _transformX(widget._body.$3) -
                      _yAxisSpaceReserved,
                  child: SvgPicture.asset(
                    fit: BoxFit.fill,
                    widget._body.$1,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                // Center lines
                Positioned.fill(
                  child: ShipSchemeGrid(
                    color: widget._axisColor ?? theme.colorScheme.primary,
                    axisGrid: const [0.0],
                    transformValue: _transformX,
                  ),
                ),
                // Center lines
                Positioned.fill(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: ShipSchemeGrid(
                      color: widget._axisColor ?? theme.colorScheme.primary,
                      axisGrid: const [0.0],
                      transformValue: _transformY,
                    ),
                  ),
                ),
                // Frames-Real
                if (widget._framesRealAxis.isLabelsVisible)
                  Positioned(
                    top: _transformY(0.0).clamp(
                      0.0,
                      layoutHeight -
                          _xAxisSpaceReserved -
                          widget._framesRealAxis.labelsSpaceReserved,
                    ),
                    left: 0.0,
                    right: 0.0,
                    child: ClipRect(
                      child: ShipSchemeAxis(
                        axis: widget._framesRealAxis,
                        transformValue: _transformX,
                        majorTicks: widget._framesReal.where((frame) {
                          final (_, idx) = frame;
                          return idx % widget._framesRealAxis.valueInterval ==
                              0;
                        }).map((frame) {
                          final (offset, idx) = frame;
                          return (
                            offset,
                            '$idx${widget._framesRealAxis.caption}'
                          );
                        }).toList(),
                        minorTicks: widget._framesReal.where((frame) {
                          final (_, idx) = frame;
                          return idx % widget._framesRealAxis.valueInterval !=
                              0;
                        }).map((frame) {
                          final (offset, _) = frame;
                          return offset;
                        }).toList(),
                        color: widget._axisColor ?? theme.colorScheme.primary,
                        labelStyle: theme.textTheme.labelSmall?.copyWith(
                          color: widget._axisColor ?? theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Area of interactive shift & scale
          Positioned(
            top: 0.0,
            right: 0.0,
            left: _yAxisSpaceReserved,
            bottom: _xAxisSpaceReserved,
            child: InteractiveViewer(
              transformationController: widget._transformationController,
              child: SizedBox(
                width: layoutWidth - _yAxisSpaceReserved,
                height: layoutHeight - _xAxisSpaceReserved,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  void _handleTransform() {
    setState(() {
      _trScaleX = _transformationController.value[0];
      _trScaleY = _transformationController.value[5];
      _trShiftX = _transformationController.value.getTranslation()[0];
      _trShiftY = _transformationController.value.getTranslation()[1];
    });
  }

  ///
  double _transformX(double value) {
    final scale = _trScaleX * widget._scaleX;
    final shift = _trShiftX / scale;
    final actualShift =
        widget._invertHorizontal ? -shift - _maxX : shift - _minX;
    return widget._invertHorizontal
        ? -(value + actualShift) * scale
        : (value + actualShift) * scale;
  }

  ///
  double _transformY(double value) {
    final scale = _trScaleY * widget._scaleY;
    final shift = _trShiftY / scale;
    final actualShift = widget._invertVertical ? -shift - _maxY : shift - _minY;
    return widget._invertVertical
        ? -(value + actualShift) * scale
        : (value + actualShift) * scale;
  }

  /// Returns multiples of [divisor] less than or equal to [max]
  List<double> _getMultiples(double divisor, double max) {
    return List<double>.generate(
      max ~/ divisor + 1,
      (idx) => (idx * divisor),
    );
  }

  ///
  List<(double, String)> _getMajorTicks(
    double minValue,
    double maxValue,
    ChartAxis axis,
  ) {
    final offset = minValue.abs() % axis.valueInterval;
    return _getMultiples(axis.valueInterval, (maxValue - minValue))
        .map((multiple) => (
              minValue + offset + multiple,
              '${(minValue + multiple + offset).toInt()}${axis.caption}',
            ))
        .toList();
  }

  ///
  List<double> _getMinorTicks(
    double minValue,
    double maxValue,
    ChartAxis axis,
  ) {
    final offset = minValue.abs() % (axis.valueInterval / 5.0);
    return _getMultiples(axis.valueInterval / 5.0, (maxValue - minValue))
        .map((multiple) => minValue + offset + multiple)
        .toList();
  }
}
