import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/persistable/value_record.dart';
import 'package:sss_computing_client/widgets/core/activate_on_tap_builder_widget.dart';

class EditOnTapField extends StatefulWidget {
  final String initialValue;
  final ValueRecord record;
  final Color textColor;
  final Color iconColor;
  final Color errorColor;
  final Function(String)? onSave;
  final Function(String)? onCancel;
  final Validator? validator;
  const EditOnTapField({
    super.key,
    required this.initialValue,
    required this.record,
    required this.textColor,
    required this.iconColor,
    required this.errorColor,
    this.onSave,
    this.onCancel,
    this.validator,
  });

  @override
  State<EditOnTapField> createState() => _EditOnTapFieldState();
}

class _EditOnTapFieldState extends State<EditOnTapField> {
  late String _initialValue;
  late bool _isInProcess;
  TextEditingController? _controller;
  FocusNode? _focusNode;
  Failure? _error;
  String? _validationError;

  void _handleEditingStart() {
    Log('$runtimeType').debug('editing start');
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode?.requestFocus();
  }

  void _handleEditingEnd() {
    _controller?.dispose();
    _controller = null;
    _focusNode?.dispose();
    _focusNode = null;
    _validationError = null;
    _error = null;
  }

  @override
  void initState() {
    _initialValue = widget.initialValue;
    _isInProcess = false;
    super.initState();
  }

  @override
  void dispose() {
    _handleEditingEnd();
    super.dispose();
  }

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
    final ResultF<String> newValue =
        value == _initialValue ? Ok(value) : await widget.record.persist(value);
    switch (newValue) {
      case Ok(:final value):
        widget.onSave?.call(value);
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

  void _handleValueChange(String value) {
    if (_error != null) {
      setState(() {
        _error = null;
      });
    }
    final validationError = widget.validator?.editFieldValidator(value);
    if (validationError != _validationError) {
      setState(() {
        _validationError = validationError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = IconTheme.of(context).size ?? 10.0;
    return ActivateOnTapBuilderWidget(
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
                      color: widget.textColor,
                    ),
                  ),
                ),
                if (_isInProcess)
                  CupertinoActivityIndicator(
                    color: widget.iconColor,
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
                            color: widget.iconColor,
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
                            color: widget.errorColor,
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
                        widget.onCancel?.call(_controller!.text);
                        deactivate();
                      },
                      child: Icon(
                        Icons.close,
                        color: widget.iconColor,
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
                        color: widget.errorColor,
                      ),
                    ),
                  ),
              ],
            )),
    );
  }
}
