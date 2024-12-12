import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/widgets/save_report/path_input.dart';
///
/// Custom [FormField] for file saving path.
class PathFormField extends StatelessWidget {
  final String? _label;
  final String? _initialValue;
  final String? _helperMessage;
  final void Function(String?)? _onChanged;
  final void Function(String?)? _onSaved;
  final void Function(String errorMessage)? _onError;
  final void Function()? _onPickStarted;
  final void Function()? _onPickFinished;
  final String? Function(String?)? _validator;
  final AutovalidateMode? _autovalidateMode;
  ///
  /// Creates [FormField] with [String] value for picking directory and name for saving file.
  ///
  /// * [label] - an optional label to display above the form field.
  /// * [initialValue] - an optional value to initialize the form field to, or null otherwise.
  /// * [helperMessage] - an optional message to display before user starts interacting, or null otherwise.
  /// * [onChanged] - an optional method to call whenever the form field's value changes.
  /// * [onSaved] - an optional method to call with the final value when the form is saved via [FormState.save].
  /// * [onPickStarted] and [onPickFinished] - optional methods to call when the user starts and ends
  /// picking directory respectively.
  /// * [validator] - an optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  ///
  /// {@macro flutter.widgets.FormField.autovalidateMode}
  const PathFormField({
    super.key,
    String? label,
    String? initialValue,
    String? helperMessage,
    void Function(String? value)? onChanged,
    void Function(String? value)? onSaved,
    void Function(String errorMessage)? onError,
    void Function()? onPickStarted,
    void Function()? onPickFinished,
    String? Function(String? value)? validator,
    AutovalidateMode? autovalidateMode,
  })  : _label = label,
        _initialValue = initialValue,
        _helperMessage = helperMessage,
        _onChanged = onChanged,
        _onSaved = onSaved,
        _onError = onError,
        _onPickStarted = onPickStarted,
        _onPickFinished = onPickFinished,
        _validator = validator,
        _autovalidateMode = autovalidateMode;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface,
    );
    final errorLabelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.stateColors.error,
    );
    final padding = const Setting('padding').toDouble;
    return FormField<String>(
      initialValue: _initialValue,
      onSaved: _onSaved,
      validator: _validator,
      autovalidateMode: _autovalidateMode,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_label != null)
            Padding(
              padding: EdgeInsets.only(bottom: padding * 0.5),
              child: Text(
                _label,
                style: state.hasError ? errorLabelStyle : textStyle,
              ),
            ),
          PathInput(
            initialValue: switch (state.value) {
              String path => Some(path),
              null => const None() as Option<String>,
            },
            onValueChange: (value) => _handleValueChanged(value, state),
            onError: _onError,
            onPickStarted: _onPickStarted,
            onPickFinished: _onPickFinished,
            helperMessage: _helperMessage,
          ),
          if (state.hasError)
            Padding(
              padding: EdgeInsets.only(top: padding * 0.5),
              child: Text(
                state.errorText!,
                style: errorLabelStyle,
              ),
            ),
        ],
      ),
    );
  }
  //
  void _handleValueChanged(Option<String> value, FormFieldState<String> state) {
    final path = switch (value) {
      Some(value: final path) => path,
      None() => null,
    };
    state.didChange(path);
    _onChanged?.call(path);
  }
}
