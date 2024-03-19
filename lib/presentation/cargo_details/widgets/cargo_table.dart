import 'package:davi/davi.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/cargo/cargo.dart';
import 'package:sss_computing_client/models/persistable/value_record.dart';
import 'package:sss_computing_client/presentation/cargo_details/widgets/table_view.dart';
import 'package:sss_computing_client/validation/real_validation_case.dart';

class CargoTable extends StatefulWidget {
  final List<Cargo> _cargos;
  const CargoTable({super.key, required List<Cargo> cargos}) : _cargos = cargos;

  @override
  State<CargoTable> createState() => _CargoTableState();
}

class _CargoTableState extends State<CargoTable> {
  late final List<Cargo> cargos;
  late final DaviModel<Cargo> model;

  @override
  // ignore: long-method
  void initState() {
    cargos = widget._cargos;
    model = DaviModel(
      columns: [
        DaviColumn(
          name: 'No.',
          pinStatus: PinStatus.left,
          intValue: (cargo) => cargo.id,
        ),
        DaviColumn(
          grow: 2,
          name: 'Name',
          stringValue: (cargo) => cargo.name,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.name,
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'name',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (name) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                name: name,
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              MaxLengthValidationCase(250),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'Weight [t]',
          doubleValue: (cargo) => cargo.weight,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.weight.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'weight',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (weight) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                weight: double.tryParse(weight),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'VCG [m]',
          doubleValue: (cargo) => cargo.vcg,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.vcg.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'vcg',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (vcg) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                vcg: double.tryParse(vcg),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'LCG [m]',
          doubleValue: (cargo) => cargo.lcg,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.lcg.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'lcg',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (lcg) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                lcg: double.tryParse(lcg),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'TCG [m]',
          doubleValue: (cargo) => cargo.tcg,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.tcg.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'tcg',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (tcg) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                tcg: double.tryParse(tcg),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'X1 [m]',
          doubleValue: (cargo) => cargo.x_1,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.x_1.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'x_1',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (leftSideX) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                x_1: double.tryParse(leftSideX),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'X2 [m]',
          doubleValue: (cargo) => cargo.x_2,
          cellBuilder: (_, row) => EditOnTapField(
            initialValue: row.data.x_2.toString(),
            record: ValueRecord(
              filter: {'cargo_id': row.data.id},
              key: 'x_2',
              tableName: 'cargo_parameters',
              dbName: 'sss-computing',
              apiAddress: ApiAddress.localhost(port: 8080),
            ),
            textColor: Theme.of(context).colorScheme.onSurface,
            iconColor: Theme.of(context).colorScheme.primary,
            errorColor: Theme.of(context).stateColors.error,
            onSave: (rightSideX) => setState(() {
              final idx = cargos.indexOf(row.data);
              cargos[idx] = row.data.copyWith(
                x_2: double.tryParse(rightSideX),
              );
              model.replaceRows(cargos);
            }),
            validator: const Validator(cases: [
              MinLengthValidationCase(1),
              RealValidationCase(),
            ]),
          ),
        ),
        DaviColumn(
          grow: 1,
          name: 'Mf.sx [t∙m]',
          stringValue: (_) => '—',
        ),
        DaviColumn(
          grow: 1,
          name: 'Mf.sy [t∙m]',
          stringValue: (_) => '—',
        ),
      ],
      rows: cargos,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TableView<Cargo>(
      model: model,
    );
  }
}

class ActivateOnTapBuilderWidget extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    bool isActivated,
    void Function() deactivate,
  ) builder;
  final bool? Function()? onActivate;
  final bool? Function()? onDeactivate;
  const ActivateOnTapBuilderWidget({
    super.key,
    required this.builder,
    this.onActivate,
    this.onDeactivate,
  });

  @override
  State<ActivateOnTapBuilderWidget> createState() =>
      _ActivateOnTapBuilderWidgetState();
}

