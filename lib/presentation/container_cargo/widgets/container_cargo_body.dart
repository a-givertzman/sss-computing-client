import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/check_digit.dart';
import 'package:sss_computing_client/core/widgets/form/async_action_button.dart';
import 'package:sss_computing_client/core/widgets/form/cancellable_custom_field.dart';
import 'package:sss_computing_client/core/widgets/form/form_field_group.dart';
enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Orange', Colors.orange),
  grey('Grey', Colors.grey);
  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}
///
class ContainerCargoBody extends StatefulWidget {
  final Future<ResultF<List<FieldData>>> Function(List<FieldData>) _onSave;
  final FreightContainer? _container;
  final bool _fetchData;
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
    FreightContainer? container,
    bool fetchData = false,
  })  : _onSave = onSave,
        _container = container,
        _fetchData = fetchData;
  //
  @override
  State<ContainerCargoBody> createState() => _ContainerCargoBodyState();
}
///
class _ContainerCargoBodyState extends State<ContainerCargoBody> {
  late final List<FieldData> _fieldDataList;
  final _formKey = GlobalKey<FormState>();
  late bool _isSaving;
  //
  @override
  void initState() {
    _isSaving = false;
    _fieldDataList = [
      FieldData<double>(
        id: 'max_gross_mass',
        label: const Localized('Max gross mass').v,
        toValue: (text) => double.tryParse(text) ?? 0.0,
        toText: (value) => value.toStringAsFixed(2),
        initialValue: 30.48,
      ),
      FieldData<double>(
        id: 'gross_mass',
        label: const Localized('Gross mass').v,
        toValue: (text) => double.tryParse(text) ?? 0.0,
        toText: (value) => value.toStringAsFixed(2),
        initialValue: widget._container?.grossWeight ?? 0.0,
      ),
      FieldData<double>(
        id: 'tare_mass',
        label: const Localized('Tare mass').v,
        toValue: (text) => double.tryParse(text) ?? 0.0,
        toText: (value) => value.toStringAsFixed(2),
        initialValue: widget._container?.tareWeight ?? 0.0,
      ),
      FieldData<String>(
        id: 'type_code',
        label: const Localized('Type code').v,
        toValue: (text) => text,
        toText: (value) => value,
        initialValue: 'GP',
      ),
      FieldData<String>(
        id: 'owner_code',
        label: const Localized('Owner code').v,
        toValue: (text) => text,
        toText: (value) => value,
        initialValue: 'OWN',
      ),
      FieldData<int>(
        id: 'serial_number',
        label: const Localized('Serial number').v,
        toValue: (text) => int.tryParse(text) ?? 0,
        toText: (value) => '$value'.padLeft(6, '0'),
        initialValue: widget._container?.serial ?? 0,
      ),
    ];
    super.initState();
  }
  //
  @override
  void dispose() {
    for (final fieldData in _fieldDataList) {
      fieldData.controller.dispose();
    }
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    final isFormValid = _isFormValid();
    return Center(
      child: Padding(
        padding: EdgeInsets.all(blockPadding),
        child: CancellableCustomField(
          controller: TextEditingController(),
          label: 'POL',
          initialValue: '',
          validator: const Validator(cases: [
            MinLengthValidationCase(16),
          ]),
          buildCustomField: (value, updateValue) => DropdownMenu<String>(
            initialSelection: value,
            requestFocusOnTap: true,
            onSelected: (String? color) {
              updateValue(color ?? '');
            },
            dropdownMenuEntries: ColorLabel.values
                .map<DropdownMenuEntry<String>>((ColorLabel color) {
              return DropdownMenuEntry<String>(
                value: color.toString(),
                label: color.label,
                enabled: color.label != 'Grey',
                style: MenuItemButton.styleFrom(
                  foregroundColor: color.color,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
    // return Center(
    //   child: Padding(
    //     padding: EdgeInsets.all(blockPadding),
    //     child: Column(
    //       children: [
    //         Flexible(
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: [
    //               Expanded(
    //                 child: FormFieldGroup(
    //                   name: const Localized('Mass').v,
    //                   fieldDataList: _fieldDataList
    //                       .where((fd) => fd.id.contains('mass'))
    //                       .toList(),
    //                   onCancelled: () => setState(() {
    //                     return;
    //                   }),
    //                   onChanged: () => setState(() {
    //                     return;
    //                   }),
    //                   onSaved: () => setState(() {
    //                     return;
    //                   }),
    //                   onSubmitted: isFormValid ? _trySaveData : null,
    //                 ),
    //               ),
    //               SizedBox(width: blockPadding),
    //               Expanded(
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.stretch,
    //                   children: [
    //                     const SizedBox(height: 44.0),
    //                     ReadOnlyField(
    //                       label: const Localized('Max net mass').v,
    //                       toListen: _fieldDataList
    //                           .where(
    //                             (fd) =>
    //                                 fd.id == 'max_gross_mass' ||
    //                                 fd.id == 'tare_mass',
    //                           )
    //                           .map((fd) => fd.controller)
    //                           .toList(),
    //                       getValue: () {
    //                         final maxGrossMassData = _fieldDataList.firstWhere(
    //                           (fieldData) => fieldData.id == 'max_gross_mass',
    //                         );
    //                         final tareMassData = _fieldDataList.firstWhere(
    //                           (fieldData) => fieldData.id == 'tare_mass',
    //                         );
    //                         return (maxGrossMassData.toValue(
    //                                     maxGrossMassData.controller.text) -
    //                                 tareMassData
    //                                     .toValue(tareMassData.controller.text))
    //                             .toStringAsFixed(2);
    //                       },
    //                     ),
    //                     ReadOnlyField(
    //                       label: const Localized('Net mass').v,
    //                       toListen: _fieldDataList
    //                           .where(
    //                             (fd) =>
    //                                 fd.id == 'gross_mass' ||
    //                                 fd.id == 'tare_mass',
    //                           )
    //                           .map((fd) => fd.controller)
    //                           .toList(),
    //                       getValue: () {
    //                         final grossMassData = _fieldDataList.firstWhere(
    //                           (fieldData) => fieldData.id == 'gross_mass',
    //                         );
    //                         final tareMassData = _fieldDataList.firstWhere(
    //                           (fieldData) => fieldData.id == 'tare_mass',
    //                         );
    //                         return (grossMassData.toValue(
    //                                     grossMassData.controller.text) -
    //                                 tareMassData
    //                                     .toValue(tareMassData.controller.text))
    //                             .toStringAsFixed(2);
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Flexible(
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: [
    //               Expanded(
    //                 child: FormFieldGroup(
    //                   name: const Localized('Name').v,
    //                   fieldDataList: _fieldDataList
    //                       .where((fd) => [
    //                             'type_code',
    //                             'owner_code',
    //                             'serial_number',
    //                           ].any((id) => fd.id == id))
    //                       .toList(),
    //                   onCancelled: () => setState(() {
    //                     return;
    //                   }),
    //                   onChanged: () => setState(() {
    //                     return;
    //                   }),
    //                   onSaved: () => setState(() {
    //                     return;
    //                   }),
    //                   onSubmitted: isFormValid ? _trySaveData : null,
    //                 ),
    //               ),
    //               SizedBox(width: blockPadding),
    //               Expanded(
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.stretch,
    //                   children: [
    //                     const SizedBox(height: 44.0),
    //                     ReadOnlyField(
    //                       label: const Localized('Container code').v,
    //                       toListen: _fieldDataList
    //                           .where(
    //                             (fd) =>
    //                                 fd.id == 'serial_number' ||
    //                                 fd.id == 'owner_code',
    //                           )
    //                           .map((fd) => fd.controller)
    //                           .toList(),
    //                       getValue: () {
    //                         final serialNumberData = _fieldDataList.firstWhere(
    //                           (fieldData) => fieldData.id == 'serial_number',
    //                         );
    //                         final ownerCodeData = _fieldDataList.firstWhere(
    //                           (fieldData) => fieldData.id == 'owner_code',
    //                         );
    //                         final containerCode = [
    //                           '${ownerCodeData.toValue(ownerCodeData.controller.text)}',
    //                           'U',
    //                           serialNumberData.toText(serialNumberData
    //                               .toValue(serialNumberData.controller.text)),
    //                         ].join(' ');
    //                         final checkDigit = switch (
    //                             CheckDigit.fromContainerCode(containerCode)
    //                                 .value()) {
    //                           Ok(:final value) => '$value',
    //                           Err(:final error) => '$error',
    //                         };
    //                         return '$containerCode $checkDigit';
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const Spacer(),
    //         Center(
    //           child: AsyncActionButton(
    //             height: 32.0,
    //             label: const Localized('Save (In dev)').v,
    //             onPressed: null,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
  ///
  bool _isAnyFieldChanged() => _fieldDataList
      .where(
        (data) => data.isChanged,
      )
      .isNotEmpty;
  ///
  void _updateFieldsWithNewData(List<FieldData> newFields) {
    final newValues = {
      for (final field in newFields) field.id: field.controller.text,
    };
    _fieldDataList.where((field) => newValues.containsKey(field.id)).forEach(
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
    switch (await onSave(_fieldDataList)) {
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
///
class ReadOnlyField extends StatefulWidget {
  final String _label;
  final String Function() _getValue;
  final List<TextEditingController> _toListen;
  ///
  const ReadOnlyField({
    super.key,
    required String label,
    required String Function() getValue,
    List<TextEditingController> toListen = const [],
  })  : _label = label,
        _getValue = getValue,
        _toListen = toListen;
  ///
  @override
  State<ReadOnlyField> createState() => _ReadOnlyFieldState();
}
class _ReadOnlyFieldState extends State<ReadOnlyField> {
  late TextEditingController _controller;
  late List<TextEditingController> _toListen;
  //
  void onValueChange() {
    _controller.text = widget._getValue();
  }
  //
  @override
  void initState() {
    _toListen = widget._toListen;
    _controller = TextEditingController(text: widget._getValue());
    for (final controller in _toListen) {
      controller.addListener(onValueChange);
    }
    super.initState();
  }
  //
  @override
  void dispose() {
    _controller.dispose();
    for (final controller in _toListen) {
      controller.removeListener(onValueChange);
    }
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      canRequestFocus: false,
      mouseCursor: SystemMouseCursors.basic,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget._label,
      ),
      controller: _controller,
    );
  }
}
