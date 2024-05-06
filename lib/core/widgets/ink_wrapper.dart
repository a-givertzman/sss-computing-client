import 'package:flutter/material.dart';
class InkWrapper extends StatelessWidget {
  ///
  final Color? _splashColor;
  final Widget _child;
  final VoidCallback _onTap;
  ///
  const InkWrapper({
    super.key,
    Color? splashColor,
    required Widget child,
    required VoidCallback onTap,
  })  : _splashColor = splashColor,
        _child = child,
        _onTap = onTap;
  ///
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _child),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(splashColor: _splashColor, onTap: _onTap),
          ),
        ),
      ],
    );
  }
}
