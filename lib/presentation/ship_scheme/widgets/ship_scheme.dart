import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/ship_scheme/chart_axis.dart';
import 'package:sss_computing_client/core/models/ship_scheme/figure.dart';
import 'package:sss_computing_client/core/widgets/chart_legend.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_figure.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_frames_theoretic.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_grid.dart';
import 'package:sss_computing_client/core/widgets/fitted_builder_widget.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
class ShipScheme extends StatefulWidget {
  final (FigureAxes, FigureAxes) _projection;
  final Figure _shipBody;
  final Figure? _shipBodyPretty;
  final List<(Cargo, Figure)> _cargos;
  final List<(Cargo, Figure)> _selectedCargos;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final ChartAxis _framesTheoreticAxis;
  final ChartAxis _framesRealAxis;
  final List<(double, double, int)> _framesTheoretic;
  final List<(double, int)> _framesReal;
  final void Function(Cargo)? _onCargoTap;
  final bool _invertHorizontal;
  final bool _invertVertical;
  final bool _isViewScalable;
  final EdgeInsets _valuesPadding;
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  final String? _caption;
  final Color? _axisColor;
  final BoxFit _fit;
  ///
  const ShipScheme({
    super.key,
    required (FigureAxes, FigureAxes) projection,
    required Figure shipBody,
    Figure? shipBodyPretty,
    required List<(Cargo, Figure)> cargos,
    List<(Cargo, Figure)> selectedCargos = const [],
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required ChartAxis framesTheoreticAxis,
    required ChartAxis framesRealAxis,
    required List<(double, double, int)> framesTheoretic,
    required List<(double, int)> framesReal,
    void Function(Cargo cargo)? onCargoTap,
    bool invertHorizontal = false,
    bool invertVertical = false,
    bool isViewInteractive = false,
    EdgeInsets valuesPadding = const EdgeInsets.all(5.0),
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    String? caption,
    Color? axisColor,
    BoxFit fit = BoxFit.contain,
  })  : _projection = projection,
        _shipBody = shipBody,
        _shipBodyPretty = shipBodyPretty,
        _cargos = cargos,
        _selectedCargos = selectedCargos,
        _invertVertical = invertVertical,
        _invertHorizontal = invertHorizontal,
        _isViewScalable = isViewInteractive,
        _framesTheoreticAxis = framesTheoreticAxis,
        _framesRealAxis = framesRealAxis,
        _axisColor = axisColor,
        _yAxis = yAxis,
        _framesTheoretic = framesTheoretic,
        _framesReal = framesReal,
        _onCargoTap = onCargoTap,
        _valuesPadding = valuesPadding,
        _maxX = maxX,
        _minX = minX,
        _maxY = maxY,
        _minY = minY,
        _caption = caption,
        _xAxis = xAxis,
        _fit = fit;
  ///
  @override
  State<ShipScheme> createState() => _ShipSchemeState();
}
///
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
  late final List<(double, String)> _framesRealMajorTicks;
  late final List<double> _framesRealMinorTicks;
  late final double _contentWidth;
  late final double _contentHeight;
  late final TransformationController _transformationController;
  double _transformtaionShiftX = 0.0;
  double _transformtaionShiftY = 0.0;
  double _transformtaionScaleX = 1.0;
  double _transformtaionScaleY = 1.0;
  ///
  @override
  void initState() {
    _transformationController = TransformationController()
      ..addListener(_handleTransform);
    final valueBounds = (widget._shipBodyPretty ?? widget._shipBody)
        .getOrthoProjection(widget._projection.$1, widget._projection.$2)
        .getBounds();
    _minX = widget._minX ?? valueBounds.left - widget._valuesPadding.left;
    _maxX = widget._maxX ?? valueBounds.right + widget._valuesPadding.right;
    _minY = widget._minY ?? valueBounds.top - widget._valuesPadding.bottom;
    _maxY = widget._maxY ?? valueBounds.bottom + widget._valuesPadding.top;
    _contentWidth = _maxX - _minX;
    _contentHeight = _maxY - _minY;
    _xMajorTicks = _getMajorTicks(_minX, _maxX, widget._xAxis);
    _xMinorTicks = _getMinorTicks(_minX, _maxX, widget._xAxis);
    _yMajorTicks = _getMajorTicks(_minY, _maxY, widget._yAxis);
    _yMinorTicks = _getMinorTicks(_minY, _maxY, widget._yAxis);
    _framesRealMajorTicks = widget._framesReal.where((frame) {
      final (_, idx) = frame;
      return idx % widget._framesRealAxis.valueInterval == 0;
    }).map((frame) {
      final (offset, idx) = frame;
      return (offset, '$idx${widget._framesRealAxis.caption}');
    }).toList();
    _framesRealMinorTicks = widget._framesReal.where((frame) {
      final (_, idx) = frame;
      return idx % widget._framesRealAxis.valueInterval != 0;
    }).map((frame) {
      final (offset, _) = frame;
      return offset;
    }).toList();
    _xAxisGrid = _xMajorTicks.map((tick) => tick.$1).toList();
    _yAxisGrid = _yMajorTicks.map((tick) => tick.$1).toList();
    super.initState();
  }
  ///
  @override
  void dispose() {
    _transformationController
      ..removeListener(_handleTransform)
      ..dispose();
    super.dispose();
  }
  ///
  @override
  Widget build(BuildContext context) {
    return FittedBuilderWidget(
      size: Size(_contentWidth, _contentHeight),
      offset: Offset(
        widget._yAxis.labelsSpaceReserved,
        widget._xAxis.labelsSpaceReserved,
      ),
      fit: widget._fit,
      builder: (context, scaleX, scaleY) {
        final layoutSize = Size(
          _contentWidth * scaleX + widget._yAxis.labelsSpaceReserved,
          _contentHeight * scaleY + widget._xAxis.labelsSpaceReserved,
        );
        final contentPadding = EdgeInsets.fromLTRB(
          widget._yAxis.isLabelsVisible
              ? widget._yAxis.labelsSpaceReserved
              : 0.0,
          0.0,
          0.0,
          widget._xAxis.isLabelsVisible
              ? widget._xAxis.labelsSpaceReserved
              : 0.0,
        );
        final transform = _getTransform(scaleX, scaleY);
        final (xTransform, yTransform) = (
          _getXTransform(transform),
          _getYTransform(transform),
        );
        final theme = Theme.of(context);
        final padding = const Setting('padding').toDouble;
        final axisColor = widget._axisColor ?? theme.colorScheme.primary;
        final gridColor = axisColor.withOpacity(0.15);
        final labelStyle = theme.textTheme.labelSmall;
        return SizedBox(
          width: layoutSize.width,
          height: layoutSize.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildLayoutBorderWidget(gridColor, contentPadding),
              if (widget._yAxis.isLabelsVisible)
                _buildYAxisWidget(
                  axisColor,
                  labelStyle,
                  (xTransform, yTransform),
                  contentPadding,
                ),
              if (widget._yAxis.isGridVisible)
                ..._buildYAxisGridWidgets(
                  axisColor,
                  gridColor,
                  (xTransform, yTransform),
                  contentPadding,
                ),
              if (widget._xAxis.isLabelsVisible)
                _buildXAxisWidget(
                  axisColor,
                  labelStyle,
                  (xTransform, yTransform),
                  contentPadding,
                ),
              if (widget._xAxis.isGridVisible)
                ..._buildXAxisGridWidgets(
                  axisColor,
                  gridColor,
                  (xTransform, yTransform),
                  contentPadding,
                ),
              // Layout figures
              Positioned(
                top: contentPadding.top,
                bottom: contentPadding.bottom,
                left: contentPadding.left,
                right: contentPadding.right,
                child: ClipRect(
                  child: Stack(
                    children: [
                      if (widget._shipBodyPretty != null)
                        Positioned.fill(
                          child: ShipSchemeFigure(
                            projection: widget._projection,
                            transform: transform,
                            figure: widget._shipBodyPretty!,
                            thickness: 1.0,
                          ),
                        ),
                      // Ship body-lines
                      Positioned.fill(
                        child: ShipSchemeFigure(
                          projection: widget._projection,
                          transform: transform,
                          figure: widget._shipBody,
                          thickness: 1.5,
                        ),
                      ),
                      // Cargos
                      Positioned.fill(
                        child: _CargoFigures(
                          projection: widget._projection,
                          transform: transform,
                          cargoFigues: widget._cargos,
                          thickness: 2.0,
                          onTap: widget._onCargoTap,
                        ),
                      ),
                      // Selected cargos
                      Positioned.fill(
                        child: _CargoFigures(
                          projection: widget._projection,
                          transform: transform,
                          cargoFigues: widget._selectedCargos,
                          thickness: 2.0,
                          onTap: widget._onCargoTap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Frames-Theoretic
              if (widget._framesTheoreticAxis.isLabelsVisible)
                _buildTheoreticFramesWidget(
                  axisColor,
                  labelStyle,
                  layoutSize,
                  (xTransform, yTransform),
                  contentPadding,
                ),
              // Frames-Real
              if (widget._framesRealAxis.isLabelsVisible)
                _buildRealFramesWidget(
                  axisColor,
                  labelStyle,
                  layoutSize,
                  (xTransform, yTransform),
                  contentPadding,
                ),
              // Caption
              if (widget._caption != null)
                Positioned(
                  top: contentPadding.top + padding,
                  right: contentPadding.right + padding,
                  child: ChartLegend(
                    names: [widget._caption!],
                    colors: [axisColor],
                    height: 20.0,
                  ),
                ),
              // Area of interactive shift & scale
              if (widget._isViewScalable)
                Positioned(
                  top: contentPadding.top,
                  bottom: contentPadding.bottom,
                  left: contentPadding.left,
                  right: contentPadding.right,
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    child: SizedBox(
                      width: layoutSize.width - contentPadding.left,
                      height: layoutSize.height - contentPadding.bottom,
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
  Widget _buildLayoutBorderWidget(Color gridColor, EdgeInsets contentPadding) {
    return Positioned(
      top: contentPadding.top,
      bottom: contentPadding.bottom,
      left: contentPadding.left,
      right: contentPadding.right,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: gridColor)),
        ),
      ),
    );
  }
  ///
  Widget _buildYAxisWidget(
    Color axisColor,
    TextStyle? labelStyle,
    (double Function(double), double Function(double)) valuesTransform,
    EdgeInsets contentPadding,
  ) {
    final (_, transformY) = valuesTransform;
    return Positioned(
      top: contentPadding.top,
      bottom: contentPadding.bottom,
      left: 0.0,
      right: contentPadding.right,
      child: RotatedBox(
        quarterTurns: 1,
        child: ShipSchemeAxis(
          axis: widget._yAxis,
          transformValue: transformY,
          color: axisColor,
          labelStyle: labelStyle?.copyWith(color: axisColor),
          majorTicks: _yMajorTicks,
          minorTicks: _yMinorTicks,
        ),
      ),
    );
  }
  ///
  List<Widget> _buildYAxisGridWidgets(
    Color axisColor,
    Color gridColor,
    (double Function(double), double Function(double)) valuesTransform,
    EdgeInsets contentPadding,
  ) {
    final (_, transformY) = valuesTransform;
    return [
      Positioned(
        top: contentPadding.top,
        bottom: contentPadding.bottom,
        left: contentPadding.left,
        right: contentPadding.right,
        child: RotatedBox(
          quarterTurns: 1,
          child: ShipSchemeGrid(
            transformValue: transformY,
            color: gridColor,
            axisGrid: _yAxisGrid,
          ),
        ),
      ),
      Positioned(
        top: contentPadding.top,
        bottom: contentPadding.bottom,
        left: contentPadding.left,
        right: contentPadding.right,
        child: RotatedBox(
          quarterTurns: 1,
          child: ShipSchemeGrid(
            transformValue: transformY,
            color: axisColor.withOpacity(0.5),
            axisGrid: const [0.0],
          ),
        ),
      ),
    ];
  }
  ///
  Widget _buildXAxisWidget(
    Color axisColor,
    TextStyle? labelStyle,
    (double Function(double), double Function(double)) valuesTransform,
    EdgeInsets contentPadding,
  ) {
    final (transformX, _) = valuesTransform;
    return Positioned(
      top: contentPadding.top,
      bottom: 0.0,
      left: contentPadding.left,
      right: contentPadding.right,
      child: ShipSchemeAxis(
        axis: widget._xAxis,
        transformValue: transformX,
        color: axisColor,
        labelStyle: labelStyle?.copyWith(color: axisColor),
        majorTicks: _xMajorTicks,
        minorTicks: _xMinorTicks,
      ),
    );
  }
  List<Widget> _buildXAxisGridWidgets(
    Color axisColor,
    Color gridColor,
    (double Function(double), double Function(double)) valuesTransform,
    EdgeInsets contentPadding,
  ) {
    final (transformX, _) = valuesTransform;
    return [
      Positioned(
        top: contentPadding.top,
        bottom: contentPadding.bottom,
        left: contentPadding.left,
        right: contentPadding.right,
        child: ShipSchemeGrid(
          transformValue: transformX,
          color: gridColor,
          axisGrid: _xAxisGrid,
        ),
      ),
      Positioned(
        top: contentPadding.top,
        bottom: contentPadding.bottom,
        left: contentPadding.left,
        right: contentPadding.right,
        child: ShipSchemeGrid(
          transformValue: transformX,
          color: axisColor.withOpacity(0.5),
          axisGrid: const [0.0],
        ),
      ),
    ];
  }
  ///
  Widget _buildTheoreticFramesWidget(
    Color axisColor,
    TextStyle? labelStyle,
    Size layuotSize,
    (double Function(double), double Function(double)) valuesTransform,
    EdgeInsets contentPadding,
  ) {
    final (transformX, _) = valuesTransform;
    return Positioned(
      left: contentPadding.left,
      right: contentPadding.right,
      top: layuotSize.height -
          contentPadding.bottom -
          widget._framesTheoreticAxis.labelsSpaceReserved,
      child: ClipRect(
        child: IgnorePointer(
          child: ShipSchemeFramesTheoretic(
            axis: widget._framesTheoreticAxis,
            frames: widget._framesTheoretic,
            transformValue: transformX,
            color: axisColor,
            labelStyle: labelStyle?.copyWith(color: axisColor),
          ),
        ),
      ),
    );
  }
  ///
  Widget _buildRealFramesWidget(
    Color axisColor,
    TextStyle? labelStyle,
    Size layuotSize,
    (double Function(double), double Function(double)) valuesTransform,
    EdgeInsets contentPadding,
  ) {
    final (transformX, transformY) = valuesTransform;
    return Positioned(
      top: transformY(0.0).clamp(
            0.0,
            layuotSize.height -
                contentPadding.bottom -
                (widget._framesTheoreticAxis.isLabelsVisible
                    ? widget._framesTheoreticAxis.labelsSpaceReserved
                    : 0.0) -
                widget._framesRealAxis.labelsSpaceReserved,
          ) -
          1.0,
      left: contentPadding.left,
      right: contentPadding.right,
      child: ClipRect(
        child: IgnorePointer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: ShipSchemeAxis(
              axis: widget._framesRealAxis,
              transformValue: transformX,
              majorTicks: _framesRealMajorTicks,
              minorTicks: _framesRealMinorTicks,
              color: axisColor,
              labelStyle: labelStyle?.copyWith(color: axisColor),
            ),
          ),
        ),
      ),
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
}
///
class _CargoFigures extends StatelessWidget {
  final (FigureAxes, FigureAxes) _projection;
  final Matrix4 _transform;
  final List<(Cargo, Figure)> _cargoFigures;
  final double? _thickness;
  final void Function(Cargo)? _onTap;
  ///
  const _CargoFigures({
    required (FigureAxes, FigureAxes) projection,
    required Matrix4 transform,
    required List<(Cargo, Figure)> cargoFigues,
    double? thickness,
    void Function(Cargo cargo)? onTap,
  })  : _projection = projection,
        _transform = transform,
        _cargoFigures = cargoFigues,
        _thickness = thickness,
        _onTap = onTap;
  ///
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._cargoFigures.map(
          (cargoFigure) => Positioned.fill(
            child: ShipSchemeFigure(
              projection: _projection,
              transform: _transform,
              figure: cargoFigure.$2,
              thickness: _thickness,
              onTap: () => _onTap?.call(cargoFigure.$1),
            ),
          ),
        ),
      ],
    );
  }
}
