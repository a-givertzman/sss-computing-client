import 'package:flutter/cupertino.dart';
///
class DisabledWidget extends StatelessWidget {
  final Widget child;
  final bool disabled;
  ///
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
