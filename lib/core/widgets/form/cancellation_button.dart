import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
/// Button to run cancel action.
class CancellationButton extends StatelessWidget {
  final double? _height;
  final double? _width;
  final String? _label;
  final double _labelLineHeught;
  final void Function()? _onPressed;
  ///
  /// Creates button to run cancel action.
  ///
  /// [onPressed] callback starts cancel action.
  /// [label] is used as button text.
  /// [width] and [height] determines button size.
  /// [labelLineHeight] determines lineHeight for label text.
  const CancellationButton({
    super.key,
    required void Function()? onPressed,
    String? label,
    double? height,
    double? width,
    double labelLineHeught = 1.0,
  })  : _labelLineHeught = labelLineHeught,
        _width = width,
        _height = height,
        _label = label,
        _onPressed = onPressed;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: _height,
      width: _width,
      child: TextButton(
        onPressed: _onPressed,
        style: ButtonStyle(
          textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (states) => theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              height: _labelLineHeught,
            ),
          ),
        ),
        child: Text(
          _label ?? const Localized('Cancel').v,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
