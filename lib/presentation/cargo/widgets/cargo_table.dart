import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/cargo/cargo.dart';
import 'package:sss_computing_client/models/cargo/cargos.dart';
import 'package:sss_computing_client/models/persistable/value_record.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/action_button.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/cell_action_buttons.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/edit_on_tap_field.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/new_cargo_field.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/table_view.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_test.dart';

/// Structure with important information about [CargoTable] column
class CargoColumn<T> {
  final String type;
  final String key;
  final String name;
  final String defaultValue;
  final bool isEditable;
  final Validator? validator;
  final T Function(String text)? parseValue;
  final ValueRecord Function(int id)? buildRecord;
  final double? grow;
  final double? width;

  const CargoColumn({
    required this.type,
    required this.key,
    required this.name,
    required this.defaultValue,
    required this.isEditable,
    this.validator,
    this.parseValue,
    this.buildRecord,
    this.grow,
    this.width,
  });
}

/// Table representation of provided [Cargos]
class CargoTable extends StatefulWidget {
  final Cargos _cargos;
  // final List<Cargo> _rows;
  final List<CargoColumn> _columns;
  final ShipCargoModel _shipCargoNotifier;
  // final void Function(Cargo?)? _onCargoSelect;

  /// Creates [CargoTable], table representation of [Cargos]
  const CargoTable({
    super.key,
    required Cargos cargos,
    // required List<Cargo> rows,
    required List<CargoColumn> columns,
    required ShipCargoModel shipCargoNotifier,
    // void Function(Cargo? cargo)? onCargoSelect,
  })  : _cargos = cargos,
        // _rows = rows,
        _columns = columns,
        _shipCargoNotifier = shipCargoNotifier;
  // _onCargoSelect = onCargoSelect;

  ///
  @override
  State<CargoTable> createState() => _CargoTableState();
}

///
class _CargoTableState extends State<CargoTable> {
  late final ScrollController _scrollController;
  late final List<Cargo> _cargos;
  late final DaviModel<Cargo> _model;
  final defaultValidator = const Validator(
    cases: [MinLengthValidationCase(1)],
  );
  Map<String, TextEditingController>? _newRowControllers;
  Map<String, String?>? _newRowValidity;
  Failure? _newRowError;
  Cargo? _newCargo;

  /// TODO: refactor
  void _handleCargoSelect() {
    final selected = widget._shipCargoNotifier.selectedCargo;
    if (selected == null) return;
    final index = widget._shipCargoNotifier.cargos.indexOf(selected);

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        (index * 30.0).clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        ),
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  ///
  @override
  void initState() {
    widget._shipCargoNotifier.addListener(_handleCargoSelect);
    _scrollController = ScrollController();
    _cargos = widget._shipCargoNotifier.cargos;
    _model = DaviModel(
      columns: [
        DaviColumn(
          sortable: false,
          cellBuilder: (_, row) => row.data.asMap()['id'] == null
              ? _buildNewRowButtons()
              : Text('${row.index + 1}'),
          cellStyleBuilder: _buildCellStyle,
        ),
        ...widget._columns.map(
          (column) => DaviColumn(
            sortable: true,
            stringValue: column.type == 'text'
                ? (cargo) => cargo.asMap()[column.key]
                : null,
            doubleValue: column.type == 'real'
                ? (cargo) => cargo.asMap()[column.key]
                : null,
            intValue: column.type == 'int'
                ? (cargo) => cargo.asMap()[column.key]
                : null,
            width: column.width ?? 100.0,
            grow: column.grow,
            name: column.name,
            cellBuilder: (_, row) => _buildCell(row, column),
            cellStyleBuilder: _buildCellStyle,
          ),
        ),
      ],
      rows: _cargos,
    );
    super.initState();
  }

  ///
  @override
  void dispose() {
    widget._shipCargoNotifier.removeListener(_handleCargoSelect);
    _scrollController.dispose();
    _handleRowAddingEnd();
    super.dispose();
  }

  ///
  void _toggleSelectedRow(Cargo? cargo) {
    widget._shipCargoNotifier.toggleSelected(cargo);
    // if (cargo?.asMap()['id'] == null) return;
    // setState(() {
    // if (_selectedCargo != cargo) {
    // _selectedCargo = cargo;
    // widget._onCargoSelect?.call(cargo);

    // return;
    // }
    // _selectedCargo = null;
    // widget._onCargoSelect?.call(null);
    // });
  }

