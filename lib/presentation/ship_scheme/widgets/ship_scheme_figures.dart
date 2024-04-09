import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/core/models/ship_scheme/figure.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_figure.dart';

///
class ShipSchemeFigures extends StatelessWidget {
  final (FigureAxis, FigureAxis) _projection;
  final Matrix4 _transform;
  final List<Figure> _figures;
  final double? _thickness;
  final void Function(Figure figure)? _onTap;

  ///
  const ShipSchemeFigures({
    super.key,
    required (FigureAxis, FigureAxis) projection,
    required Matrix4 transform,
    required List<Figure> figures,
    double? thickness,
    void Function(Figure figure)? onTap,
  })  : _projection = projection,
        _transform = transform,
        _figures = figures,
        _thickness = thickness,
        _onTap = onTap;

  ///
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._figures.map((figure) => Positioned.fill(
              child: ShipSchemeFigure(
                projection: _projection,
                transform: _transform,
                figure: figure,
                thickness: _thickness,
                onTap: _onTap,
              ),
            )),
      ],
    );
  }
}
