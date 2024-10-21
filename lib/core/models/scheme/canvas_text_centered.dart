import 'package:flutter/painting.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Text object that can be drawn on canvas.
class CanvasText {
  final String _text;
  final Offset _offset;
  final Alignment _alignment;
  final TextDirection _direction;
  final TextStyle? _style;
  ///
  /// Creates text object that can be drawn on canvas.
  ///
  /// [text] – text contained in text object,
  /// [offset] – offset for text object from origin of canvas,
  /// [align] – [Alignment] of text relative to passed offset,
  /// [direction] – [TextDirection] for text,
  /// [style] – [TextStyle] that used to paint text object on canvas;
  const CanvasText({
    required String text,
    Offset offset = Offset.zero,
    Alignment align = Alignment.center,
    TextDirection direction = TextDirection.ltr,
    TextStyle? style,
  })  : _text = text,
        _offset = offset,
        _alignment = align,
        _direction = direction,
        _style = style;
  ///
  /// Draws text on canvas taking into account its alignment and style.
  /// Textbox coordinates are calculated
  /// based on the passed offset and transformation.
  void paint(Canvas canvas, {Matrix4? transform}) {
    final offset = transform != null
        ? MatrixUtils.transformPoint(transform, _offset)
        : _offset;
    final textPainter = TextPainter(
      text: TextSpan(text: _text, style: _style),
      textDirection: _direction,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        offset.dx - textPainter.width / 2.0 * (1.0 - _alignment.x),
        offset.dy - textPainter.height / 2.0 * (1.0 - _alignment.y),
      ),
    );
  }
}
