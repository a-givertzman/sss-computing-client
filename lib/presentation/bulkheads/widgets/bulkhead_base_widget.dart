import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
/// Widget displaying grain bulkhead.
class BulkheadBaseWidget extends StatelessWidget {
  final Color _borderColor;
  final Color _backgroundColor;
  final double _height;
  final double _width;
  final Widget _child;
  final bool _isDragged;
  final Widget? _leading;
  final Widget? _trailing;
  ///
  /// Creates widget displaying grain bulkhead.
  ///
  ///   `borderColor`, `backgroundColor`, `height` and `width`
  /// define appearance of grain bulkhead widget.
  ///   `leadging` and `trailing` widgets are rendered on top and bottom
  /// of grain bulkhead widget respectively.
  ///   If `isDraged` is true, widget has elevated effect.
  const BulkheadBaseWidget({
    super.key,
    required Color borderColor,
    required Color backgroundColor,
    required double height,
    required Widget child,
    double width = 32.0,
    bool isDragged = false,
    Widget? leading,
    Widget? trailing,
  })  : _borderColor = borderColor,
        _backgroundColor = backgroundColor,
        _height = height,
        _width = width,
        _child = child,
        _isDragged = isDragged,
        _leading = leading,
        _trailing = trailing;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Container(
      width: _width,
      height: _height,
      padding: EdgeInsets.symmetric(vertical: padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.fromBorderSide(
          BorderSide(color: _borderColor, width: 1.0),
        ),
        boxShadow: [
          if (_isDragged)
            const BoxShadow(
              color: Colors.black,
              blurRadius: 5.0,
              spreadRadius: -1.0,
            ),
        ],
        color: _backgroundColor,
      ),
      child: RotatedBox(
        quarterTurns: -1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_leading != null) _leading,
            SizedBox(width: padding),
            _child,
            const Spacer(),
            SizedBox(width: padding),
            if (_trailing != null) _trailing,
          ],
        ),
      ),
    );
  }
}
