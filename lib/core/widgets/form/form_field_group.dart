import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/validation/validator_validation_case.dart';
import 'package:sss_computing_client/core/widgets/form/cancellable_custom_field.dart';
import 'package:sss_computing_client/core/widgets/form/cancellable_text_field.dart';
import 'package:sss_computing_client/core/widgets/form/compound_field_data_validation.dart';
///
/// Group of fields for form.
class FormFieldGroup extends StatefulWidget {
  final String? _name;
  final void Function()? _onChanged;
  final void Function()? _onCancelled;
  final void Function()? _onSubmitted;
  final void Function()? _onSaved;
  final List<FieldData> _fieldDataList;
  final List<CompoundFieldDataValidation> _compoundValidationCases;
  final TextAlign _nameAlignment;
  ///
  /// Creates group of fields for form.
  ///
  ///   [name] – title for field group.
  ///   [fieldDataList] – list of fields included in group.
  ///   [compoundValidationCases] used for validation
  /// based on values ​​of different fields.
  ///   [onChanged], 'onCancelled', [onSubmitted] and [onSaved] callbacks
  /// are called when field data changed, cancelled, submitted or saved
  /// respectively.
  const FormFieldGroup({
    super.key,
    String? name,
    required List<FieldData> fieldDataList,
    List<CompoundFieldDataValidation> compoundValidationCases = const [],
    void Function()? onChanged,
    void Function()? onCancelled,
    void Function()? onSubmitted,
    void Function()? onSaved,
    TextAlign nameAlignment = TextAlign.center,
  })  : _name = name,
        _onChanged = onChanged,
        _onCancelled = onCancelled,
        _onSubmitted = onSubmitted,
        _onSaved = onSaved,
        _fieldDataList = fieldDataList,
        _compoundValidationCases = compoundValidationCases,
        _nameAlignment = nameAlignment;
  //
  @override
  State<FormFieldGroup> createState() => _FormFieldGroupState();
}
///
class _FormFieldGroupState extends State<FormFieldGroup> {
  late final ScrollController _scrollController;
  //
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }
  //
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget._name != null) ...[
          Text(
            widget._name!,
            textAlign: widget._nameAlignment,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: blockPadding),
        ],
        Expanded(
          child: FutureBuilder(
            future: Future.wait(widget._fieldDataList.map(
              (field) => field.isSynced
                  ? Future<ResultF>.value(const Ok(null))
                  : field.fetch(),
            )),
            builder: (_, result) => result.hasData
                ? SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollController,
                    child: Column(
                      children: [
                        for (int i = 0;
                            i < widget._fieldDataList.length;
                            i++) ...[
                          switch (result.data![i]) {
                            Ok() =>
                              widget._fieldDataList[i].buildFormField != null
                                  ? _mapDataToCustomField(
                                      widget._fieldDataList[i],
                                    )
                                  : _mapDataToTextField(
                                      widget._fieldDataList[i],
                                    ),
                            Err(:final error) =>
                              widget._fieldDataList[i].buildFormField != null
                                  ? _mapDataToCustomField(
                                      widget._fieldDataList[i],
                                      err: error,
                                    )
                                  : _mapDataToTextField(
                                      widget._fieldDataList[i],
                                      err: error,
                                    ),
                          },
                          if (i == widget._fieldDataList.length - 1)
                            SizedBox(height: padding),
                        ],
                      ],
                    ),
                  )
                : const CupertinoActivityIndicator(),
          ),
        ),
      ],
    );
  }
  //
  CancellableTextField _mapDataToTextField(FieldData data, {Failure? err}) {
    final defaultValidator = data.validator;
    return CancellableTextField(
      label: data.label,
      initialValue: data.toText(data.initialValue),
      controller: data.controller,
      sendError: err != null ? '${err.message}' : null,
      validator: Validator(cases: [
        if (defaultValidator != null)
          ValidatorValidationCase(validator: defaultValidator),
        ...widget._compoundValidationCases
            .where(
              (validationCase) => validationCase.ownId == data.id,
            )
            .map(
              (caseData) => caseData.validationCase(widget._fieldDataList),
            ),
      ]),
      fieldType: data.fieldType,
      onChanged: (value) {
        data.controller.value = TextEditingValue(
          text: value,
          selection: TextSelection.fromPosition(
            TextPosition(offset: data.controller.selection.base.offset),
          ),
        );
        widget._onChanged?.call();
      },
      onCancelled: (_) {
        data.cancel();
        widget._onCancelled?.call();
      },
      onSubmitted: (_) => widget._onSubmitted?.call(),
      onSaved: (_) {
        widget._onSaved?.call();
        return Future.value(const Ok(''));
      },
    );
  }
  //
  CancellableCustomField _mapDataToCustomField(FieldData data, {Failure? err}) {
    final defaultValidator = data.validator;
    return CancellableCustomField(
      label: data.label,
      initialValue: data.toText(data.initialValue),
      buildCustomField: data.buildFormField!,
      controller: data.controller,
      sendError: err != null ? '${err.message}' : null,
      validator: Validator(cases: [
        if (defaultValidator != null)
          ValidatorValidationCase(
            validator: defaultValidator,
          ),
        ...widget._compoundValidationCases
            .where(
              (validationCase) => validationCase.ownId == data.id,
            )
            .map(
              (caseData) => caseData.validationCase(widget._fieldDataList),
            ),
      ]),
      fieldType: data.fieldType,
      onChanged: (value) {
        widget._onChanged?.call();
      },
      onCancelled: (_) {
        data.cancel();
        widget._onCancelled?.call();
      },
      onSaved: (_) {
        widget._onSaved?.call();
        return Future.value(const Ok(''));
      },
    );
  }
}
