import 'package:flutter/cupertino.dart';
import 'package:sss_computing_client/core/models/scheme/canvas_text_centered.dart';
///
class SchemeText extends StatelessWidget {
  final String _text;
  final Offset _offset;
  final Alignment _alignment;
  final TextDirection _direction;
  final TextStyle? _style;
  final Matrix4 _layoutTransform;
  ///
  /// Display text on [SchemeLayout] content.
  const SchemeText({
    super.key,
    required String text,
    Offset offset = Offset.zero,
    Alignment alignment = Alignment.center,
    TextDirection direction = TextDirection.ltr,
    TextStyle? style,
    required Matrix4 layoutTransform,
  })  : _text = text,
        _offset = offset,
        _alignment = alignment,
        _direction = direction,
        _style = style,
        _layoutTransform = layoutTransform;
  ///
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SchemeTextPainter(
        text: _text,
        offset: _offset,
        alignment: _alignment,
        direction: _direction,
        style: _style,
        transform: _layoutTransform,
      ),
    );
  }
}
///
class _SchemeTextPainter extends CustomPainter {
  final String text;
  final Offset offset;
  final Alignment alignment;
  final TextDirection direction;
  final TextStyle? style;
  final Matrix4 transform;
  ///
  const _SchemeTextPainter({
    required this.text,
    required this.offset,
    required this.alignment,
    required this.direction,
    required this.style,
    required this.transform,
  });
  //
  @override
  void paint(Canvas canvas, Size size) {
    CanvasText(
      text: text,
      offset: offset,
      align: alignment,
      direction: direction,
      style: style,
    ).paint(
      canvas,
      transform: transform,
    );
  }
  //
  @override
  bool shouldRepaint(covariant _SchemeTextPainter oldDelegate) {
    return text != oldDelegate.text ||
        style != oldDelegate.style ||
        transform != oldDelegate.transform;
  }
}
