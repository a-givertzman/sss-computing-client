import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/validation/int_validation_case.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/form/suffix_icon.dart';
///
class CancellableCustomField extends StatefulWidget {
  final TextEditingController _controller;
  final String _label;
  final FieldType _fieldType;
  final String _initialValue;
  final String? _sendError;
  final void Function(String)? _onChanged;
  final void Function(String)? _onCancelled;
  final Future<ResultF<String>> Function(String?)? _onSaved;
  final Validator? _validator;
  final Widget Function(
    String value,
    void Function(String) updateValue,
  ) _buildCustomField;
  ///
  const CancellableCustomField({
    super.key,
    required TextEditingController controller,
    required String label,
    FieldType fieldType = FieldType.string,
    String initialValue = '',
    String? sendError,
    Validator? validator,
    void Function(String)? onChanged,
    void Function(String)? onCancelled,
    Future<ResultF<String>> Function(String?)? onSaved,
    required Widget Function(
      String value,
      void Function(String) updateValue,
    ) buildCustomField,
  })  : _controller = controller,
        _label = label,
        _sendError = sendError,
        _initialValue = initialValue,
        _onChanged = onChanged,
        _onCancelled = onCancelled,
        _onSaved = onSaved,
        _validator = validator,
        _fieldType = fieldType,
        _buildCustomField = buildCustomField;
  //
  @override
  State<CancellableCustomField> createState() => _CancellableCustomFieldState();
}
///
class _CancellableCustomFieldState extends State<CancellableCustomField> {
  late final TextEditingController _controller;
  late final Validator? _validator;
  late String _initialValue;
  late String? _sendError;
  bool _isInProcess = false;
  //
  @override
  void initState() {
    _controller = widget._controller;
    _validator = widget._validator ??
        Validator(
          cases: switch (widget._fieldType) {
            FieldType.int => const [
                IntValidationCase(),
              ],
            FieldType.real => const [
                RealValidationCase(),
              ],
            _ => const [
                MinLengthValidationCase(0),
                MaxLengthValidationCase(255),
              ],
          },
        );
    _initialValue = widget._initialValue;
    _sendError = widget._sendError;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suffixIconSize = IconTheme.of(context).size;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Row(children: [
      Expanded(
        child: FormField<String>(
          initialValue: _initialValue,
          validator: _handleValueValidate,
          autovalidateMode: AutovalidateMode.always,
          onSaved: _handleValueSave,
          builder: (state) => _CustomFieldContent(
            label: widget._label,
            errorMessage: state.hasError ? state.errorText : null,
            child: widget._buildCustomField(
              state.value ?? '',
              (value) {
                state.didChange(value);
                _handleValueChange(value);
              },
            ),
          ),
        ),
      ),
      SizedBox(
        width: blockPadding,
        height: suffixIconSize,
      ),
      // clear button
      ConditionalSuffixIcon(
        size: suffixIconSize,
        isVisible: _initialValue != _controller.text,
        visibleChild: InkWell(
          onTap: _handleValueCancel,
          customBorder: const CircleBorder(),
          child: Icon(
            Icons.clear,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      // process indicator with optional error
      ConditionalSuffixIcon(
        size: suffixIconSize,
        isVisible: _isInProcess,
        visibleChild: const CupertinoActivityIndicator(),
        invisibleChild: ConditionalSuffixIcon(
          isVisible: _sendError != null,
          visibleChild: Tooltip(
            message: _sendError ?? '',
            child: Icon(
              Icons.info_outline,
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ),
    ]);
  }
  //
  String? _handleValueValidate(String? value) {
    final validateError = _validator?.editFieldValidator(value);
    if (validateError == null) return null;
    return Localized(validateError).v;
  }
  //
  void _handleValueChange(String value) {
    widget._onChanged?.call(value);
    _controller.text = value;
    setState(() {
      return;
    });
  }
  //
  void _handleValueCancel() {
    widget._onCancelled?.call(_controller.text);
    _controller.text = _initialValue;
    setState(() {
      _sendError = null;
    });
  }
  //
  void _handleValueSave(String? value) {
    final onSaved = widget._onSaved;
    if (_initialValue == _controller.text || onSaved == null) return;
    setState(() {
      _isInProcess = true;
      _sendError = null;
    });
    onSaved
        .call(value)
        .then(
          (result) => switch (result) {
            Ok() => setState(() {
                _initialValue = _controller.text;
              }),
            Err(:final error) => setState(() {
                _sendError = '${error.message}';
              }),
          },
        )
        .catchError(
          (error) => setState(() {
            _sendError = '$error';
          }),
        )
        .whenComplete(
          () => setState(() {
            _isInProcess = false;
          }),
        );
  }
}
class _CustomFieldContent extends StatelessWidget {
  final Widget _child;
  final String _label;
  final String? _errorMessage;
  const _CustomFieldContent({
    required Widget child,
    required String label,
    String? errorMessage,
  })  : _child = child,
        _label = label,
        _errorMessage = errorMessage;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final padding = const Setting('padding').toDouble;
    final labelColor = _errorMessage != null
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;
    final errorMessage = _errorMessage;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label,
          style: textTheme.bodyLarge?.copyWith(color: labelColor),
        ),
        SizedBox(height: padding),
        _child,
        SizedBox(height: padding),
        if (errorMessage != null)
          Text(
            errorMessage,
            style: textTheme.bodyMedium?.copyWith(color: labelColor),
          ),
      ],
    );
  }
}
