import 'package:flutter/material.dart';
///
/// Button with icon and action on press
class ActionButton extends StatelessWidget {
  final String _label;
  final IconData _icon;
  final IconAlignment _iconAlignment;
  final double? _height;
  final double? _width;
  final void Function()? _onPressed;
  /// Creates [ActionButton] with provided label, icon
  /// and callback calling when pressed
  const ActionButton({
    super.key,
    required String label,
    required IconData icon,
    IconAlignment iconAlignment = IconAlignment.start,
    double? height,
    double? width,
    void Function()? onPressed,
  })  : _label = label,
        _icon = icon,
        _iconAlignment = iconAlignment,
        _width = width,
        _height = height,
        _onPressed = onPressed;
  ///
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: _width,
      child: ElevatedButton.icon(
        onPressed: _onPressed,
        icon: Icon(_icon, size: 20),
        iconAlignment: _iconAlignment,
        label: Text(_label, textAlign: TextAlign.end),
      ),
    );
  }
}
