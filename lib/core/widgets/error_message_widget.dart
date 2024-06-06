import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class ErrorMessageWidget extends StatelessWidget {
  final TextStyle? _style;
  final Color? _iconColor;
  final void Function()? _onConfirm;
  final Failure<String>? _error;
  final String _message;
  ///
  const ErrorMessageWidget({
    super.key,
    TextStyle? style,
    Color? iconColor,
    void Function()? onConfirm,
    Failure<String>? error,
    required String message,
  })  : _style = style,
        _iconColor = iconColor,
        _onConfirm = onConfirm,
        _error = error,
        _message = message;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding').toDouble;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(
              message: _error?.message ?? '',
              child: Icon(
                Icons.warning_amber_rounded,
                color: _iconColor ?? theme.stateColors.error,
              ),
            ),
            SizedBox(width: padding),
            Flexible(
              child: OverflowableText(
                _message,
                style: _style ?? theme.textTheme.titleLarge,
              ),
            ),
          ],
        ),
        if (_onConfirm != null) ...[
          SizedBox(
            height: padding,
          ),
          ElevatedButton.icon(
            onPressed: _onConfirm,
            label: OverflowableText(const Localized('Retry').v),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ],
    );
  }
}
