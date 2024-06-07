import 'dart:math';
import 'package:flutter/material.dart';
///
/// Calculates scaling factor for widget according to its initial size
/// and desired way to fill the available space.
class FittedBuilderWidget extends StatelessWidget {
  final Widget Function(BuildContext, double, double) _builder;
  final Size _size;
  final BoxFit _fit;
  ///
  /// Calculates scaling factor for widget according to its initial size
  /// and desired way to fill the available space.
  /// Scaling factors can be used via builder function.
  ///
  /// `builder` - builder for widget with scaling factors as parameters.
  /// `size` - initial size of the widget.
  /// `fit` - specifies how a box should be inscribed into another box.
  const FittedBuilderWidget({
    super.key,
    required Widget Function(
      BuildContext context,
      double scaleX,
      double scaleY,
    ) builder,
    required Size size,
    BoxFit fit = BoxFit.contain,
  })  : _builder = builder,
        _size = size,
        _fit = fit;
  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ) = constraints;
      final (scaleX, scaleY) = (
        width / _size.width,
        height / _size.height,
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
          actualScaleX = actualScaleY = min(
            min(scaleX, 1.0),
            min(scaleY, 1.0),
          );
      }
      return _builder(context, actualScaleX, actualScaleY);
    });
  }
}
