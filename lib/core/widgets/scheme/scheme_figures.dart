import 'package:flutter/cupertino.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figure.dart';
///
class SchemeFigures extends StatelessWidget {
  final FigurePlane _plane;
  final List<Figure> _figures;
  final Matrix4 _layoutTransform;
  ///
  /// Display list of [Figure] on [SchemeLayout] content.
  const SchemeFigures({
    super.key,
    required FigurePlane plane,
    required List<Figure> figures,
    required Matrix4 layoutTransform,
  })  : _plane = plane,
        _figures = figures,
        _layoutTransform = layoutTransform;
  //
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final figure in _figures)
          SchemeFigure(
            plane: _plane,
            figure: figure,
            layoutTransform: _layoutTransform,
          ),
      ],
    );
  }
}
