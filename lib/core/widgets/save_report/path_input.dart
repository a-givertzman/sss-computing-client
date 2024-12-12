import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/widgets/form/async_action_button.dart';
///
/// Widget to pick directory and file name for saving.
class PathInput extends StatefulWidget {
  final Option<String> _initialValue;
  final void Function(Option<String>) _onValueChange;
  final void Function(String error)? _onError;
  final void Function()? _onPickStarted;
  final void Function()? _onPickFinished;
  final String? _helperMessage;
  final String? _errorMessage;
  ///
  /// Creates widget to pick directory and file name for saving,
  /// with optional [initialValue]. Allows to handle picking value
  /// with [onValueChange] callback.
  const PathInput({
    super.key,
    required Option<String> initialValue,
    required void Function(Option<String>) onValueChange,
    void Function(String error)? onError,
    void Function()? onPickStarted,
    void Function()? onPickFinished,
    String? helperMessage,
    String? errorMessage,
  })  : _initialValue = initialValue,
        _onValueChange = onValueChange,
        _onError = onError,
        _onPickStarted = onPickStarted,
        _onPickFinished = onPickFinished,
        _helperMessage = helperMessage,
        _errorMessage = errorMessage;
  //
  @override
  State<PathInput> createState() => _PathInputState();
}
///
class _PathInputState extends State<PathInput> {
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _DirectoryPreview(
            directory: switch (widget._initialValue) {
              Some(value: final path) => path,
              None() => null,
            },
            onClear: _clearDirectory,
            errorMessage: widget._errorMessage,
            helperMessage: widget._helperMessage,
          ),
        ),
        SizedBox(width: padding),
        AsyncActionButton(
          label: const Localized('Choose directory').v,
          icon: Icons.folder_rounded,
          onPressed: _pickDirectory,
        ),
      ],
    );
  }
  //
  Future<void> _pickDirectory() {
    widget._onPickStarted?.call();
    return FilePicker.platform.getDirectoryPath().then(
      (value) {
        if (value != null && mounted) {
          widget._onValueChange(Some(value));
        }
      },
    ).catchError(
      (error) {
        if (mounted) {
          widget._onError?.call(error.toString());
        }
      },
    ).whenComplete(() {
      if (mounted) {
        widget._onPickFinished?.call();
      }
    });
  }
  //
  void _clearDirectory() {
    if (mounted) {
      widget._onValueChange(const None());
    }
  }
}
///
/// Preview widget for directory.
class _DirectoryPreview extends StatelessWidget {
  final void Function() _onClear;
  final String? _directory;
  final String? _errorMessage;
  final String? _helperMessage;
  ///
  /// Creates preview widget for [directory] and allows to clear it
  /// using [onClear] callback.
  const _DirectoryPreview({
    required void Function() onClear,
    required String? directory,
    required String? errorMessage,
    required String? helperMessage,
  })  : _onClear = onClear,
        _directory = directory,
        _errorMessage = errorMessage,
        _helperMessage = helperMessage;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final iconSize = const Setting('iconSizeMedium').toDouble;
    if (_errorMessage != null) {
      return Text(
        _errorMessage,
        style: textStyle?.copyWith(color: theme.colorScheme.error),
      );
    }
    return _directory != null
        ? Align(
            alignment: Alignment.centerLeft,
            child: Tooltip(
              message: _directory,
              child: InputChip(
                label: Text(
                  _directory,
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                onDeleted: _onClear,
                deleteIcon: Icon(Icons.close, size: iconSize),
                deleteButtonTooltipMessage:
                    const Localized('Clear directory').v,
              ),
            ),
          )
        : Text(
            _helperMessage ?? const Localized('No directory selected').v,
            style: textStyle,
            textAlign: TextAlign.left,
          );
  }
}
