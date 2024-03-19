import 'package:flutter/material.dart';

///
class ActionButton extends StatelessWidget {
  final String _label;
  final IconData _icon;
  final double? _height;
  final double? _width;
  final void Function()? _onPressed;

  ///
  const ActionButton({
    super.key,
    required String label,
    required IconData icon,
    double? height,
    double? width,
    void Function()? onPressed,
  })  : _label = label,
        _icon = icon,
        _width = width,
        _height = height,
        _onPressed = onPressed;

  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: _height,
      width: _width,
      child: ElevatedButton.icon(
        onPressed: _onPressed,
        icon: Icon(
          _icon,
          size: 20,
        ),
        label: Text(
          _label,
          textAlign: TextAlign.center,
        ),
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (_) => theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
