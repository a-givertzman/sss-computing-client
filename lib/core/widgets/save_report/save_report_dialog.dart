import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/extensions/strings.dart';
import 'package:sss_computing_client/core/validation/file_name_validation_case.dart';
import 'package:sss_computing_client/core/validation/required_validation_case.dart';
import 'package:sss_computing_client/core/widgets/disabled_widget.dart';
import 'package:sss_computing_client/core/widgets/save_report/path_form_field.dart';
///
/// Dialog for saving report for project.
class SaveReportDialog extends StatefulWidget {
  final ({String path, String name}) Function(String path, String name) _onSave;
  ///
  /// Creates dialog for saving report for project.
  ///
  /// To handle returned values [onSave] callback cam be used.
  const SaveReportDialog({
    super.key,
    required ({String path, String name}) Function(
      String path,
      String name,
    ) onSave,
  }) : _onSave = onSave;
  //
  @override
  State<SaveReportDialog> createState() => _SaveReportDialogState();
}
//
class _SaveReportDialogState extends State<SaveReportDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _pathController;
  late final TextEditingController _fileNameController;
  late bool _isLoading;
  //
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _pathController = TextEditingController();
    _fileNameController = TextEditingController(text: _getDefaultFileName());
    _isLoading = false;
    super.initState();
  }
  //
  @override
  void dispose() {
    _pathController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return DisabledWidget(
      disabled: _isLoading,
      child: AlertDialog(
        title: Text(const Localized('Enter report details').v),
        content: SizedBox(
          width: const Setting('formFieldWidth').toDouble * 2,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PathFormField(
                  label: const Localized(
                    'Report save path',
                  ).v,
                  helperMessage: const Localized(
                    'Choose directory to save report',
                  ).v,
                  validator: _validatePath,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: _onPathChanged,
                  onSaved: (_) => _onSave(),
                  onPickStarted: _handlePathPickStarted,
                  onPickFinished: _handlePathPickFinished,
                  onError: (errorMessage) => _showErrorMessage(
                    const Localized(
                      'Failed to pick path',
                    ).v,
                  ),
                ),
                SizedBox(height: padding),
                TextFormField(
                  controller: _fileNameController,
                  decoration: InputDecoration(
                    labelText: const Localized(
                      'Report file name',
                    ).v,
                    suffixText:
                        '.${const Setting('reportExtension').toString()}',
                  ),
                  validator: _validateFileName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: _onFileNameChanged,
                  onSaved: (_) => _onSave(),
                ),
              ],
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
      ),
    );
  }
  //
  bool get _isFormValid => _formKey.currentState?.validate() ?? false;
  //
  void _handlePathPickStarted() => setState(() {
        _isLoading = true;
      });
  //
  void _handlePathPickFinished() => setState(() {
        _isLoading = false;
      });
  //
  void _onPathChanged(String? value) => setState(() {
        _pathController.text = value ?? '';
      });
  //
  void _onFileNameChanged(String value) => setState(() {
        return;
      });
  //
  String? _validatePath(String? value) {
    final validateMessage = const Validator(cases: [
      RequiredValidationCase(),
    ]).editFieldValidator(value);
    return validateMessage != null ? Localized(validateMessage).v : null;
  }
  //
  String? _validateFileName(String? value) {
    final validateMessage = const Validator(cases: [
      RequiredValidationCase(),
      MaxLengthValidationCase(64),
      FileNameValidationCase(),
    ]).editFieldValidator(value);
    return validateMessage != null ? Localized(validateMessage).v : null;
  }
  //
  void _onSave() {
    if (!_isFormValid) return;
    final result = widget._onSave(
      _pathController.text.trim(),
      _fileNameController.text.trim(),
    );
    Navigator.of(context).pop(result);
  }
  //
  String _getDefaultFileName() {
    final notSafeSymbols = RegExp('[^A-Za-z0-9_]');
    final namePrefix = const Setting('reportNameDefaultPrefix').toString();
    return [
      namePrefix,
      DateTime.now().toIso8601String().substring(0, 16),
    ].join('_').replaceAll(notSafeSymbols, '_');
  }
  //
  void _showErrorMessage(String message) {
    if (!mounted) return;
    final durationMs = const Setting('errorMessageDisplayDuration').toInt;
    BottomMessage.error(
      message: message.truncate(),
      displayDuration: Duration(milliseconds: durationMs),
    ).show(context);
  }
}
