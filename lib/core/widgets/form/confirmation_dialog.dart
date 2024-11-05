import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
/// Dialog window that pops up to confirm user action.
class ConfirmationDialog extends StatelessWidget {
  final Widget? _title;
  final Widget? _content;
  final String? _cancellationButtonLabel;
  final String? _confirmationButtonLabel;
  ///
  /// Creates dialog window that pops up to confirm user action,
  /// with cancellation and confirmation options.
  ///
  /// [title] and [content] are used as dialog title and content.
  /// [cancellationButtonLabel] and [confirmationButtonLabel] are used as
  /// text labels for cancellation and confirmation buttons.
  const ConfirmationDialog({
    super.key,
    Widget? title,
    Widget? content,
    String? cancellationButtonLabel,
    String? confirmationButtonLabel,
  })  : _title = title,
        _content = content,
        _cancellationButtonLabel = cancellationButtonLabel,
        _confirmationButtonLabel = confirmationButtonLabel;
  //
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return AlertDialog(
      title: _title,
      content: _content,
      actions: [
        TextButton(
          onPressed: () => navigator.pop(false),
          child: Text(_cancellationButtonLabel ?? const Localized('Cancel').v),
        ),
        TextButton(
          onPressed: () => navigator.pop(true),
          child: Text(_confirmationButtonLabel ?? const Localized('Confirm').v),
        ),
      ],
    );
  }
}
