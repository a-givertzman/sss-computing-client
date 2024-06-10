import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/models/scheme/scheme_transform.dart';
import 'package:sss_computing_client/core/widgets/fitted_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_axis_real.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_grid_real.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_text.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
class SchemeLayout extends StatefulWidget {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final double _scaleX;
  final double _scaleY;
  final double _shiftX;
  final double _shiftY;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final bool _xAxisReversed;
  final bool _yAxisReversed;
  final Color? _axisColor;
  final TextStyle? _labelStyle;
  final String? _caption;
  final BoxFit _fit;
  final Widget Function(BuildContext, Matrix4) _buildContent;
  ///
  /// Displays the scheme layout. Includes axes, grid,
  /// and scheme content if `buildContent` passed.
  /// Fit scheme in available space based on passed `fit` parameter.
  /// Transformations for content passed as parameters to
  /// `buildContent` callback.
  const SchemeLayout({
    super.key,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double shiftX = 0.0,
    double shiftY = 0.0,
    ChartAxis xAxis = const ChartAxis(),
    ChartAxis yAxis = const ChartAxis(),
    bool xAxisReversed = false,
    bool yAxisReversed = false,
    Color? axisColor,
    TextStyle? labelStyle,
    String? caption,
    BoxFit fit = BoxFit.contain,
    required Widget Function(
      BuildContext context,
      Matrix4 transform,
    ) buildContent,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _scaleX = scaleX,
        _scaleY = scaleY,
        _shiftX = shiftX,
        _shiftY = shiftY,
        _xAxis = xAxis,
        _yAxis = yAxis,
        _xAxisReversed = xAxisReversed,
        _yAxisReversed = yAxisReversed,
        _axisColor = axisColor,
        _labelStyle = labelStyle,
        _caption = caption,
        _fit = fit,
        _buildContent = buildContent;
  //
  @override
  State<SchemeLayout> createState() => _SchemeLayoutState();
}
class _SchemeLayoutState extends State<SchemeLayout> {
  late final double _contentWidth;
  late final double _contentHeight;
  late final TransformationController _controller;
  double _viewerScaleX = 1.0;
  double _viewerScaleY = 1.0;
  double _viewerShiftX = 0.0;
  double _viewerShiftY = 0.0;
  //
  @override
  void initState() {
    _controller = TransformationController()..addListener(_handleTransform);
    _contentWidth = widget._maxX - widget._minX;
    _contentHeight = widget._maxY - widget._minY;
    super.initState();
  }
  //
  @override
  void dispose() {
    _controller
      ..removeListener(_handleTransform)
      ..dispose();
    super.dispose();
  }
  ///
  void _handleTransform() {
    setState(() {
      _viewerScaleX = _controller.value[0];
      _viewerScaleY = _controller.value[5];
      _viewerShiftX = _controller.value.getTranslation()[0];
      _viewerShiftY = _controller.value.getTranslation()[1];
    });
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final axisColor = widget._axisColor ?? theme.colorScheme.primary;
    final gridColor = axisColor.withOpacity(0.5);
    final labelStyle = widget._labelStyle ?? theme.textTheme.labelSmall;
    final padding = const Setting('padding').toDouble;
    return FittedBuilderWidget(
      size: Size(_contentWidth, _contentHeight),
      fit: widget._fit,
      builder: (context, scaleX, scaleY) {
        final xAxisSpace = widget._xAxis.isLabelsVisible
            ? widget._xAxis.labelsSpaceReserved
            : 0.0;
        final yAxisSpace = widget._yAxis.isLabelsVisible
            ? widget._yAxis.labelsSpaceReserved
            : 0.0;
        final contentScaleX = scaleX - (yAxisSpace / _contentWidth);
        final contentScaleY = scaleY - (xAxisSpace / _contentHeight);
        final transform = SchemeLayoutTransform(
          minX: widget._minX,
          maxX: widget._maxX,
          minY: widget._minY,
          maxY: widget._maxY,
          scaleX: contentScaleX * widget._scaleX * _viewerScaleX,
          scaleY: contentScaleY * widget._scaleY * _viewerScaleY,
          shiftX: widget._shiftX + _viewerShiftX,
          shiftY: widget._shiftY + _viewerShiftY,
          xReversed: widget._xAxisReversed,
          yReversed: widget._yAxisReversed,
        ).transformationMatrix();
        return SizedBox(
          width: _contentWidth * contentScaleX + yAxisSpace,
          height: _contentHeight * contentScaleY + xAxisSpace,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: yAxisSpace,
                right: 0.0,
                top: 0.0,
                bottom: xAxisSpace,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: axisColor),
                  ),
                ),
              ),
              if (widget._xAxis.isGridVisible)
                Positioned(
                  left: yAxisSpace,
                  right: 0.0,
                  top: 0.0,
                  bottom: xAxisSpace,
                  child: SchemeGridReal(
                    axis: widget._xAxis,
                    minValue: widget._minX,
                    maxValue: widget._maxX,
                    transformValue: (v) =>
                        transform.transform3(Vector3(v, 0.0, 0.0)).x *
                            _viewerScaleX +
                        _viewerShiftX,
                    color: gridColor,
                    thickness: 0.5,
                  ),
                ),
              if (widget._yAxis.isGridVisible)
                Positioned(
                  left: yAxisSpace,
                  right: 0.0,
                  top: 0.0,
                  bottom: xAxisSpace,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: SchemeGridReal(
                      axis: widget._yAxis,
                      minValue: widget._minY,
                      maxValue: widget._maxY,
                      transformValue: (v) =>
                          transform.transform3(Vector3(0.0, v, 0.0)).y *
                              _viewerScaleY +
                          _viewerShiftY,
                      color: gridColor,
                      thickness: 0.5,
                    ),
                  ),
                ),
              if (widget._xAxis.isLabelsVisible)
                Positioned(
                  bottom: 0.0,
                  left: yAxisSpace,
                  right: 0.0,
                  child: SchemeAxisReal(
                    axis: widget._xAxis,
                    minValue: widget._minX,
                    maxValue: widget._maxX,
                    transformValue: (v) =>
                        transform.transform3(Vector3(v, 0.0, 0.0)).x *
                            _viewerScaleX +
                        _viewerShiftX,
                    color: axisColor,
                    labelStyle: labelStyle,
                  ),
                ),
              if (widget._yAxis.isLabelsVisible)
                Positioned(
                  left: 0.0,
                  top: 0.0,
                  bottom: xAxisSpace,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: SchemeAxisReal(
                      axis: widget._yAxis,
                      minValue: widget._minY,
                      maxValue: widget._maxY,
                      transformValue: (v) =>
                          transform.transform3(Vector3(0.0, v, 0.0)).y *
                              _viewerScaleY +
                          _viewerScaleY,
                      color: axisColor,
                      labelStyle: labelStyle,
                    ),
                  ),
                ),
              Positioned(
                left: yAxisSpace,
                right: 0.0,
                top: 0.0,
                bottom: xAxisSpace,
                child: InteractiveViewer(
                  transformationController: _controller,
                  child: ClipRect(
                    child: widget._buildContent(context, transform),
                  ),
                ),
              ),
              if (widget._caption != null)
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: SchemeText(
                    text: widget._caption!,
                    alignment: Alignment.topLeft,
                    offset: Offset(-padding, -padding),
                    layoutTransform: Matrix4.identity(),
                    style: TextStyle(
                      background: Paint()..color = axisColor.withOpacity(0.5),
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
