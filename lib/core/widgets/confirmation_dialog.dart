import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
/// Confirmation dialog.
class ConfirmationDialog extends StatelessWidget {
  final Widget? _title;
  final Widget? _content;
  final String? _cancellationButtonLabel;
  final String? _confirmationButtonLabel;
  ///
  /// Creates confirmation dialog, typically used with [showDialog].
  ///
  /// * [title] - dialog title widget
  /// * [content] - dialog content widget
  /// * [cancellationButtonLabel] - label for cancellation button, 'Cancel' by default
  /// * [confirmationButtonLabel] - label for confirmation button, 'Confirm' by default
  const ConfirmationDialog({
    super.key,
    Widget? title,
    Widget? content,
    String? cancellationButtonLabel,
    String? confirmationButtonLabel,
  })  : _confirmationButtonLabel = confirmationButtonLabel,
        _cancellationButtonLabel = cancellationButtonLabel,
        _content = content,
        _title = title;
  //
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _title,
      content: _content,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(_cancellationButtonLabel ?? const Localized('Cancel').v),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(_confirmationButtonLabel ?? const Localized('Confirm').v),
        ),
      ],
    );
  }
}
