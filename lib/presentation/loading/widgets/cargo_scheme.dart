import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figure.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_layout.dart';
///
class CargoScheme extends StatelessWidget {
  final FigurePlane projectionPlane;
  final Figure hull;
  final List<({Figure figure, Cargo cargo})> cargoFigures;
  final ({Figure figure, Cargo cargo})? selectedCargoFigure;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final ChartAxis xAxis;
  final ChartAxis yAxis;
  final bool xAxisReversed;
  final bool yAxisReversed;
  final void Function(Cargo cargo)? onCargoTap;
  final Color selectedCargoColor;
  ///
  const CargoScheme({
    super.key,
    required this.projectionPlane,
    required this.hull,
    required this.cargoFigures,
    required this.selectedCargoFigure,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.xAxis,
    required this.yAxis,
    required this.xAxisReversed,
    required this.yAxisReversed,
    this.selectedCargoColor = Colors.amber,
    this.onCargoTap,
  });
  //
  @override
  Widget build(BuildContext context) {
    return SchemeLayout(
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      xAxis: xAxis,
      yAxis: yAxis,
      xAxisReversed: xAxisReversed,
      yAxisReversed: yAxisReversed,
      buildContent: (context, transform) => Stack(
        children: [
          Positioned.fill(
            child: SchemeFigure(
              plane: projectionPlane,
              figure: hull,
              layoutTransform: transform,
            ),
          ),
          ...cargoFigures.map(
            (cargoFigure) => Positioned.fill(
              child: SchemeFigure(
                plane: projectionPlane,
                figure: cargoFigure.figure,
                layoutTransform: transform,
                onTap: () => onCargoTap?.call(cargoFigure.cargo),
              ),
            ),
          ),
          if (selectedCargoFigure != null)
            Positioned.fill(
              child: SchemeFigure(
                plane: projectionPlane,
                figure: selectedCargoFigure!.figure.copyWith(paints: [
                  Paint()
                    ..color = selectedCargoColor
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2.0,
                ]),
                layoutTransform: transform,
                onTap: () => onCargoTap?.call(selectedCargoFigure!.cargo),
              ),
            ),
        ],
      ),
    );
  }
}
