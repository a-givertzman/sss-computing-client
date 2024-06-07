import 'package:flutter/cupertino.dart';
///
/// Disables widget visually and blocks all mouse events
/// for child widget.
class DisabledWidget extends StatelessWidget {
  final Widget child;
  final bool disabled;
  ///
  /// Creates wodget for disabling widget visually
  /// and blocking all mouse events for child widget
  /// if disabled state passed.
  ///
  /// `child` - widget that will be disabled.
  /// `disabled` - if true widget will be disabled,
  /// otherwise it will be passed in widget tree without changes.
  const DisabledWidget({
    super.key,
    required this.child,
    this.disabled = false,
  });
  //
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disabled,
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: child,
      ),
    );
  }
}