class _ActivateOnTapBuilderWidgetState
    extends State<ActivateOnTapBuilderWidget> {
  bool _isActivated = false;

  void _handleActivate() {
    setState(() {
      if (widget.onActivate?.call() ?? false) return;
      _isActivated = true;
    });
  }

  void _handleDeactivate() {
    setState(() {
      if (widget.onDeactivate?.call() ?? false) return;
      _isActivated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isActivated
        ? TapRegion(
            onTapOutside: (_) => _handleDeactivate(),
            child: Builder(
              builder: (context) => widget.builder(
                context,
                _isActivated,
                _handleDeactivate,
              ),
            ),
          )
        : MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _handleActivate(),
              child: Builder(
                builder: (context) => widget.builder(
                  context,
                  _isActivated,
                  _handleDeactivate,
                ),
              ),
            ),
          );
  }
}

class EditOnTapField extends StatefulWidget {
  final String initialValue;
  final ValueRecord record;
  final Color textColor;
  final Color iconColor;
  final Color errorColor;
  final Function(String)? onSave;
  final Function(String)? onCancel;
  final Validator? validator;
  const EditOnTapField({
    super.key,
    required this.initialValue,
    required this.record,
    required this.textColor,
    required this.iconColor,
    required this.errorColor,
    this.onSave,
    this.onCancel,
    this.validator,
  });

  @override
  State<EditOnTapField> createState() => _EditOnTapFieldState();
}

class _EditOnTapFieldState extends State<EditOnTapField> {
  late String _initialValue;
  late bool _isInProcess;
  TextEditingController? _controller;
  FocusNode? _focusNode;
  Failure? _error;
  String? _validationError;

  void _handleEditingStart() {
    Log('$runtimeType').debug('editing start');
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode?.requestFocus();
  }

  void _handleEditingEnd() {
    _controller?.dispose();
    _controller = null;
    _focusNode?.dispose();
    _focusNode = null;
    _validationError = null;
  }

  @override
  void initState() {
    _initialValue = widget.initialValue;
    _isInProcess = false;
    super.initState();
  }

  @override
  void dispose() {
    _handleEditingEnd();
    super.dispose();
  }

  Future<ResultF<void>> _handleValueSave(String value) async {
    if (_validationError != null) {
      return Err(Failure(
        message: _validationError,
        stackTrace: StackTrace.current,
      ));
    }
    setState(() {
      _isInProcess = true;
    });
    await Future.delayed(const Duration(seconds: 2)); // for debugging
    if (value == _initialValue) {
      widget.onSave?.call(value);
      setState(() {
        Log('$runtimeType | ._handleSave').debug('$value not changed');
        _initialValue = value;
        _isInProcess = false;
      });
      return const Ok(null);
    }
    switch (await widget.record.persist(value)) {
      case Ok():
        widget.onSave?.call(value);
        setState(() {
          Log('$runtimeType | ._handleSave').debug('$value saved in db');
          _initialValue = value;
          _isInProcess = false;
        });
        return const Ok(null);
      case Err(:final error):
        setState(() {
          Log('$runtimeType | ._handleSave').debug(error);
          _isInProcess = false;
          _error = error;
        });
        return Err(error);
    }
  }

  void _handleValueChange(String value) {
    if (_error != null) {
      setState(() {
        _error = null;
      });
    }
    final validationError = widget.validator?.editFieldValidator(value);
    if (validationError != _validationError) {
      setState(() {
        _validationError = validationError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = IconTheme.of(context).size ?? 10.0;
    return ActivateOnTapBuilderWidget(
      onActivate: () {
        _handleEditingStart();
        return;
      },
      onDeactivate: () {
        if (_isInProcess) return true;
        _handleEditingEnd();
        return false;
      },
      builder: ((context, isActivated, deactivate) => !isActivated
          ? Text(
              _initialValue,
              overflow: TextOverflow.ellipsis,
            )
          : Row(
              children: [
                Flexible(
                  flex: 1,
                  child: TextField(
                    readOnly: _isInProcess,
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _handleValueChange,
                    onSubmitted: (value) => _handleValueSave(value).then(
                      (value) {
                        if (value is Ok) deactivate();
                      },
                    ),
                    style: TextStyle(
                      color: widget.textColor,
                    ),
                  ),
                ),
                if (_isInProcess)
                  CupertinoActivityIndicator(
                    color: widget.iconColor,
                    radius: iconSize / 2,
                  ),
                if (!_isInProcess) ...[
                  switch (_validationError) {
                    null => SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => _handleValueSave(_controller!.text).then(
                            (value) {
                              if (value is Ok) deactivate();
                            },
                          ),
                          child: Icon(
                            Icons.done,
                            color: widget.iconColor,
                          ),
                        ),
                      ),
                    _ => SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: Tooltip(
                          message: _validationError,
                          child: Icon(
                            Icons.warning_rounded,
                            color: widget.errorColor,
                          ),
                        ),
                      ),
                  },
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        widget.onCancel?.call(_controller!.text);
                        deactivate();
                      },
                      child: Icon(
                        Icons.close,
                        color: widget.iconColor,
                      ),
                    ),
                  ),
                ],
                if (!_isInProcess && _error != null)
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: Tooltip(
                      message: _error?.message ?? '',
                      child: Icon(
                        Icons.error_outline,
                        color: widget.errorColor,
                      ),
                    ),
                  ),
              ],
            )),
    );
  }
}

