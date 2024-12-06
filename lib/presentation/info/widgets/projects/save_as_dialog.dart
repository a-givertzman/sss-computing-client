import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/validation/required_validation_case.dart';
///
/// Dialog for saving project with custom name.
class SaveAsDialog extends StatefulWidget {
  final void Function(String name) _onSave;
  ///
  /// Creates dialog for saving project with custom name.
  ///
  /// [onSave] - callback for saving project on name submit.
  const SaveAsDialog({
    super.key,
    required void Function(String) onSave,
  }) : _onSave = onSave;
  @override
  State<SaveAsDialog> createState() => _SaveAsDialogState();
}
//
class _SaveAsDialogState extends State<SaveAsDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _controller;
  late final Validator _validator;
  //
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _controller = TextEditingController();
    _validator = const Validator(cases: [
      RequiredValidationCase(),
      MaxLengthValidationCase(64),
    ]);
    super.initState();
  }
  //
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(const Localized('Enter project details').v),
      content: SizedBox(
        width: const Setting('formFieldWidth').toDouble,
        child: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            controller: _controller,
            onChanged: _onValueChanged,
            validator: (value) => _validator.editFieldValidator(value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(const Localized('Cancel').v),
        ),
        TextButton(
          onPressed: _isFormValid ? _onSave : null,
          child: Text(const Localized('Ok').v),
        ),
      ],
    );
  }
  //
  bool get _isFormValid => _formKey.currentState?.validate() ?? false;
  //
  void _onValueChanged(String value) {
    setState(() {
      return;
    });
  }
  //
  void _onSave() {
    if (_isFormValid) {
      Navigator.of(context).pop();
      widget._onSave(_controller.text.trim());
    }
  }
}
