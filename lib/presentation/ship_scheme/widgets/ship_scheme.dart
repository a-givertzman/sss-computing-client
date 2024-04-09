import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/chart_axis.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/figure.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_figures.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_frames_theoretic.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_grid.dart';
import 'package:sss_computing_client/widgets/core/fitted_builder_widget.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class ShipScheme extends StatefulWidget {
  final (FigureAxis, FigureAxis) _projection;
  final Figure _shipBody;
  final List<Figure> _figures;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final ChartAxis _framesTheoreticAxis;
  final ChartAxis _framesRealAxis;
  final List<(double, double, int)> _framesTheoretic;
  final List<(double, int)> _framesReal;
  final TransformationController? _transformationController;
  final bool _invertHorizontal;
  final bool _invertVertical;
  final bool _isViewInteractive;
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  final String? _caption;
  final Color? _axisColor;

  ///
  const ShipScheme({
    super.key,
    required (FigureAxis, FigureAxis) projection,
    required Figure shipBody,
    required List<Figure> figures,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required ChartAxis framesTheoreticAxis,
    required ChartAxis framesRealAxis,
    required List<(double, double, int)> framesTheoretic,
    required List<(double, int)> framesReal,
    TransformationController? transformationController,
    bool invertHorizontal = false,
    bool invertVertical = false,
    bool isViewInteractive = false,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    String? caption,
    Color? axisColor,
  })  : _projection = projection,
        _shipBody = shipBody,
        _figures = figures,
        _invertVertical = invertVertical,
        _invertHorizontal = invertHorizontal,
        _isViewInteractive = isViewInteractive,
        _framesTheoreticAxis = framesTheoreticAxis,
        _framesRealAxis = framesRealAxis,
        _axisColor = axisColor,
        _yAxis = yAxis,
        _framesTheoretic = framesTheoretic,
        _framesReal = framesReal,
        _transformationController = transformationController,
        _maxX = maxX,
        _minX = minX,
        _maxY = maxY,
        _minY = minY,
        _caption = caption,
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
  late final TransformationController _transformationController;
  late final List<Figure> _selectedFigures;
  double _transformtaionShiftX = 0.0;
  double _transformtaionShiftY = 0.0;
  double _transformtaionScaleX = 1.0;
  double _transformtaionScaleY = 1.0;

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
    _xMajorTicks = _getMajorTicks(_minX, _maxX, widget._xAxis);
    _xMinorTicks = _getMinorTicks(_minX, _maxX, widget._xAxis);
    _yMajorTicks = _getMajorTicks(_minY, _maxY, widget._yAxis);
    _yMinorTicks = _getMinorTicks(_minY, _maxY, widget._yAxis);
    _xAxisGrid = _xMajorTicks.map((tick) => tick.$1).toList();
    _yAxisGrid = _yMajorTicks.map((tick) => tick.$1).toList();
    _selectedFigures = [];
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
    final padding = const Setting('padding').toDouble;
    final bottomContentPadding =
        widget._xAxis.isLabelsVisible ? widget._xAxis.labelsSpaceReserved : 0.0;
    final leftContentPadding =
        widget._yAxis.isLabelsVisible ? widget._yAxis.labelsSpaceReserved : 0.0;
    return FittedBuilderWidget(
      size: Size(_contentWidth, _contentHeight),
      offset: Offset(
        widget._yAxis.labelsSpaceReserved,
        widget._xAxis.labelsSpaceReserved,
      ),
      fit: BoxFit.contain,
      builder: (context, scaleX, scaleY) {
        final layoutWidth =
            _contentWidth * scaleX + widget._yAxis.labelsSpaceReserved;
        final layoutHeight =
            _contentHeight * scaleY + widget._xAxis.labelsSpaceReserved;
        final transform = _getTransform(scaleX, scaleY);
        final xTransform = _getXTransform(transform);
        final yTransform = _getYTransform(transform);
        return SizedBox(
          width: layoutWidth,
          height: layoutHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Border
              Positioned(
                left: leftContentPadding,
                bottom: bottomContentPadding,
                top: 0.0,
                right: 0.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: widget._axisColor?.withOpacity(0.25) ??
                            theme.colorScheme.primary.withOpacity(0.25),
                      ),
                    ),
                  ),
                ),
              ),
              // Y-Axis
              if (widget._yAxis.isLabelsVisible)
                Positioned(
                  top: 0.0,
                  bottom: bottomContentPadding,
                  left: 0.0,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: ShipSchemeAxis(
                      axis: widget._yAxis,
                      transformValue: yTransform,
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
                  bottom: bottomContentPadding,
                  left: leftContentPadding,
                  right: 0.0,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: ShipSchemeGrid(
                      transformValue: yTransform,
                      color: widget._axisColor?.withOpacity(0.25) ??
                          theme.colorScheme.primary.withOpacity(0.25),
                      axisGrid: _yAxisGrid,
                    ),
                  ),
                ),
              // X-Axis
              if (widget._xAxis.isLabelsVisible) ...[
                Positioned(
                  bottom: 0.0,
                  left: leftContentPadding,
                  right: 0.0,
                  child: ShipSchemeAxis(
                    axis: widget._xAxis,
                    transformValue: xTransform,
                    color: widget._axisColor ?? theme.colorScheme.primary,
                    labelStyle: theme.textTheme.labelSmall?.copyWith(
                      color: widget._axisColor ?? theme.colorScheme.primary,
                    ),
                    majorTicks: _xMajorTicks,
                    minorTicks: _xMinorTicks,
                  ),
                ),
              ],
              // X-Axis Grid
              if (widget._xAxis.isGridVisible) ...[
                Positioned(
                  top: 0.0,
                  bottom: bottomContentPadding,
                  left: leftContentPadding,
                  right: 0.0,
                  child: ShipSchemeGrid(
                    transformValue: xTransform,
                    color: widget._axisColor?.withOpacity(0.25) ??
                        theme.colorScheme.primary.withOpacity(0.25),
                    axisGrid: _xAxisGrid,
                  ),
                ),
              ],
              // Layout content
              Positioned(
                top: 0.0,
                bottom: bottomContentPadding,
                left: leftContentPadding,
                right: 0.0,
                child: ClipRect(
                  child: Stack(
                    children: [
                      // Ship body-lines
                      Positioned.fill(
                        child: ShipSchemeFigures(
                          projection: widget._projection,
                          transform: _getTransform(scaleX, scaleY),
                          figures: [widget._shipBody],
                          thickness: 1.5,
                        ),
                      ),
                      // Figures body-lines
                      Positioned.fill(
                        child: ShipSchemeFigures(
                          projection: widget._projection,
                          transform: _getTransform(scaleX, scaleY),
                          figures: _getSortedFigures(),
                          thickness: 2.0,
                          onTap: (figure) => setState(() {
                            _selectedFigures.add(figure.copyWith(
                              borderColor: Colors.amber,
                            ));
                          }),
                        ),
                      ),
                      // Selected figures body-lines
                      Positioned.fill(
                        child: ShipSchemeFigures(
                          projection: widget._projection,
                          transform: _getTransform(scaleX, scaleY),
                          figures: _selectedFigures,
                          thickness: 2.0,
                          onTap: (figure) => setState(() {
                            _selectedFigures.remove(figure);
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Frames-Theoretic
              if (widget._framesTheoreticAxis.isLabelsVisible)
                Positioned(
                  left: leftContentPadding,
                  right: 0.0,
                  top: layoutHeight -
                      bottomContentPadding -
                      widget._framesTheoreticAxis.labelsSpaceReserved,
                  child: ClipRect(
                    child: ShipSchemeFramesTheoretic(
                      axis: widget._framesTheoreticAxis,
                      frames: widget._framesTheoretic,
                      transformValue: xTransform,
                      color: widget._axisColor ?? theme.colorScheme.primary,
                      labelStyle: theme.textTheme.labelSmall?.copyWith(
                        color: widget._axisColor ?? theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              // Frames-Real
              if (widget._framesRealAxis.isLabelsVisible)
                Positioned(
                  top: yTransform(0.0).clamp(
                        0.0,
                        layoutHeight -
                            bottomContentPadding -
                            (widget._framesTheoreticAxis.isLabelsVisible
                                ? widget
                                    ._framesTheoreticAxis.labelsSpaceReserved
                                : 0.0) -
                            widget._framesRealAxis.labelsSpaceReserved,
                      ) -
                      1.0,
                  left: leftContentPadding,
                  right: 0.0,
                  child: ClipRect(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: ShipSchemeAxis(
                        axis: widget._framesRealAxis,
                        transformValue: xTransform,
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
                ),
              // Caption
              if (widget._caption != null)
                Positioned(
                  top: padding,
                  right: padding,
                  child: _ShipSchemeCaption(
                    text: widget._caption!,
                  ),
                ),
              // Area of interactive shift & scale
              if (widget._isViewInteractive)
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  left: leftContentPadding,
                  bottom: bottomContentPadding,
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    child: SizedBox(
                      width: layoutWidth - leftContentPadding,
                      height: layoutHeight - bottomContentPadding,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  ///
  void _handleTransform() {
    setState(() {
      _transformtaionScaleX = _transformationController.value[0];
      _transformtaionScaleY = _transformationController.value[5];
      _transformtaionShiftX =
          _transformationController.value.getTranslation()[0];
      _transformtaionShiftY =
          _transformationController.value.getTranslation()[1];
    });
  }

  ///
  double Function(double) _getXTransform(Matrix4 transform) {
    return (value) => _transformX(value, transform);
  }

  ///
  double Function(double) _getYTransform(Matrix4 transform) {
    return (value) => _transformY(value, transform);
  }

  /// get x raw offset from left
  double _transformX(double value, Matrix4 transform) {
    return transform.transform3(Vector3(value, 0.0, 0.0)).x;
  }

  /// get y raw offset from top
  double _transformY(double value, Matrix4 transform) {
    return transform.transform3(Vector3(0.0, value, 0.0)).y;
  }

  /// get transform matrix
  Matrix4 _getTransform(double scaleX, double scaleY) {
    final actualScaleX = widget._invertHorizontal
        ? -_transformtaionScaleX * scaleX
        : _transformtaionScaleX * scaleX;
    final actualScaleY = widget._invertVertical
        ? -_transformtaionScaleY * scaleY
        : _transformtaionScaleY * scaleY;
    final extraShiftX = (widget._yAxis.isLabelsVisible
        ? 0.0
        : widget._yAxis.labelsSpaceReserved / 2.0);
    final extraShiftY = (widget._xAxis.isLabelsVisible
        ? 0.0
        : widget._xAxis.labelsSpaceReserved / 2.0);
    final actualShiftX = widget._invertHorizontal
        ? _transformtaionShiftX - _maxX * actualScaleX + extraShiftX
        : _transformtaionShiftX - _minX * actualScaleX + extraShiftX;
    final actualShiftY = widget._invertVertical
        ? _transformtaionShiftY - _maxY * actualScaleY + extraShiftY
        : _transformtaionShiftY - _minY * actualScaleY + extraShiftY;
    return Matrix4(
      actualScaleX, 0.0, 0.0, 0.0, //
      0.0, actualScaleY, 0.0, 0.0, //
      0.0, 0.0, 1.0, 0.0, //
      actualShiftX, actualShiftY, 0.0, 1.0, //
    );
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

  /// For te
  List<Figure> _getSortedFigures() {
    // final comparitionProjection = (
    //   widget._projection.$1,
    //   ([...FigureAxis.values]
    //         ..remove(widget._projection.$1)
    //         ..remove(widget._projection.$2))
    //       .first
    // );
    // var figuresCopy = [...widget._figures];
    // figuresCopy.sort((one, other) {
    //   return (one
    //               .getOrthoProjection(
    //                 comparitionProjection.$1,
    //                 comparitionProjection.$2,
    //               )
    //               .getBounds()
    //               .bottom -
    //           other
    //               .getOrthoProjection(
    //                 comparitionProjection.$1,
    //                 comparitionProjection.$2,
    //               )
    //               .getBounds()
    //               .bottom)
    //       .toInt();
    // });
    // return figuresCopy;
    return widget._figures;
  }
}

///
class _ShipSchemeCaption extends StatelessWidget {
  final String _text;
  final Color? _color;
  final Color? _backgroundColor;

  ///
  const _ShipSchemeCaption({
    required String text,
    Color? color,
    Color? backgroundColor,
  })  : _text = text,
        _color = color,
        _backgroundColor = backgroundColor;

  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelSmall?.copyWith(
      color: _color ?? theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      height: 1.0,
    );
    return Chip(
      label: Text(_text),
      labelStyle: textStyle,
      backgroundColor:
          _backgroundColor ?? theme.colorScheme.primary.withOpacity(0.15),
      padding: EdgeInsets.zero,
      side: BorderSide.none,
    );
  }
}
