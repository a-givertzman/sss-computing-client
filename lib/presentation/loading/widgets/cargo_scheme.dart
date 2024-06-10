import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/frame/frame.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_axis.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figure.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_layout.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_text.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
class CargoScheme extends StatelessWidget {
  final String _caption;
  final FigurePlane _projectionPlane;
  final Figure _hull;
  final List<({Figure figure, Cargo cargo})> _cargoFigures;
  final ({Figure figure, Cargo cargo})? _selectedCargoFigure;
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final ChartAxis _xAxis;
  final ChartAxis _yAxis;
  final bool _xAxisReversed;
  final bool _yAxisReversed;
  final List<Frame>? _framesReal;
  final List<Frame>? _framesTheoretical;
  final void Function(Cargo cargo)? _onCargoTap;
  final Color _selectedCargoColor;
  ///
  const CargoScheme({
    super.key,
    required String caption,
    required FigurePlane projectionPlane,
    required Figure hull,
    required List<({Cargo cargo, Figure figure})> cargoFigures,
    required ({Cargo cargo, Figure figure})? selectedCargoFigure,
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    required ChartAxis xAxis,
    required ChartAxis yAxis,
    required bool xAxisReversed,
    required bool yAxisReversed,
    List<Frame>? framesReal,
    List<Frame>? framesTheoretical,
    Color selectedCargoColor = Colors.amber,
    void Function(Cargo)? onCargoTap,
  })  : _caption = caption,
        _projectionPlane = projectionPlane,
        _hull = hull,
        _cargoFigures = cargoFigures,
        _selectedCargoFigure = selectedCargoFigure,
        _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _xAxis = xAxis,
        _yAxis = yAxis,
        _xAxisReversed = xAxisReversed,
        _yAxisReversed = yAxisReversed,
        _framesReal = framesReal,
        _framesTheoretical = framesTheoretical,
        _onCargoTap = onCargoTap,
        _selectedCargoColor = selectedCargoColor;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final axisColor = theme.colorScheme.primary;
    final axisLabelStyle = theme.textTheme.labelSmall;
    final padding = const Setting('padding').toDouble;
    return SchemeLayout(
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      xAxis: _xAxis,
      yAxis: _yAxis,
      xAxisReversed: _xAxisReversed,
      yAxisReversed: _yAxisReversed,
      buildContent: (context, transform) => Stack(
        children: [
          Positioned.fill(
            child: SchemeFigure(
              plane: _projectionPlane,
              figure: _hull,
              layoutTransform: transform,
            ),
          ),
          ..._cargoFigures.map(
            (cargoFigure) => Positioned.fill(
              child: SchemeFigure(
                plane: _projectionPlane,
                figure: cargoFigure.figure,
                layoutTransform: transform,
                onTap: () => _onCargoTap?.call(cargoFigure.cargo),
              ),
            ),
          ),
          if (_selectedCargoFigure != null)
            Positioned.fill(
              child: SchemeFigure(
                plane: _projectionPlane,
                figure: _selectedCargoFigure.figure.copyWith(paints: [
                  Paint()
                    ..color = _selectedCargoColor
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2.0,
                ]),
                layoutTransform: transform,
                onTap: () => _onCargoTap?.call(_selectedCargoFigure.cargo),
              ),
            ),
          if (_framesTheoretical != null)
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: IgnorePointer(
                child: SchemeAxis(
                  majorTicks: _framesTheoretical
                      .map(
                        (frame) => (
                          label: '${frame.index}${const Localized('ft').v}',
                          offset: frame.x
                        ),
                      )
                      .toList(),
                  axis: const ChartAxis(
                    isLabelsVisible: true,
                    valueInterval: 1.0,
                    labelsSpaceReserved: 15.0,
                  ),
                  labelStyle: axisLabelStyle,
                  color: axisColor,
                  transformValue: (v) =>
                      transform.transform3(Vector3(v, 0.0, 0.0)).x,
                ),
              ),
            ),
          if (_framesReal != null)
            Positioned(
              top: transform.transform3(Vector3(0.0, 0.0, 0.0)).y,
              left: 0.0,
              right: 0.0,
              child: IgnorePointer(
                child: SchemeAxis(
                  majorTicks: _framesReal
                      .where((frame) => frame.index % 10 == 0)
                      .map(
                        (frame) => (
                          label: '${frame.index}${const Localized('fr').v}',
                          offset: frame.x
                        ),
                      )
                      .toList(),
                  minorTicks: _framesReal
                      .map(
                        (frame) => (label: '', offset: frame.x),
                      )
                      .toList(),
                  axis: const ChartAxis(
                    isLabelsVisible: true,
                    valueInterval: 1.0,
                    labelsSpaceReserved: 15.0,
                  ),
                  labelStyle: axisLabelStyle,
                  color: axisColor,
                  transformValue: (v) =>
                      transform.transform3(Vector3(v, 0.0, 0.0)).x,
                ),
              ),
            ),
          Positioned(
            bottom: 0.0,
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
  }
}
