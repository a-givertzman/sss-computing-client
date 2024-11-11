import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/widgets/form/compound_field_data_validation.dart';
import 'package:sss_computing_client/core/widgets/form/form_field_group.dart';
///
/// Section of form for freight container.
class ContainerFormSection extends StatelessWidget {
  final List<FieldData> _fieldDataList;
  final String _title;
  final List<CompoundFieldDataValidation> _compoundValidationCases;
  final void Function()? _onCancelled;
  final void Function()? _onChanged;
  final void Function()? _onSaved;
  final void Function()? _onSubmitted;
  final Widget? _sideWidget;
  ///
  /// Creates section of form for freight container.
  ///
  /// * [fieldDataList] - list of fields data.
  /// * [title] - title of section.
  /// * [compoundValidationCases] - list of compound validation cases.
  /// * [onCancelled] - calls on field cancel.
  /// * [onChanged] - calls on field change.
  /// * [onSaved] - calls on field save.
  /// * [onSubmitted] - calls on field submit.
  /// * [sideWidget] - side widget displayed on right side of section.
  const ContainerFormSection({
    super.key,
    List<FieldData<dynamic>> fieldDataList = const [],
    required String title,
    List<CompoundFieldDataValidation> compoundValidationCases = const [],
    void Function()? onCancelled,
    void Function()? onChanged,
    void Function()? onSaved,
    void Function()? onSubmitted,
    Widget? sideWidget,
  })  : _fieldDataList = fieldDataList,
        _compoundValidationCases = compoundValidationCases,
        _onCancelled = onCancelled,
        _onChanged = onChanged,
        _onSaved = onSaved,
        _onSubmitted = onSubmitted,
        _sideWidget = sideWidget,
        _title = title;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blockPadding = const Setting('blockPadding').toDouble;
    final sideWidget = _sideWidget;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _title,
          style: theme.textTheme.bodyLarge,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: FormFieldGroup(
                  fieldDataList: _fieldDataList,
                  compoundValidationCases: _compoundValidationCases,
                  onCancelled: _onCancelled,
                  onChanged: _onChanged,
                  onSaved: _onSaved,
                  onSubmitted: _onSubmitted,
                ),
              ),
              SizedBox(width: blockPadding),
              sideWidget != null ? Expanded(child: sideWidget) : const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
