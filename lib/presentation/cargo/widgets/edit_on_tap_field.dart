import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/persistable/value_record.dart';
import 'package:sss_computing_client/widgets/core/activate_on_tap_builder_widget.dart';

/// Field that can be edited after activation by tap
class EditOnTapField extends StatefulWidget {
  final String _initialValue;
  final ValueRecord _record;
  final Color _textColor;
  final Color _iconColor;
  final Color _errorColor;
  final Function(String)? _onSave;
  final Function(String)? _onCancel;
  final Validator? _validator;

  /// Creates [EditOnTapField] that can be edited
  /// after activation by tap
  const EditOnTapField({
    super.key,
    required String initialValue,
    required ValueRecord record,
    required Color textColor,
    required Color iconColor,
    required Color errorColor,
    dynamic Function(String)? onSave,
    dynamic Function(String)? onCancel,
    Validator? validator,
  })  : _validator = validator,
        _onCancel = onCancel,
        _onSave = onSave,
        _errorColor = errorColor,
        _iconColor = iconColor,
        _textColor = textColor,
        _record = record,
        _initialValue = initialValue;

  ///
  @override
  State<EditOnTapField> createState() => _EditOnTapFieldState();
}

///
class _EditOnTapFieldState extends State<EditOnTapField> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  Failure? _error;
  String? _validationError;
  bool _isInProcess = false;
  late String _initialValue;

  void _handleEditingStart() {
    Log('$runtimeType').debug('${widget.key}');
    Log('$runtimeType').debug('editing start');
    _controller = TextEditingController(text: _initialValue);
    _focusNode = FocusNode();
    _focusNode?.requestFocus();
  }

  ///
  void _handleEditingEnd() {
    _controller?.dispose();
    _controller = null;
    _focusNode?.dispose();
    _focusNode = null;
    _validationError = null;
    _error = null;
  }

  ///
  @override
  void initState() {
    _initialValue = widget._initialValue;
    _isInProcess = false;
    super.initState();
  }

  ///
  @override
  void dispose() {
    _handleEditingEnd();
    super.dispose();
  }

  ///
  Future<ResultF<void>> _handleValueSave(String value) async {
    if (_validationError != null) {
      return Err(Failure(
        message: _validationError,
        stackTrace: StackTrace.current,
      ));
    }
    setState(() {
      _isInProcess = true;
      _error = null;
    });
    final ResultF<String> newValue = value == _initialValue
        ? Ok(value)
        : await widget._record.persist(value);
    switch (newValue) {
      case Ok(:final value):
        widget._onSave?.call(value);
        setState(() {
          _isInProcess = false;
          _initialValue = value;
        });
        return const Ok(null);
      case Err(:final error):
        setState(() {
          _isInProcess = false;
          _error = error;
        });
        return Err(error);
    }
  }

  ///
  void _handleValueChange(String value) {
    if (_error != null) {
      setState(() {
        _error = null;
      });
    }
    final validationError = widget._validator?.editFieldValidator(value);
    if (validationError != _validationError) {
      setState(() {
        _validationError = validationError;
      });
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    final iconSize = IconTheme.of(context).size ?? 10.0;
    return ActivateOnTapBuilderWidget(
      cursor: SystemMouseCursors.text,
      onActivate: () {
        _handleEditingStart();
        return;
      },
      onDeactivate: () {
        if (_isInProcess) return true;
        _handleEditingEnd();
        return false;
      },
      builder: ((context, isActivated, deactivate) => !isActivated
          ? Text(
              _initialValue,
              overflow: TextOverflow.ellipsis,
            )
          : Row(
              children: [
                Flexible(
                  flex: 1,
                  child: TextField(
                    readOnly: _isInProcess,
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _handleValueChange,
                    onSubmitted: (value) => _handleValueSave(value).then(
                      (value) {
                        if (value is Ok) deactivate();
                      },
                    ),
                    style: TextStyle(
                      color: widget._textColor,
                    ),
                  ),
                ),
                if (_isInProcess)
                  CupertinoActivityIndicator(
                    color: widget._iconColor,
                    radius: iconSize / 2,
                  ),
                if (!_isInProcess) ...[
                  switch (_validationError) {
                    null => SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => _handleValueSave(_controller!.text).then(
                            (value) {
                              if (value is Ok) deactivate();
                            },
                          ),
                          child: Icon(
                            Icons.done,
                            color: widget._iconColor,
                          ),
                        ),
                      ),
                    _ => SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: Tooltip(
                          message: _validationError,
                          child: Icon(
                            Icons.warning_rounded,
                            color: widget._errorColor,
                          ),
                        ),
                      ),
                  },
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        widget._onCancel?.call(_controller!.text);
                        deactivate();
                      },
                      child: Icon(
                        Icons.close,
                        color: widget._iconColor,
                      ),
                    ),
                  ),
                ],
                if (!_isInProcess && _error != null)
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: Tooltip(
                      message: _error?.message ?? '',
                      child: Icon(
                        Icons.error_outline,
                        color: widget._errorColor,
                      ),
                    ),
                  ),
              ],
            )),
    );
  }
}
