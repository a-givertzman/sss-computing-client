import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/figure.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/ship_scheme_figure.dart';

///
class ShipSchemeFigures extends StatelessWidget {
  // for tests TODO: remove
  final String projection;
  //
  final List<Figure> _figures;
  final double? _thickness;
  final double Function(double)? _transfromX;
  final double Function(double)? _transfromY;

  ///
  const ShipSchemeFigures({
    super.key,
    required this.projection,
    required List<Figure> figures,
    double? thickness,
    double Function(double)? transfromX,
    double Function(double)? transfromY,
  })  : _figures = figures,
        _thickness = thickness,
        _transfromX = transfromX,
        _transfromY = transfromY;

  ///
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._figures.map((figure) => Positioned.fill(
              child: ShipSchemeFigure(
                projection: projection,
                figure: figure,
                thickness: _thickness,
                transformX: _transfromX,
                transformY: _transfromY,
              ),
            )),
      ],
    );
  }
}
