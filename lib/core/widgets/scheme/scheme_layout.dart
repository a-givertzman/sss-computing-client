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
class SchemeLayout extends StatelessWidget {
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
  /// Displays the scheme layout. Includes axes, grid, caption
  /// and scheme content if `buildContent` passed.
  /// Fit scheme in available space based on passed `fit` parameter.
  /// Transformations for content passed as `transform` parameter to
  /// `buildContent` callback.
  ///
  /// `minX`, `maxX`, `minY`, `maxY` define border values for scheme axes.
  /// `xAxis` and `yAxis` contain data about scheme axes and define
  ///  value interval, reserved size from layout border, and options for
  /// labels, captions and grid.
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
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentWidth = _maxX - _minX;
    final contentHeight = _maxY - _minY;
    final axisColor = _axisColor ?? theme.colorScheme.primary;
    final gridColor = axisColor.withOpacity(0.5);
    final labelStyle = _labelStyle ?? theme.textTheme.labelSmall;
    final padding = const Setting('padding').toDouble;
    return FittedBuilderWidget(
      size: Size(contentWidth, contentHeight),
      fit: _fit,
      builder: (context, scaleX, scaleY) {
        final xAxisSpace =
            _xAxis.isLabelsVisible ? _xAxis.labelsSpaceReserved : 0.0;
        final yAxisSpace =
            _yAxis.isLabelsVisible ? _yAxis.labelsSpaceReserved : 0.0;
        final contentScaleX = scaleX - (yAxisSpace / contentWidth);
        final contentScaleY = scaleY - (xAxisSpace / contentHeight);
        final transform = SchemeLayoutTransform(
          minX: _minX,
          maxX: _maxX,
          minY: _minY,
          maxY: _maxY,
          scaleX: contentScaleX * _scaleX,
          scaleY: contentScaleY * _scaleY,
          shiftX: _shiftX,
          shiftY: _shiftY,
          xReversed: _xAxisReversed,
          yReversed: _yAxisReversed,
        ).transformationMatrix();
        return SizedBox(
          width: contentWidth * contentScaleX + yAxisSpace,
          height: contentHeight * contentScaleY + xAxisSpace,
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
              if (_xAxis.isGridVisible)
                Positioned(
                  left: yAxisSpace,
                  right: 0.0,
                  top: 0.0,
                  bottom: xAxisSpace,
                  child: SchemeGridReal(
                    axis: _xAxis,
                    minValue: _minX,
                    maxValue: _maxX,
                    transformValue: (v) =>
                        transform.transform3(Vector3(v, 0.0, 0.0)).x,
                    color: gridColor,
                    thickness: 0.5,
                  ),
                ),
              if (_yAxis.isGridVisible)
                Positioned(
                  left: yAxisSpace,
                  right: 0.0,
                  top: 0.0,
                  bottom: xAxisSpace,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: SchemeGridReal(
                      axis: _yAxis,
                      minValue: _minY,
                      maxValue: _maxY,
                      transformValue: (v) =>
                          transform.transform3(Vector3(0.0, v, 0.0)).y,
                      color: gridColor,
                      thickness: 0.5,
                    ),
                  ),
                ),
              if (_xAxis.isLabelsVisible)
                Positioned(
                  bottom: 0.0,
                  left: yAxisSpace,
                  right: 0.0,
                  child: SchemeAxisReal(
                    axis: _xAxis,
                    minValue: _minX,
                    maxValue: _maxX,
                    transformValue: (v) =>
                        transform.transform3(Vector3(v, 0.0, 0.0)).x,
                    color: axisColor,
                    labelStyle: labelStyle,
                  ),
                ),
              if (_yAxis.isLabelsVisible)
                Positioned(
                  left: 0.0,
                  top: 0.0,
                  bottom: xAxisSpace,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: SchemeAxisReal(
                      axis: _yAxis,
                      minValue: _minY,
                      maxValue: _maxY,
                      transformValue: (v) =>
                          transform.transform3(Vector3(0.0, v, 0.0)).y,
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
                child: ClipRect(
                  child: _buildContent(context, transform),
                ),
              ),
              if (_caption != null)
                Positioned(
                  bottom: xAxisSpace,
                  right: 0.0,
                  child: SchemeText(
                    text: _caption,
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
