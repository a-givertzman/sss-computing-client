import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
/// Button to start asynchronous action.
class AsyncActionButton extends StatefulWidget {
  final double? _height;
  final double? _width;
  final String? _label;
  final IconData? _icon;
  final double _labelLineHeight;
  final Future<void> Function()? _onPressed;
  ///
  /// Creates button to start asynchronous action.
  ///
  /// [onPressed] callback starts asynchronous action.
  /// [label] is used as button text.
  /// [width] and [height] determines button size.
  /// [labelLineHeight] determines lineHeight for label text.
  const AsyncActionButton({
    super.key,
    required Future<void> Function()? onPressed,
    double? height,
    double? width,
    String? label,
    IconData? icon,
    double labelLineHeight = 1.0,
  })  : _labelLineHeight = labelLineHeight,
        _width = width,
        _height = height,
        _label = label,
        _icon = icon,
        _onPressed = onPressed;
  //
  @override
  State<AsyncActionButton> createState() => _AsyncActionButtonState();
}
///
class _AsyncActionButtonState extends State<AsyncActionButton> {
  late bool _isInProgress;
  @override
  void initState() {
    _isInProgress = false;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = const Setting('iconSizeMedium').toDouble;
    return SizedBox(
      height: widget._height,
      width: widget._width,
      child: ElevatedButton.icon(
        onPressed: _getOnPressed(),
        icon: _isInProgress
            ? CupertinoActivityIndicator(
                radius: iconSize / 2,
              )
            : Icon(
                widget._icon ?? Icons.play_arrow_rounded,
                size: iconSize,
              ),
        label: Text(
          widget._label ?? '',
          textAlign: TextAlign.center,
        ),
        style: ButtonStyle(
          textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (states) => theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              height: widget._labelLineHeight,
            ),
          ),
        ),
      ),
    );
  }
  //
  void Function()? _getOnPressed() =>
      (widget._onPressed != null && !_isInProgress)
          ? () async {
              setState(() => _isInProgress = true);
              await widget._onPressed?.call();
              if (!mounted) return;
              setState(() => _isInProgress = false);
            }
          : null;
}
