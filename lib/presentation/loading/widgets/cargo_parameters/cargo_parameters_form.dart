import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_parameters/async_action_button.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_parameters/cancellation_button.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_parameters/field_group.dart';
///
class CargoParametersForm extends StatefulWidget {
  final List<FieldData> _fieldsData;
  final Future<ResultF<List<FieldData>>> Function(List<FieldData>)? _onSave;
  final void Function()? _onClose;
  const CargoParametersForm({
    super.key,
    required List<FieldData> fieldData,
    Future<ResultF<List<FieldData>>> Function(List<FieldData>)? onSave,
    void Function()? onClose,
  })  : _fieldsData = fieldData,
        _onSave = onSave,
        _onClose = onClose;
  @override
  State<CargoParametersForm> createState() => _CargoParametersFormState();
}
///
class _CargoParametersFormState extends State<CargoParametersForm> {
  final _formKey = GlobalKey<FormState>();
  late List<FieldData> _fieldsData;
  late bool _isSaving;
  @override
  void initState() {
    _fieldsData = widget._fieldsData;
    _isSaving = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final isAnyFieldChanged =
        _fieldsData.where((data) => data.isChanged).isNotEmpty;
    const buttonHeight = 40.0;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                FieldGroup(
                  groupName: const Localized('Cargo parameters').v,
                  fieldsData: _fieldsData,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CancellationButton(
                height: buttonHeight,
                onPressed: widget._onClose,
                label: const Localized('Закрыть').v,
              ),
              SizedBox(width: blockPadding),
              AsyncActionButton(
                height: buttonHeight,
                label: const Localized('Save').v,
                onPressed: isAnyFieldChanged && _isFormValid()
                    ? () async => _trySaveData(context)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
  ///
  /// Show message with info icon
  void _showErrorMessage(BuildContext context, String message) {
    _showSnackBarMessage(
      context,
      message,
      Icon(
        Icons.warning_amber_rounded,
        color: Theme.of(context).stateColors.error,
      ),
    );
  }
  ///
  void _showSnackBarMessage(BuildContext context, String message, Icon icon) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.cardColor,
        content: Row(
          children: [
            icon,
            SizedBox(width: const Setting('padding').toDouble),
            Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
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
          if (context.mounted) {
            _showErrorMessage(context, error.message);
          }
      }
    }
    setState(() {
      _isSaving = false;
    });
  }
  ///
  bool _isFormValid() => _formKey.currentState?.validate() ?? false;
}