// class EditableInputField extends StatefulWidget {
//   final String initialValue;
//   final ValueRecord record;
//   final Color textColor;
//   final Color iconColor;
//   final Color errorColor;
//   final Function(String)? onSave;
//   final Function(String)? onCancel;
//   final Validator? validator;
//   const EditableInputField({
//     super.key,
//     required this.initialValue,
//     required this.record,
//     required this.textColor,
//     required this.iconColor,
//     required this.errorColor,
//     this.onSave,
//     this.onCancel,
//     this.validator,
//   });

//   @override
//   State<EditableInputField> createState() => _EditableInputFieldState();
// }

// class _EditableInputFieldState extends State<EditableInputField> {
//   late final TextEditingController _controller;
//   late final FocusNode _focusNode;
//   Failure? _error;
//   bool _isInProcess = false;

//   @override
//   void initState() {
//     _controller = TextEditingController(text: widget.initialValue);
//     _focusNode = FocusNode();
//     _focusNode.requestFocus();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _handleSave(String value) async {
//     setState(() {
//       _isInProcess = true;
//     });
//     await Future.delayed(const Duration(seconds: 2)); // for debugging
//     if (value == widget.initialValue) {
//       widget.onSave?.call(value);
//       setState(() {
//         _isInProcess = false;
//       });
//       Log('$runtimeType | ._handleSave').debug('$value not changed');
//       return;
//     }
//     switch (await widget.record.persist(value)) {
//       case Ok():
//         Log('$runtimeType | ._handleSave').debug('$value saved in db');
//         widget.onSave?.call(value);
//       case Err(:final error):
//         setState(() {
//           Log('$runtimeType | ._handleSave').debug(error);
//           _error = error;
//         });
//     }
//     setState(() {
//       _isInProcess = false;
//     });
//   }

//   void _handleChange(String value) {
//     setState(() {
//       _error = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final iconSize = IconTheme.of(context).size ?? 10.0;

//     return SizedBox(
//       child: Row(
//         children: [
//           Flexible(
//             flex: 1,
//             child: TextFormField(
//               readOnly: _isInProcess,
//               controller: _controller,
//               focusNode: _focusNode,
//               onChanged: _handleChange,
//               style: TextStyle(
//                 color: widget.textColor,
//               ),
//             ),
//           ),
//           ...switch (_isInProcess) {
//             true => [
//                 CupertinoActivityIndicator(
//                   color: widget.iconColor,
//                   radius: iconSize / 2,
//                 ),
//               ],
//             false => [
//                 SizedBox(
//                   width: iconSize,
//                   height: iconSize,
//                   child: InkWell(
//                     customBorder: const CircleBorder(),
//                     onTap: () => _handleSave(_controller.text),
//                     child: Icon(
//                       Icons.done,
//                       color: widget.iconColor,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: iconSize,
//                   height: iconSize,
//                   child: InkWell(
//                     customBorder: const CircleBorder(),
//                     onTap: () => widget.onCancel?.call(_controller.text),
//                     child: Icon(
//                       Icons.close,
//                       color: widget.iconColor,
//                     ),
//                   ),
//                 ),
//                 if (_error != null)
//                   SizedBox(
//                     width: iconSize,
//                     height: iconSize,
//                     child: Tooltip(
//                       message: _error?.message ?? '',
//                       child: Icon(
//                         Icons.info_outline,
//                         color: widget.errorColor,
//                       ),
//                     ),
//                   ),
//               ]
//           },
//         ],
//       ),
//     );
//   }
// }