  ///
  void _handleRowDelete(Cargo cargo) async {
    switch (await widget._cargos.remove(cargo)) {
      case Ok():
        setState(() {
          _cargos.removeWhere((element) => element.id == cargo.id);
          _model.removeRow(cargo);
          // TODO: remove
          widget._shipCargoNotifier.setCargos(_cargos);
        });
      case Err(:final error):
        Log('$runtimeType').error(error);
    }
  }

  ///
  void _handleRowAddingStart() {
    setState(() {
      final newValues = Map.fromEntries(widget._columns.map(
        (column) => MapEntry(
          column.key,
          column.parseValue?.call(column.defaultValue) ?? column.defaultValue,
        ),
      ));
      _newRowControllers = widget._columns
          .where((col) => col.isEditable)
          .toList()
          .asMap()
          .map((_, col) => MapEntry(
                col.key,
                TextEditingController(text: col.defaultValue),
              ));
      _newRowValidity = widget._columns
          .where((col) => col.isEditable)
          .toList()
          .asMap()
          .map((_, col) => MapEntry(
                col.key,
                col.validator != null
                    ? col.validator?.editFieldValidator(col.defaultValue)
                    : defaultValidator.editFieldValidator(col.defaultValue),
              ));
      _newCargo = JsonCargo(json: newValues);
      if (widget._shipCargoNotifier.selectedCargo == null) {
        _cargos.add(_newCargo!);
        _model.addRow(_newCargo!);
        // TODO: remove
        widget._shipCargoNotifier.setCargos(_cargos);
      } else {
        final index = _cargos.indexOf(widget._shipCargoNotifier.selectedCargo!);
        _toggleSelectedRow(widget._shipCargoNotifier.selectedCargo!);
        _cargos.insert(index, _newCargo!);
        _model.replaceRows(_cargos);
        // TODO: remove
        widget._shipCargoNotifier.setCargos(_cargos);
      }
    });
  }

  ///
  void _handleRowAddingEnd({bool remove = false}) {
    if (_newCargo != null) {
      setState(() {
        if (remove) {
          _cargos.remove(_newCargo!);
          _model.removeRow(_newCargo!);
          // TODO: remove
          widget._shipCargoNotifier.setCargos(_cargos);
        }
        _newRowControllers?.forEach((_, controller) => controller.dispose());
        _newRowControllers = null;
        _newRowValidity = null;
        _newRowError = null;
        _newCargo = null;
      });
    }
  }

  ///
  void _handleRowAddingSave() async {
    if (_newCargo == null || _newRowControllers == null) return;
    final idx = _cargos.indexOf(_newCargo!);
    final newValues = _newCargo?.asMap().map((key, value) => MapEntry(
          key,
          _newRowControllers!.containsKey(key)
              ? widget._columns
                      .singleWhere((col) => col.key == key)
                      .parseValue
                      ?.call(_newRowControllers![key]!.text) ??
                  _newRowControllers![key]!.text
              : value,
        ));
    if (newValues == null) return;
    final cargo = JsonCargo(json: newValues);
    switch (await widget._cargos.add(cargo)) {
      case Ok(value: final id):
        setState(() {
          _cargos[idx] = JsonCargo(json: cargo.asMap()..['id'] = id);
          _model.replaceRows(_cargos);
          // TODO: remove
          widget._shipCargoNotifier.setCargos(_cargos);
        });
        _handleRowAddingEnd();
      case Err(:final error):
        setState(() {
          _newRowError = error;
        });
    }
  }

  ///
  Widget _buildNewRowButtons() {
    return CellActionButtons(
      validationError: _newRowValidity?.entries.fold<String?>(
        null,
        (prev, entry) =>
            prev ?? (entry.value != null ? 'All values must be valid' : null),
      ),
      error: _newRowError,
      onConfirm: _handleRowAddingSave,
      onCancel: () => _handleRowAddingEnd(remove: true),
      iconSize: IconTheme.of(context).size,
      iconColor: Theme.of(context).colorScheme.primary,
      errorColor: Theme.of(context).colorScheme.error,
    );
  }

