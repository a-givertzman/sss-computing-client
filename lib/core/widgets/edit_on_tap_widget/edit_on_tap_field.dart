import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/widgets/activate_on_tap_builder_widget.dart';

///
/// Field that can be edited after activation by tap
class EditOnTapField extends StatefulWidget {
  final String _initialValue;
  final Color? _textColor;
  final Color? _iconColor;
  final Color? _errorColor;
  final Future<ResultF<String>> Function(String) _onSubmit;
  final void Function(String)? _onSubmitted;
  final void Function(String)? _onCancel;
  final Validator? _validator;
  final int maxLines;
  final String? _label;
  final String? _hintText;

  ///
  /// Creates [EditOnTapField] that can be edited
  /// after activation by tap
  const EditOnTapField({
    super.key,
    required String initialValue,
    required Future<ResultF<String>> Function(String value) onSubmit,
    this.maxLines = 1,
    String? label,
    String? hintText,
    Color? textColor,
    Color? iconColor,
    Color? errorColor,
    dynamic Function(String)? onSubmitted,
    dynamic Function(String)? onCancel,
    Validator? validator,
  })  : _validator = validator,
        _onCancel = onCancel,
        _onSubmit = onSubmit,
        _onSubmitted = onSubmitted,
        _errorColor = errorColor,
        _iconColor = iconColor,
        _textColor = textColor,
        _initialValue = initialValue,
        _label = label,
        _hintText = hintText;

  ///
  @override
  State<EditOnTapField> createState() => _EditOnTapFieldState();
}

///
class _EditOnTapFieldState extends State<EditOnTapField> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  Failure<String>? _error;
  String? _validationError;
  bool _isInProcess = false;
  String _initialValue = '';
  //
  @override
  void initState() {
    _initialValue = widget._initialValue;
    _isInProcess = false;
    super.initState();
  }

  //
  @override
  void dispose() {
    _handleEditingEnd();
    super.dispose();
  }

  //
  void _handleEditingStart() {
    _controller = TextEditingController(text: _initialValue);
    _controller?.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller?.text.length ?? 0,
    );
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
        value == _initialValue ? Ok(value) : await widget._onSubmit(value);
    switch (newValue) {
      case Ok(:final value):
        setState(() {
          _isInProcess = false;
          _initialValue = value;
        });
        widget._onSubmitted?.call(value);
        return const Ok(null);
      case Err(:final error):
        setState(() {
          _isInProcess = false;
          _error = Failure<String>(
            message: '${error.message}',
            stackTrace: StackTrace.current,
          );
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
    // final iconSize = IconTheme.of(context).size ?? 10.0;
    const iconSize = 12.0;
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
              maxLines: widget.maxLines,
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
                    decoration: InputDecoration(
                      labelText: widget._label,
                      hintText: widget._hintText,
                    ),
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
                ..._buildActions(iconSize, deactivate),
              ],
            )),
    );
  }

  //
  List<Widget> _buildActions(double iconSize, void Function() deactivate) {
    if (_isInProcess) {
      return [
        CupertinoActivityIndicator(
          color: widget._iconColor,
          radius: iconSize / 2,
        ),
      ];
    }
    return [
      if (_validationError != null) _buildValidationErrorIndicator(iconSize),
      if (_validationError == null) _buildSaveButton(iconSize, deactivate),
      _buildCancelButton(iconSize, deactivate),
      if (!_isInProcess && _error != null) _buildErrorIndicator(iconSize),
    ];
  }

  //
  Widget _buildSaveButton(double iconSize, void Function() deactivate) =>
      SizedBox(
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
            Icons.save,
            color: widget._iconColor,
          ),
        ),
      );
  //
  Widget _buildCancelButton(double iconSize, void Function() deactivate) =>
      Container(
        width: iconSize,
        height: iconSize,
        margin: EdgeInsets.symmetric(horizontal: iconSize),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            widget._onCancel?.call(_controller!.text);
            deactivate();
          },
          child: Icon(
            Icons.edit_off_outlined,
            color: widget._iconColor,
          ),
        ),
      );
  //
  Widget _buildValidationErrorIndicator(double iconSize) => SizedBox(
        width: iconSize,
        height: iconSize,
        child: Tooltip(
          message: _validationError,
          child: Icon(
            Icons.warning_rounded,
            color: widget._errorColor,
          ),
        ),
      );
  //
  Widget _buildErrorIndicator(double iconSize) => SizedBox(
        width: iconSize,
        height: iconSize,
        child: Tooltip(
          message: '${_error?.message}',
          child: Icon(
            Icons.error_outline,
            color: widget._errorColor,
          ),
        ),
      );
}
