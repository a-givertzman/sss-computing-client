import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/field/field_data.dart';
import 'package:sss_computing_client/presentation/strength/widgets/ShipParameters/async_action_button.dart';
import 'package:sss_computing_client/presentation/strength/widgets/ShipParameters/cancellation_button.dart';
import 'package:sss_computing_client/presentation/strength/widgets/ShipParameters/confirmation_dialog.dart';
import 'package:sss_computing_client/presentation/strength/widgets/ShipParameters/field_group.dart';

class ShipParameters extends StatefulWidget {
  final List<FieldData> _fieldsData;
  final Future<ResultF<List<FieldData>>> Function()? _onSave;

  const ShipParameters({
    super.key,
    required List<FieldData> fieldData,
    Future<ResultF<List<FieldData>>> Function()? onSave,
  })  : _onSave = onSave,
        _fieldsData = fieldData;

  @override
  State<ShipParameters> createState() => _ShipParametersState();
}

class _ShipParametersState extends State<ShipParameters> {
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
    const buttonWidth = 158.0;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: Stack(
              children: [
                FieldGroup(
                  groupName: const Localized('Ship Parameteres').v,
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
                    color: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.75),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CancellationButton(
                height: buttonHeight,
                onPressed: isAnyFieldChanged && !_isSaving
                    ? _cancelEditedFields
                    : null,
              ),
              SizedBox(width: blockPadding),
              AsyncActionButton(
                height: buttonHeight,
                width: buttonWidth,
                label: const Localized('Save').v,
                onPressed: isAnyFieldChanged
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
  void _cancelEditedFields() {
    setState(() {
      for (final data in _fieldsData) {
        data.cancel();
      }
    });
  }

  ///
  /// Show message with info icon
  void _showInfoMessage(BuildContext context, String message) {
    _showSnackBarMessage(
      context,
      message,
      Icon(
        Icons.info_outline_rounded,
        color: Theme.of(context).colorScheme.primary,
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
                color: theme.colorScheme.onBackground,
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
    if (_isFormValid()) {
      final isSaveSubmitted = await showDialog<bool>(
        context: context,
        builder: (_) => ConfirmationDialog(
          title: Text(const Localized('Data saving').v),
          content: Text(
            const Localized(
              'Data will be persisted on the server. Do you want to proceed?',
            ).v,
          ),
          confirmationButtonLabel: const Localized('Save').v,
        ),
      );
      if (isSaveSubmitted ?? false) {
        final onSave = widget._onSave;
        if (onSave != null) {
          switch (await onSave()) {
            case Ok(value: final newFields):
              _updateFieldsWithNewData(newFields);
              _formKey.currentState?.save();
              if (context.mounted) {
                _showInfoMessage(context, const Localized('Data saved').v);
              }
            case Err(:final error):
              if (context.mounted) {
                _showErrorMessage(context, error.message);
              }
          }
        }
      }
    } else {
      _showErrorMessage(
        context,
        const Localized('Please, fix all errors before saving!').v,
      );
    }
    setState(() {
      _isSaving = false;
    });
  }

  ///
  bool _isFormValid() => _formKey.currentState?.validate() ?? false;
}
