import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/validation/int_validation_case.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
///
class CancelableField extends StatefulWidget {
  final FieldType _fieldType;
  final String _initialValue;
  final TextEditingController _controller;
  final String? _label;
  final String? _suffixText;
  final String? _sendError;
  final void Function(String)? _onChanged;
  final void Function(String)? _onCanceled;
  final void Function(String)? _onSubmitted;
  final Future<ResultF<String>> Function(String?)? _onSaved;
  final Validator? _validator;
  ///
  const CancelableField({
    super.key,
    required TextEditingController controller,
    String? label,
    String? suffixText,
    String? sendError,
    String initialValue = '',
    FieldType fieldType = FieldType.string,
    void Function(String)? onChanged,
    void Function(String)? onCanceled,
    void Function(String)? onSubmitted,
    Future<ResultF<String>> Function(String?)? onSaved,
    Validator? validator,
  })  : _controller = controller,
        _label = label,
        _suffixText = suffixText,
        _sendError = sendError,
        _initialValue = initialValue,
        _onChanged = onChanged,
        _onCanceled = onCanceled,
        _onSubmitted = onSubmitted,
        _onSaved = onSaved,
        _validator = validator,
        _fieldType = fieldType;
  //
  @override
  State<CancelableField> createState() => _CancelableFieldState(
        label: _label,
        suffixText: _suffixText,
        sendError: _sendError,
        initialValue: _initialValue,
        onChanged: _onChanged,
        onCanceled: _onCanceled,
        onSaved: _onSaved,
        validator: _validator,
        fieldType: _fieldType,
      );
}
///
class _CancelableFieldState extends State<CancelableField> {
  late final TextEditingController _controller;
  final FieldType _fieldType;
  final String? _label;
  final String? _suffixText;
  final void Function(String)? _onChanged;
  final void Function(String)? _onCanceled;
  final Future<ResultF<String>> Function(String?)? _onSaved;
  final Validator? _validator;
  String _initialValue;
  String? _sendError;
  bool _isInProcess = false;
  ///
  _CancelableFieldState({
    required String initialValue,
    required Validator? validator,
    required FieldType fieldType,
    required String? label,
    required String? suffixText,
    required String? sendError,
    required void Function(String)? onChanged,
    required void Function(String)? onCanceled,
    required Future<ResultF<String>> Function(String?)? onSaved,
  })  : _initialValue = initialValue,
        _label = label,
        _suffixText = suffixText,
        _sendError = sendError,
        _onChanged = onChanged,
        _onCanceled = onCanceled,
        _onSaved = onSaved,
        _validator = validator,
        _fieldType = fieldType;
  //
  @override
  void initState() {
    _controller = widget._controller;
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final suffixIconSize = IconTheme.of(context).size;
    final validator = _validator ??
        Validator(
          cases: switch (_fieldType) {
            FieldType.int => const [IntValidationCase()],
            FieldType.real => const [RealValidationCase()],
            _ => const [
                MinLengthValidationCase(0),
                MaxLengthValidationCase(255),
              ],
          },
        );
    return TextFormField(
      readOnly: switch (_fieldType) {
        FieldType.date => true,
        _ => false,
      },
      onTap: switch (_fieldType) {
        FieldType.date => () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              locale: const Locale('ru'),
              initialDate: DateTime.parse(_initialValue),
              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              final day = pickedDate.day.toString().padLeft(2, '0');
              final month = pickedDate.month.toString().padLeft(2, '0');
              final year = pickedDate.year.toString().padLeft(4, '0');
              final formattedDate = '$year-$month-$day';
              _controller.text = formattedDate;
              setState(() {
                _onChanged?.call(formattedDate);
              });
            }
          },
        _ => null,
      },
      autovalidateMode: AutovalidateMode.always,
      validator: (string) {
        final message = validator.editFieldValidator(string);
        return message != null ? Localized(message).v : null;
      },
      controller: _controller,
      onFieldSubmitted: widget._onSubmitted,
      onChanged: (value) {
        setState(() {
          _onChanged?.call(value);
        });
      },
      onSaved: (value) {
        if (_initialValue != _controller.text) {
          setState(() {
            _isInProcess = true;
            _sendError = null;
          });
          _onSaved
              ?.call(value)
              .then((result) => switch (result) {
                    Ok() => setState(() {
                        _initialValue = _controller.text;
                        _isInProcess = false;
                      }),
                    Err(:final error) => setState(() {
                        _sendError = error.message;
                        _isInProcess = false;
                      }),
                  })
              .onError((error, _) => setState(() {
                    _sendError = '$error';
                    _isInProcess = false;
                  }));
        }
      },
      decoration: InputDecoration(
        labelText: _label,
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 0,
              height: suffixIconSize,
            ),
            if (_suffixText != null) Text(_suffixText),
            if (_initialValue != _controller.text)
              SizedBox(
                width: suffixIconSize,
                height: suffixIconSize,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    setState(() {
                      _controller.text = _initialValue;
                      _controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: _initialValue.length),
                      );
                      _sendError = null;
                    });
                    _onCanceled?.call(_initialValue);
                  },
                  child: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            if (_isInProcess)
              SizedBox(
                width: suffixIconSize,
                height: suffixIconSize,
                child: const CupertinoActivityIndicator(),
              ),
            if (_sendError != null)
              SizedBox(
                width: suffixIconSize,
                height: suffixIconSize,
                child: Tooltip(
                  message: _sendError ?? '',
                  child: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