  ///
  Widget _buildNewRowCell(
    DaviRow<Cargo> row,
    CargoColumn column, {
    Key? key,
  }) {
    final theme = Theme.of(context);
    final controller = _newRowControllers![column.key]!;
    final validator = column.validator ?? defaultValidator;
    return NewCargoField(
      key: key,
      controller: controller,
      textColor: theme.colorScheme.onSurface,
      errorColor: theme.stateColors.error,
      onValidityChange: (validity) => setState(() {
        _newRowValidity?[column.key] = validity;
      }),
      onValueChange: (_) {
        if (_newRowError != null) {
          setState(() {
            _newRowError = null;
          });
        }
      },
      validator: validator,
      validationError: _newRowValidity?[column.key],
    );
  }

  ///
  Widget _buildEditableCell(
    DaviRow<Cargo> row,
    CargoColumn column, {
    Key? key,
  }) {
    return EditOnTapField(
      key: key,
      initialValue: '${row.data.asMap()[column.key]}',
      textColor: Theme.of(context).colorScheme.onSurface,
      iconColor: Theme.of(context).colorScheme.primary,
      errorColor: Theme.of(context).stateColors.error,
      onSubmit: (value) =>
          column.buildRecord?.call(row.data.asMap()['id']).persist(value) ??
          Future.value(Ok(value)),
      onSubmitted: (value) => setState(() {
        final idx = _cargos.indexOf(row.data);
        final newValue = column.parseValue?.call(value) ?? value;
        final newData = row.data.asMap()..[column.key] = newValue;
        _cargos[idx] = JsonCargo(json: newData);
        _model.replaceRows(_cargos);
        // TODO: remove
        widget._shipCargoNotifier.setCargos(_cargos);
        widget._shipCargoNotifier.toggleSelected(_cargos[idx]);
      }),
      validator: column.validator ?? defaultValidator,
    );
  }

  ///
  Widget _buildCell(DaviRow<Cargo> row, CargoColumn column) {
    return !column.isEditable
        ? Text('${row.data.asMap()[column.key] ?? column.defaultValue}')
        : row.data.asMap()['id'] == null
            ? Builder(builder: (_) {
                return _buildNewRowCell(
                  row,
                  column,
                );
              })
            : Builder(builder: (_) {
                return _buildEditableCell(
                  row,
                  column,
                  key: ValueKey('${column.key}-${row.data.id}'),
                );
              });
  }

  ///
  CellStyle? _buildCellStyle(DaviRow<Cargo> row) {
    return row.data == widget._shipCargoNotifier.selectedCargo
        ? CellStyle(
            // background: Theme.of(context).colorScheme.primary.withOpacity(0.25),
            background: Colors.amber.withOpacity(0.15),
          )
        : null;
  }

  ///
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget._shipCargoNotifier,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _newCargo == null
                    ? widget._shipCargoNotifier.selectedCargo != null
                        ? ActionButton(
                            label: const Localized('Add above').v,
                            icon: Icons.add,
                            onPressed: _handleRowAddingStart,
                          )
                        : ActionButton(
                            label: const Localized('Add').v,
                            icon: Icons.add,
                            onPressed: () {
                              _handleRowAddingStart();
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  if (_scrollController.hasClients) {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 500),
                                    );
                                  }
                                },
                              );
                            },
                          )
                    : ActionButton(
                        label: const Localized('Cancel adding').v,
                        icon: Icons.close,
                        onPressed: () => _handleRowAddingEnd(remove: true),
                      ),
                SizedBox(
                  width: const Setting('padding', factor: 1.0).toDouble,
                ),
                ActionButton(
                  label: const Localized('Delete').v,
                  icon: Icons.delete,
                  onPressed: widget._shipCargoNotifier.selectedCargo != null
                      ? () {
                          _handleRowDelete(
                            widget._shipCargoNotifier.selectedCargo!,
                          );
                          _toggleSelectedRow(
                            widget._shipCargoNotifier.selectedCargo!,
                          );
                        }
                      : null,
                ),
              ],
            ),
            SizedBox(
              height: const Setting('padding', factor: 1.0).toDouble,
            ),
            Expanded(
              flex: 1,
              child: TableView<Cargo>(
                model: _model,
                onRowTap: _toggleSelectedRow,
                scrollController: _scrollController,
              ),
            ),
          ],
        );
      },
    );
  }
}
