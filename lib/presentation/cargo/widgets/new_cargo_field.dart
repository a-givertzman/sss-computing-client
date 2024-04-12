import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

/// Field used to obtain info about new [Cargo] parameter
class NewCargoField extends StatefulWidget {
  final Color _textColor;
  final Color _errorColor;
  final TextEditingController _controller;
  final void Function(String?)? _onValidityChange;
  final void Function(String)? _onValueChange;
  final Validator? _validator;
  final String? _validationError;

  /// Creates [NewCargoField] that used to
  /// obtain info about new [Cargo] parameter
  const NewCargoField({
    super.key,
    required Color textColor,
    required Color errorColor,
    required TextEditingController controller,
    Function(String? validationError)? onValidityChange,
    Function(String value)? onValueChange,
    Validator? validator,
    String? validationError,
  })  : _textColor = textColor,
        _errorColor = errorColor,
        _controller = controller,
        _onValidityChange = onValidityChange,
        _onValueChange = onValueChange,
        _validator = validator,
        _validationError = validationError;

  ///
  @override
  State<NewCargoField> createState() => _NewCargoFieldState();
}

///
class _NewCargoFieldState extends State<NewCargoField> {
  late final TextEditingController _controller;
  String? _validationError;

  ///
  @override
  void initState() {
    _controller = widget._controller;
    _validationError = widget._validationError;
    super.initState();
  }

  ///
  void _handleValueChange(String value) {
    widget._onValueChange?.call(value);
    final validationError = widget._validator?.editFieldValidator(value);
    if (validationError != _validationError) {
      widget._onValidityChange?.call(validationError);
      setState(() {
        _validationError = validationError;
      });
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: TextField(
            controller: _controller,
            onChanged: _handleValueChange,
            style: TextStyle(
              color: widget._textColor,
            ),
          ),
        ),
        if (_validationError != null)
          SizedBox(
            width: IconTheme.of(context).size,
            height: IconTheme.of(context).size,
            child: Tooltip(
              message: _validationError,
              child: Icon(
                Icons.warning_rounded,
                color: widget._errorColor,
              ),
            ),
          ),
      ],
    );
  }
}
