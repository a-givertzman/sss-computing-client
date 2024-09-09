import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
///
/// Button to start asynchronous action.
class AsyncActionButton extends StatefulWidget {
  final double? _height;
  final double? _width;
  final String? _label;
  final double _labelLineHeight;
  final Future<void> Function()? _onPressed;
  ///
  /// Creates button to start asynchronous action.
  ///
  /// `onPressed` callback starts asynchronous action.
  /// `label` is used as button text.
  /// `width` and `height` determines button size.
  /// `labelLineHeight` determines lineHeight for label text.
  const AsyncActionButton({
    super.key,
    required Future<void> Function()? onPressed,
    String? label,
    double? height,
    double? width,
    double labelLineHeight = 1.0,
  })  : _labelLineHeight = labelLineHeight,
        _width = width,
        _height = height,
        _label = label,
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
    return SizedBox(
      height: widget._height,
      width: widget._width,
      child: ElevatedButton.icon(
        onPressed: _isInProgress
            ? null
            : (widget._onPressed == null ? null : _onPressed),
        icon: _isInProgress
            ? const CupertinoActivityIndicator(radius: 10)
            : const Icon(
                Icons.save_rounded,
                size: 20,
              ),
        label: Text(
          widget._label ?? '',
          textAlign: TextAlign.center,
        ),
        style: ButtonStyle(
          textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (states) => theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              height: widget._labelLineHeight,
            ),
          ),
        ),
      ),
    );
  }
  //
  void _onPressed() {
    setState(() {
      _isInProgress = true;
    });
    widget._onPressed?.call().then((_) {
      if (mounted) {
        setState(() {
          _isInProgress = false;
        });
      }
    }).onError((_, __) {
      if (mounted) {
        setState(() {
          _isInProgress = false;
        });
      }
    });
  }
}
