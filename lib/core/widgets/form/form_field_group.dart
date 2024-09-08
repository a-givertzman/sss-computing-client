import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/validation/validator_validation_case.dart';
import 'package:sss_computing_client/core/widgets/form/cancelable_field.dart';
import 'package:sss_computing_client/core/widgets/form/compund_field_data_validation.dart';
///
class FormFieldGroup extends StatefulWidget {
  final String _groupName;
  final void Function()? _onChanged;
  final void Function()? _onCancelled;
  final void Function()? _onSaved;
  final List<FieldData> _fieldsData;
  final List<CompoundFieldDataValidation> _compoundValidationCases;
  ///
  const FormFieldGroup({
    super.key,
    required String groupName,
    required List<FieldData> fieldsData,
    List<CompoundFieldDataValidation> compoundValidationCases = const [],
    void Function()? onChanged,
    void Function()? onCancelled,
    void Function()? onSaved,
  })  : _groupName = groupName,
        _onCancelled = onCancelled,
        _onChanged = onChanged,
        _onSaved = onSaved,
        _fieldsData = fieldsData,
        _compoundValidationCases = compoundValidationCases;
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
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Column(
      children: [
        Text(
          widget._groupName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: blockPadding),
        Expanded(
          child: FutureBuilder(
            future: Future.wait(widget._fieldsData.map(
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
                        for (int i = 0; i < widget._fieldsData.length; i++) ...[
                          switch (result.data![i]) {
                            Ok() => _mapDataToField(widget._fieldsData[i]),
                            Err(:final error) => _mapDataToField(
                                widget._fieldsData[i],
                                err: error,
                              ),
                          },
                          if (i == widget._fieldsData.length - 1)
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
  CancelableField _mapDataToField(FieldData data, {Failure? err}) {
    final compoundValidationDatas = widget._compoundValidationCases.where(
      (validationCase) => validationCase.ownId == data.id,
    );
    return CancelableField(
      label: data.label,
      initialValue: data.toText(data.initialValue),
      controller: data.controller,
      sendError: err != null ? '${err.message}' : null,
      validator: Validator(cases: [
        ValidatorValidationCase(validator: data.validator),
        ...compoundValidationDatas.map(
          (caseData) => caseData.validationCase(widget._fieldsData),
        ),
      ]),
      onChanged: (value) {
        data.controller.value = TextEditingValue(
          text: value,
          selection: TextSelection.fromPosition(
            TextPosition(offset: data.controller.selection.base.offset),
          ),
        );
        widget._onChanged?.call();
      },
      onCanceled: (_) {
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
