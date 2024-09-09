import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/widgets/form/async_action_button.dart';
import 'package:sss_computing_client/core/widgets/form/compund_field_data_validation.dart';
import 'package:sss_computing_client/core/widgets/form/form_field_group.dart';
///
class FieldDataForm extends StatefulWidget {
  final String _label;
  final List<FieldData> _fieldsData;
  final List<CompoundFieldDataValidation> _compundValidations;
  final Future<ResultF<List<FieldData>>> Function(List<FieldData>)? _onSave;
  ///
  const FieldDataForm({
    super.key,
    required String label,
    required List<FieldData> fieldData,
    List<CompoundFieldDataValidation> compundValidations = const [],
    Future<ResultF<List<FieldData>>> Function(List<FieldData>)? onSave,
    void Function()? onClose,
  })  : _label = label,
        _fieldsData = fieldData,
        _compundValidations = compundValidations,
        _onSave = onSave;
  //
  @override
  State<FieldDataForm> createState() => _FieldDataFormState();
}
///
class _FieldDataFormState extends State<FieldDataForm> {
  final _formKey = GlobalKey<FormState>();
  late List<FieldData> _fieldsData;
  late bool _isSaving;
  //
  @override
  void initState() {
    _isSaving = false;
    _fieldsData = widget._fieldsData;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final isAnyFieldChanged =
        _fieldsData.where((data) => data.isChanged).isNotEmpty;
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
                  groupName: widget._label,
                  fieldsData: _fieldsData,
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
                ),
                if (_isSaving)
                  Container(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(0.75),
                  ),
              ],
            ),
          ),
          AsyncActionButton(
            height: buttonHeight,
            label: const Localized('Save').v,
            onPressed: isAnyFieldChanged && _isFormValid()
                ? () async => _trySaveData(context)
                : null,
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
    _fieldsData
        .where((field) => newValues.containsKey(field.id))
        .forEach((field) {
      final newValue = newValues[field.id]!;
      field.refreshWith(newValue);
      field.controller.text = newValue;
    });
  }
  ///
  Future<void> _trySaveData(BuildContext context) async {
    setState(() {
      _isSaving = true;
    });
    final onSave = widget._onSave;
    if (onSave != null) {
      switch (await onSave(_fieldsData)) {
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
