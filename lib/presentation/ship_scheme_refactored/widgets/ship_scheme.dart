import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/chart_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/ship_scheme_axis.dart';

class ShipScheme extends StatefulWidget {
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  // final List<(double, double, String)> _framesTheoretic;
  // final List<(double, String)> _framesReal;
  // final (String, double, double) _body;
  final TransformationController? _transformationController;
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  // final String? _caption;
  final Color? _axisColor;
  final bool _keepRatio;

  ///
  const ShipScheme({
    super.key,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required (String, double, double) body,
    required List<(double, double, String)> framesTheoretic,
    required List<(double, String)> framesReal,
    TransformationController? transformationController,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    String? caption,
    Color? axisColor,
    bool keepRatio = true,
  })  : _axisColor = axisColor,
        _keepRatio = keepRatio,
        // _caption = caption,
        // _body = body,
        _yAxis = yAxis,
        // _framesTheoretic = framesTheoretic,
        // _framesReal = framesReal,
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
  late final double _minY;
  late final double _maxY;
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
  void _handleTransform() {
    setState(() {
      _trScaleX = _transformationController.value[0];
      _trScaleY = _transformationController.value[5];
      _trShiftX = _transformationController.value.getTranslation()[0];
      _trShiftY = _transformationController.value.getTranslation()[1];
    });
  }

  ///
  @override
  void initState() {
    _transformationController =
        widget._transformationController ?? TransformationController();
    _transformationController.addListener(_handleTransform);
    _minX = (widget._minX ?? 0.0) - widget._xAxis.valueInterval / 2.0;
    _maxX = (widget._maxX ?? 0.0) + widget._xAxis.valueInterval / 2.0;
    _minY = (widget._minY ?? 0.0) - widget._yAxis.valueInterval / 2.0;
    _maxY = (widget._maxY ?? 0.0) + widget._yAxis.valueInterval / 2.0;
    _contentWidth = _maxX - _minX;
    _contentHeight = _maxY - _minY;
    _xAxisSpaceReserved =
        widget._xAxis.isLabelsVisible ? widget._xAxis.labelsSpaceReserved : 0.0;
    _yAxisSpaceReserved =
        widget._yAxis.isLabelsVisible ? widget._yAxis.labelsSpaceReserved : 0.0;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final BoxConstraints(
          maxWidth: rawWidth,
          maxHeight: rawHeight,
        ) = constraints;
        var (scaleX, scaleY) = (
          (rawWidth - _yAxisSpaceReserved) / _contentWidth,
          (rawHeight - _xAxisSpaceReserved) / _contentHeight,
        );
        if (widget._keepRatio) {
          final scale = min(scaleX, scaleY);
          scaleX = scale;
          scaleY = scale;
        }
        final (layoutRawWidth, layoutRawHeight) = (
          _contentWidth * scaleX + _yAxisSpaceReserved,
          _contentHeight * scaleY + _xAxisSpaceReserved,
        );
        return SizedBox(
          width: layoutRawWidth,
          height: layoutRawHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0.0,
                bottom: widget._xAxis.labelsSpaceReserved,
                left: 0.0,
                right: 0.0,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: ShipSchemeAxis(
                    axis: widget._yAxis,
                    reversed: true,
                    minValue: _minY,
                    maxValue: _maxY,
                    valueShift: _trShiftY / (scaleY * _trScaleY) - _minY,
                    valueScale: scaleY * _trScaleY,
                    color: widget._axisColor ?? theme.colorScheme.primary,
                    labelStyle: theme.textTheme.labelSmall?.copyWith(
                      color: widget._axisColor ?? theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0.0,
                bottom: 0.0,
                left: widget._yAxis.labelsSpaceReserved,
                right: 0.0,
                child: ShipSchemeAxis(
                  axis: widget._xAxis,
                  minValue: _minX,
                  maxValue: _maxX,
                  valueShift: _trShiftX / (scaleX * _trScaleX) - _minX,
                  valueScale: scaleX * _trScaleX,
                  color: widget._axisColor ?? theme.colorScheme.primary,
                  labelStyle: theme.textTheme.labelSmall?.copyWith(
                    color: widget._axisColor ?? theme.colorScheme.primary,
                  ),
                ),
              ),
              Positioned(
                child: InteractiveViewer(
                  transformationController: widget._transformationController,
                  child: SizedBox(
                    width: layoutRawWidth,
                    height: layoutRawHeight,
                    child: Container(
                        // color: Colors.amber.withOpacity(0.1),
                        ),
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
