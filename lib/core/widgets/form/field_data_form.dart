import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/widgets/form/async_action_button.dart';
import 'package:sss_computing_client/core/widgets/form/compund_field_data_validation.dart';
import 'package:sss_computing_client/core/widgets/form/form_field_group.dart';
///
/// Form that is constructed from list of [FieldData].
class FieldDataForm extends StatefulWidget {
  final String _label;
  final List<FieldData> _fieldDatas;
  final List<CompoundFieldDataValidation> _compundValidations;
  final Future<ResultF<List<FieldData>>> Function(List<FieldData>)? _onSave;
  ///
  /// Creates form that is constructed from list of [FieldData].
  ///
  ///   [label] – title for form.
  ///   [fieldDatas] – list of field datas from which form is built.
  ///
  ///   [compundValidations] used for validation
  /// based on values ​​of different fields.
  ///
  ///   [onSave] callback is called when new field datas is saved.
  const FieldDataForm({
    super.key,
    required String label,
    required List<FieldData> fieldDatas,
    List<CompoundFieldDataValidation> compundValidations = const [],
    Future<ResultF<List<FieldData>>> Function(List<FieldData>)? onSave,
  })  : _label = label,
        _fieldDatas = fieldDatas,
        _compundValidations = compundValidations,
        _onSave = onSave;
  //
  @override
  State<FieldDataForm> createState() => _FieldDataFormState();
}
///
class _FieldDataFormState extends State<FieldDataForm> {
  final _formKey = GlobalKey<FormState>();
  late bool _isSaving;
  //
  @override
  void initState() {
    _isSaving = false;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAnyFieldChanged = widget._fieldDatas
        .where(
          (data) => data.isChanged,
        )
        .isNotEmpty;
    final isFormValid = _isFormValid();
    const buttonHeight = 40.0;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                FormFieldGroup(
                  name: widget._label,
                  fieldDatas: widget._fieldDatas,
                  compoundValidationCases: widget._compundValidations,
                  onCancelled: () => setState(() {
                    return;
                  }),
                  onChanged: () => setState(() {
                    return;
                  }),
                  onSaved: () => setState(() {
                    return;
                  }),
                  onSubmitted: isFormValid ? _trySaveData : null,
                ),
                if (_isSaving)
                  Container(
                    color: theme.colorScheme.surface.withOpacity(0.75),
                  ),
              ],
            ),
          ),
          AsyncActionButton(
            height: buttonHeight,
            label: const Localized('Save').v,
            onPressed: isAnyFieldChanged && isFormValid ? _trySaveData : null,
          ),
        ],
      ),
    );
  }
  ///
  void _updateFieldsWithNewData(List<FieldData> newFields) {
    final newValues = {
      for (final field in newFields) field.id: field.controller.text,
    };
    widget._fieldDatas
        .where((field) => newValues.containsKey(field.id))
        .forEach(
      (field) {
        final newValue = newValues[field.id]!;
        field.refreshWith(newValue);
        field.controller.text = newValue;
      },
    );
  }
  //
  Future<void> _trySaveData() async {
    setState(() {
      _isSaving = true;
    });
    final onSave = widget._onSave;
    if (onSave != null) {
      switch (await onSave(widget._fieldDatas)) {
        case Ok(value: final newFields):
          _updateFieldsWithNewData(newFields);
          _formKey.currentState?.save();
        case Err(:final error):
          const Log('FieldDataForm | _trySaveData').error(error);
          _showErrorMessage(error.message);
      }
    }
    setState(() {
      _isSaving = false;
    });
  }
  //
  bool _isFormValid() => _formKey.currentState?.validate() ?? false;
  //
  void _showErrorMessage(String message) {
    if (!mounted) return;
    BottomMessage.error(message: message).show(context);
  }
}
