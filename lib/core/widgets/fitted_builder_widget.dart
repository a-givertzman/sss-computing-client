import 'dart:math';
import 'package:flutter/material.dart';

///
class FittedBuilderWidget extends StatelessWidget {
  final Widget Function(BuildContext context, double scaleX, double scaleY)
      _builder;
  final Size _size;
  final Offset _offset;
  final BoxFit _fit;

  ///
  const FittedBuilderWidget({
    super.key,
    required Widget Function(BuildContext, double, double) builder,
    required Size size,
    Offset offset = Offset.zero,
    BoxFit fit = BoxFit.contain,
  })  : _builder = builder,
        _size = size,
        _offset = offset,
        _fit = fit;

  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final BoxConstraints(:maxWidth, :maxHeight) = constraints;
      final (scaleX, scaleY) = (
        (maxWidth - _offset.dx) / _size.width,
        (maxHeight - _offset.dy) / _size.height,
      );
      late final double actualScaleX;
      late final double actualScaleY;
      switch (_fit) {
        case BoxFit.fill:
          actualScaleX = scaleX;
          actualScaleY = scaleY;
        case BoxFit.contain:
          actualScaleX = actualScaleY = min(scaleX, scaleY);
        case BoxFit.cover:
          actualScaleX = actualScaleY = max(scaleX, scaleY);
        case BoxFit.fitWidth:
          actualScaleX = actualScaleY = scaleX;
        case BoxFit.fitHeight:
          actualScaleX = actualScaleY = scaleY;
        case BoxFit.none:
          actualScaleX = actualScaleY = 1.0;
        case BoxFit.scaleDown:
          actualScaleX = actualScaleY = min(min(scaleX, 1.0), min(scaleY, 1.0));
      }
      return _builder(context, actualScaleX, actualScaleY);
    });
  }
}
