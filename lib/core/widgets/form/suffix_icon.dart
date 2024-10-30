import 'package:flutter/material.dart';
///
/// Widget that shows suffix icon based on passed [_isVisible] flag.
class ConditionalSuffixIcon extends StatelessWidget {
  final bool _isVisible;
  final double? _size;
  final Widget? _visibleChild;
  final Widget? _invisibleChild;
  ///
  /// Creates widget that shows suffix icon based on passed [isVisible] flag.
  ///
  /// [visibleChild] is shown if [isVisible] is `true`
  /// and [invisibleChild] is shown if [isVisible] is `false`.
  /// [size] determines width and height of this widget.
  const ConditionalSuffixIcon({
    super.key,
    required bool isVisible,
    double? size,
    Widget? visibleChild,
    Widget? invisibleChild,
  })  : _isVisible = isVisible,
        _size = size,
        _visibleChild = visibleChild,
        _invisibleChild = invisibleChild;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _size,
      width: _size,
      child: _isVisible ? _visibleChild : _invisibleChild,
    );
  }
}
