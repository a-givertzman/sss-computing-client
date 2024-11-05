import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/number_math_relation/greater_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container_type.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/waypoint.dart';
import 'package:sss_computing_client/core/validation/int_validation_case.dart';
import 'package:sss_computing_client/core/validation/number_math_relation_validation_case.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/validation/required_validation_case.dart';
import 'package:sss_computing_client/core/widgets/form/async_action_button.dart';
import 'package:sss_computing_client/core/widgets/form/compound_field_data_validation.dart';
import 'package:sss_computing_client/core/widgets/form/form_field_group.dart';
import 'package:sss_computing_client/presentation/container_cargo/widgets/container_size_code_dropdown.dart';
import 'package:sss_computing_client/presentation/container_cargo/widgets/date_format_extenstion.dart';
import 'package:sss_computing_client/presentation/container_cargo/widgets/read_only_text_field.dart';
import 'package:sss_computing_client/presentation/container_cargo/widgets/voyage_waypoint_dropdown.dart';
///
class ContainerCargoBody extends StatefulWidget {
  final Future<ResultF<List<FieldData>>> Function(List<FieldData>) _onSave;
  final List<Waypoint> _waypoints;
  final FreightContainer? _container;
  ///
  /// TODO: update doc
  ///
  /// [onSave] callbacks run after saving edited data
  ///
  /// [container] is instance of [Cargo] to be configured.
  /// Data for the the [container] will be fetched if [fetchData] is true.
  const ContainerCargoBody({
    super.key,
    required Future<ResultF<List<FieldData>>> Function(List<FieldData>) onSave,
    required List<Waypoint> waypoints,
    FreightContainer? container,
  })  : _onSave = onSave,
        _waypoints = waypoints,
        _container = container;
  //
  @override
  State<ContainerCargoBody> createState() => _ContainerCargoBodyState();
}
///
class _ContainerCargoBodyState extends State<ContainerCargoBody> {
  late final Map<String, FieldData> _fieldDataList;
  final _formKey = GlobalKey<FormState>();
  late bool _isSaving;
  //
  @override
  // ignore: long-method
  void initState() {
    _isSaving = false;
    _fieldDataList = {
      'maxGrossWeight': FieldData<double>(
        id: 'maxGrossWeight',
        label: const Localized('Max gross mass').v,
        toValue: (text) => double.tryParse(text) ?? 0.0,
        toText: (value) => value.toStringAsFixed(2),
        initialValue: 36.00,
        validator: Validator(cases: [
          const RequiredValidationCase(),
          const RealValidationCase(),
          NumberMathRelationValidationCase(
            relation: const GreaterThanOrEqualTo(),
            secondValue: 0.0,
            toValue: (text) => double.tryParse(text) ?? 0.0,
            customMessage: const Localized(
              'Max gross mass cannot be negative',
            ).v,
          ),
        ]),
      ),
      'grossWeight': FieldData<double>(
        id: 'grossWeight',
        label: const Localized('Gross mass').v,
        toValue: (text) => double.tryParse(text) ?? 0.0,
        toText: (value) => value.toStringAsFixed(2),
        initialValue: widget._container?.grossWeight ?? 0.0,
        validator: Validator(cases: [
          const RequiredValidationCase(),
          const RealValidationCase(),
          NumberMathRelationValidationCase(
            relation: const GreaterThanOrEqualTo(),
            secondValue: 0.0,
            toValue: (text) => double.tryParse(text) ?? 0.0,
            customMessage: const Localized(
              'Gross mass cannot be negative',
            ).v,
          ),
        ]),
      ),
      'tareWeight': FieldData<double>(
        id: 'tareWeight',
        label: const Localized('Tare mass').v,
        toValue: (text) => double.tryParse(text) ?? 0.0,
        toText: (value) => value.toStringAsFixed(2),
        initialValue: widget._container?.tareWeight ?? 0.0,
        validator: Validator(cases: [
          const RequiredValidationCase(),
          const RealValidationCase(),
          NumberMathRelationValidationCase(
            relation: const GreaterThanOrEqualTo(),
            secondValue: 0.0,
            toValue: (text) => double.tryParse(text) ?? 0.0,
            customMessage: const Localized(
              'Tare mass cannot be negative',
            ).v,
          ),
        ]),
      ),
      'typeCode': FieldData<String>(
        id: 'typeCode',
        label: const Localized('Type code').v,
        toValue: (text) => text,
        toText: (value) => value,
        initialValue: 'GP',
        validator: const Validator(cases: [
          RequiredValidationCase(),
          MinLengthValidationCase(2),
          MaxLengthValidationCase(2),
        ]),
      ),
      'ownerCode': FieldData<String>(
        id: 'ownerCode',
        label: const Localized('Owner code').v,
        toValue: (text) => text,
        toText: (value) => value,
        initialValue: 'OWN',
        validator: const Validator(cases: [
          RequiredValidationCase(),
          MinLengthValidationCase(3),
          MaxLengthValidationCase(3),
        ]),
      ),
      'serialCode': FieldData<int>(
        id: 'serialCode',
        label: const Localized('Serial number').v,
        toValue: (text) => int.tryParse(text) ?? 0,
        toText: (value) => '$value'.padLeft(6, '0'),
        initialValue: widget._container?.serialCode ?? 0,
        validator: const Validator(cases: [
          IntValidationCase(),
          RequiredValidationCase(),
          MinLengthValidationCase(6),
          MaxLengthValidationCase(6),
        ]),
      ),
      'checkDigit': FieldData<int>(
        id: 'checkDigit',
        label: const Localized('Check digit').v,
        toValue: (text) => int.tryParse(text) ?? 0,
        toText: (value) => '$value',
        initialValue: 0, // TODO
        validator: const Validator(cases: [
          IntValidationCase(),
          RequiredValidationCase(),
          MinLengthValidationCase(1),
          MaxLengthValidationCase(1),
        ]),
      ),
      'lengthCode': FieldData<String>(
        id: 'lengthCode',
        label: const Localized('Length').v,
        toValue: (text) => text,
        toText: (value) => value,
        initialValue: widget._container?.type.sizeCode[0] ?? '2',
        buildFormField: (value, updateValue) => ContainerSizeCodeDropdown(
          initialValue: value,
          onTypeChanged: updateValue,
          codeIndex: 0,
          formatCode: (code) => switch (code) {
            '2' => const Localized('20ft').v,
            '3' => const Localized('30ft').v,
            '4' => const Localized('40ft').v,
            _ => const Localized('Unknown length code').v,
          },
        ),
      ),
      'heightCode': FieldData<String>(
        id: 'heightCode',
        label: const Localized('Height').v,
        toValue: (text) => text,
        toText: (value) => value,
        initialValue: widget._container?.type.sizeCode[1] ?? '2',
        buildFormField: (value, updateValue) => ContainerSizeCodeDropdown(
          initialValue: value,
          onTypeChanged: updateValue,
          codeIndex: 1,
          formatCode: (code) => switch (code) {
            '0' => const Localized('Low standard').v,
            '2' => const Localized('Standard').v,
            '5' => const Localized('High cube').v,
            _ => const Localized('Unknown height code').v,
          },
        ),
      ),
      'pol': FieldData<Waypoint?>(
        id: 'pol',
        label: const Localized('POL').v,
        toValue: (text) =>
            widget._waypoints.firstWhereOrNull((w) => w.portCode == text),
        toText: (value) => value?.portCode ?? '–',
        initialValue: widget._waypoints
            .sorted(
              (a, b) => a.eta.compareTo(b.eta),
            )
            .firstOrNull,
        buildFormField: (value, updateValue) => VoyageWaypointDropdown(
          initialValue: widget._waypoints.firstWhereOrNull(
            (w) => w.portCode == value,
          ),
          values: widget._waypoints,
          onWaypointChanged: (w) => updateValue(w.portCode),
        ),
      ),
      'pod': FieldData<Waypoint?>(
        id: 'pod',
        label: const Localized('POD').v,
        toValue: (text) =>
            widget._waypoints.firstWhereOrNull((w) => w.portCode == text),
        toText: (value) => value?.portCode ?? '–',
        initialValue: widget._waypoints
            .sorted(
              (a, b) => a.eta.compareTo(b.eta),
            )
            .lastOrNull,
        buildFormField: (value, updateValue) => VoyageWaypointDropdown(
          initialValue: widget._waypoints.firstWhereOrNull(
            (w) => w.portCode == value,
          ),
          values: widget._waypoints,
          onWaypointChanged: (w) => updateValue(w.portCode),
        ),
      ),
      'containersNumber': FieldData<int>(
        id: 'containersNumber',
        label: const Localized('Number of containers').v,
        toValue: (text) => int.tryParse(text) ?? 1,
        toText: (value) => '$value',
        initialValue: 1,
        validator: Validator(cases: [
          const RequiredValidationCase(),
          const IntValidationCase(),
          NumberMathRelationValidationCase(
            relation: const GreaterThanOrEqualTo(),
            secondValue: 0,
            toValue: (text) => int.tryParse(text) ?? 0,
            customMessage: const Localized(
              'Number of containers cannot be negative',
            ).v,
          ),
        ]),
      ),
    };
    super.initState();
  }
  //
  @override
  void dispose() {
    for (final fieldData in _fieldDataList.values) {
      fieldData.controller.dispose();
    }
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blockPadding = const Setting('blockPadding').toDouble;
    final formWidth = const Setting('formStandardWidth').toDouble;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(blockPadding),
        child: SizedBox(
          width: formWidth * 2,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: FormFieldGroup(
                              nameAlignment: TextAlign.left,
                              name: '${const Localized('Size and type').v}:',
                              fieldDataList: [
                                _fieldDataList['lengthCode']!,
                                _fieldDataList['heightCode']!,
                                _fieldDataList['typeCode']!,
                              ],
                              onCancelled: () => setState(() {
                                return;
                              }),
                              onChanged: () => setState(() {
                                return;
                              }),
                              onSaved: () => setState(() {
                                return;
                              }),
                              onSubmitted: _isFormValid() ? _trySaveData : null,
                            ),
                          ),
                          SizedBox(width: blockPadding),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 44.0),
                                ReadOnlyTextField(
                                  label: const Localized('Iso code').v,
                                  toListen: [
                                    _fieldDataList['lengthCode']!.controller,
                                    _fieldDataList['heightCode']!.controller,
                                  ],
                                  getValue: () {
                                    final lengthCodeData =
                                        _fieldDataList['lengthCode']!;
                                    final heightCodeData =
                                        _fieldDataList['heightCode']!;
                                    return FreightContainerType.values
                                            .firstWhereOrNull((v) =>
                                                v.sizeCode ==
                                                '${lengthCodeData.controller.text}${heightCodeData.controller.text}')
                                            ?.isoCode ??
                                        const Localized('Unknown size').v;
                                  },
                                ),
                                ReadOnlyTextField(
                                  label: const Localized('Size code').v,
                                  toListen: [
                                    _fieldDataList['lengthCode']!.controller,
                                    _fieldDataList['heightCode']!.controller,
                                  ],
                                  getValue: () {
                                    final lengthCodeData =
                                        _fieldDataList['lengthCode']!;
                                    final heightCodeData =
                                        _fieldDataList['heightCode']!;
                                    return '${lengthCodeData.controller.text}${heightCodeData.controller.text}';
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: FormFieldGroup(
                              nameAlignment: TextAlign.left,
                              name: '${const Localized('Mass').v}:',
                              fieldDataList: [
                                _fieldDataList['grossWeight']!,
                                _fieldDataList['maxGrossWeight']!,
                                _fieldDataList['tareWeight']!,
                              ],
                              onCancelled: () => setState(() {
                                return;
                              }),
                              onChanged: () => setState(() {
                                return;
                              }),
                              onSaved: () => setState(() {
                                return;
                              }),
                              onSubmitted: _isFormValid() ? _trySaveData : null,
                              compoundValidationCases: [
                                CompoundFieldDataValidation(
                                  ownId: 'maxGrossWeight',
                                  otherId: 'grossWeight',
                                  validateValues: (maxGrossMass, grossMass) =>
                                      (double.tryParse(maxGrossMass) ?? 0.0) >=
                                              (double.tryParse(grossMass) ??
                                                  0.0)
                                          ? const Ok(null)
                                          : Err(Failure(
                                              message: const Localized(
                                                'Max gross mass must be greater than or equal to gross mass',
                                              ).v,
                                              stackTrace: StackTrace.current,
                                            )),
                                ),
                                CompoundFieldDataValidation(
                                  ownId: 'grossWeight',
                                  otherId: 'tareWeight',
                                  validateValues: (maxGrossMass, grossMass) =>
                                      (double.tryParse(maxGrossMass) ?? 0.0) >=
                                              (double.tryParse(grossMass) ??
                                                  0.0)
                                          ? const Ok(null)
                                          : Err(Failure(
                                              message: const Localized(
                                                'Gross mass must be greater than or equal to tare mass',
                                              ).v,
                                              stackTrace: StackTrace.current,
                                            )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: blockPadding),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 44.0),
                                ReadOnlyTextField(
                                  label: const Localized('Net mass').v,
                                  toListen: [
                                    _fieldDataList['grossWeight']!.controller,
                                    _fieldDataList['tareWeight']!.controller,
                                  ],
                                  getValue: () {
                                    final grossMassData =
                                        _fieldDataList['grossWeight']!;
                                    final tareMassData =
                                        _fieldDataList['tareWeight']!;
                                    return (grossMassData.toValue(
                                              grossMassData.controller.text,
                                            ) -
                                            tareMassData.toValue(
                                              tareMassData.controller.text,
                                            ))
                                        .toStringAsFixed(2);
                                  },
                                ),
                                ReadOnlyTextField(
                                  label: const Localized('Max net mass').v,
                                  toListen: [
                                    _fieldDataList['maxGrossWeight']!
                                        .controller,
                                    _fieldDataList['tareWeight']!.controller,
                                  ],
                                  getValue: () {
                                    final maxGrossMassData =
                                        _fieldDataList['maxGrossWeight']!;
                                    final tareMassData =
                                        _fieldDataList['tareWeight']!;
                                    return (maxGrossMassData.toValue(
                                              maxGrossMassData.controller.text,
                                            ) -
                                            tareMassData.toValue(
                                              tareMassData.controller.text,
                                            ))
                                        .toStringAsFixed(2);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: FormFieldGroup(
                              nameAlignment: TextAlign.left,
                              name: '${const Localized('Name').v}:',
                              fieldDataList: [
                                _fieldDataList['ownerCode']!,
                                _fieldDataList['serialCode']!,
                                _fieldDataList['checkDigit']!,
                              ],
                              onCancelled: () => setState(() {
                                return;
                              }),
                              onChanged: () => setState(() {
                                return;
                              }),
                              onSaved: () => setState(() {
                                return;
                              }),
                              onSubmitted: _isFormValid() ? _trySaveData : null,
                            ),
                          ),
                          SizedBox(width: blockPadding),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 44.0),
                                ReadOnlyTextField(
                                  label: const Localized('Container code').v,
                                  toListen: [
                                    _fieldDataList['ownerCode']!.controller,
                                    _fieldDataList['serialCode']!.controller,
                                    _fieldDataList['checkDigit']!.controller,
                                  ],
                                  getValue: () {
                                    final serialNumberData =
                                        _fieldDataList['serialCode']!;
                                    final ownerCodeData =
                                        _fieldDataList['ownerCode']!;
                                    final checkDigitData =
                                        _fieldDataList['checkDigit']!;
                                    final containerCode = [
                                      ownerCodeData.controller.text,
                                      'U',
                                      serialNumberData.controller.text,
                                      checkDigitData.controller.text,
                                    ].join(' ');
                                    return containerCode;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: FormFieldGroup(
                              nameAlignment: TextAlign.left,
                              name: '${const Localized('Way').v}:',
                              fieldDataList: [
                                _fieldDataList['pol']!,
                                _fieldDataList['pod']!,
                              ],
                              onCancelled: () => setState(() {
                                return;
                              }),
                              onChanged: () => setState(() {
                                return;
                              }),
                              onSaved: () => setState(() {
                                return;
                              }),
                              onSubmitted: _isFormValid() ? _trySaveData : null,
                              compoundValidationCases: [
                                CompoundFieldDataValidation(
                                  ownId: 'pol',
                                  otherId: 'pod',
                                  validateValues: (pol, pod) => widget
                                              ._waypoints
                                              .firstWhere(
                                                  (w) => w.portCode == pol)
                                              .etd
                                              .compareTo(widget._waypoints
                                                  .firstWhere(
                                                    (w) => w.portCode == pod,
                                                  )
                                                  .etd) ==
                                          -1
                                      ? const Ok(null)
                                      : Err(Failure(
                                          message: const Localized(
                                            'POD must be after POL',
                                          ).v,
                                          stackTrace: StackTrace.current,
                                        )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: blockPadding),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 44.0),
                                ReadOnlyTextField(
                                  label: const Localized('POL timing').v,
                                  toListen: [_fieldDataList['pol']!.controller],
                                  getValue: () {
                                    final polData = _fieldDataList['pol']!;
                                    final pol =
                                        polData.toValue(polData.controller.text)
                                            as Waypoint;
                                    return '${pol.eta.formatRU()} – ${pol.etd.formatRU()}';
                                  },
                                ),
                                ReadOnlyTextField(
                                  label: const Localized('POD timing').v,
                                  toListen: [_fieldDataList['pod']!.controller],
                                  getValue: () {
                                    final podData = _fieldDataList['pod']!;
                                    final pod =
                                        podData.toValue(podData.controller.text)
                                            as Waypoint;
                                    return '${pod.eta.formatRU()} – ${pod.etd.formatRU()}';
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150.0,
                            child: FormFieldGroup(
                              fieldDataList: [
                                _fieldDataList['containersNumber']!,
                              ],
                              onCancelled: () => setState(() {
                                return;
                              }),
                              onChanged: () => setState(() {
                                return;
                              }),
                              onSaved: () => setState(() {
                                return;
                              }),
                              onSubmitted: _isFormValid() ? _trySaveData : null,
                            ),
                          ),
                          AsyncActionButton(
                            height: 32.0,
                            label: const Localized('Save').v,
                            onPressed: _isFormValid() ? _trySaveData : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isSaving)
                Container(
                  color: theme.colorScheme.surface.withOpacity(0.75),
                ),
            ],
          ),
        ),
      ),
    );
  }
  ///
  void _updateFieldsWithNewData(List<FieldData> newFields) {
    final newValues = {
      for (final field in newFields) field.id: field.controller.text,
    };
    _fieldDataList.values
        .where((field) => newValues.containsKey(field.id))
        .forEach(
      (field) {
        final newValue = newValues[field.id]!;
        field.refreshWith(newValue);
      },
    );
  }
  //
  Future<void> _trySaveData() async {
    setState(() {
      _isSaving = true;
    });
    final onSave = widget._onSave;
    switch (await onSave(_fieldDataList.values.toList())) {
      case Ok(value: final newFields):
        _updateFieldsWithNewData(newFields);
        _formKey.currentState?.save();
      case Err(:final error):
        const Log('FieldDataForm | _trySaveData').error(error);
        _showErrorMessage(error.message);
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
