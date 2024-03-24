import 'package:davi/davi.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/cargo/cargo.dart';
import 'package:sss_computing_client/models/cargos/cargos.dart';
import 'package:sss_computing_client/models/persistable/value_record.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/action_button.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/edit_on_tap_field.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/new_cargo_field.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/table_view.dart';

class CargoColumn {
  final String type;
  final String key;
  final String name;
  final String defaultValue;
  final bool isEditable;
  final Validator? validator;
  final double? grow;

  const CargoColumn({
    required this.type,
    required this.key,
    required this.name,
    required this.defaultValue,
    required this.isEditable,
    this.validator,
    this.grow,
  });
}

class CargoTable extends StatefulWidget {
  final Cargos _cargos;
  final List<Cargo> _rows;
  final List<CargoColumn> _columns;
  final void Function(Cargo?)? _onCargoSelect;
  const CargoTable({
    super.key,
    required Cargos cargos,
    required List<Cargo> rows,
    required List<CargoColumn> columns,
    void Function(Cargo? cargo)? onCargoSelect,
  })  : _cargos = cargos,
        _rows = rows,
        _columns = columns,
        _onCargoSelect = onCargoSelect;

  @override
  State<CargoTable> createState() => _CargoTableState();
}

class _CargoTableState extends State<CargoTable> {
  late final List<Cargo> _cargos;
  late final DaviModel<Cargo> _model;
  final defaultValidator = const Validator(
    cases: [MinLengthValidationCase(1)],
  );
  int? _selectedId;
  int? _newRowIdx;
  Map<String, TextEditingController>? _newRowControllers;
  Map<String, String?>? _newRowValidity;
  Failure? _newRowError;
  Cargo? _newCargo;

  @override
  // ignore: long-method
  void initState() {
    _cargos = widget._rows;
    _model = DaviModel(
      columns: [
        DaviColumn(
          sortable: false,
          pinStatus: PinStatus.left,
          cellBuilder: (_, row) => row.data.asMap()['idx'] == _newRowIdx
              ? _buildNewRowButtons()
              : Text('${row.data.asMap()['idx']}'),
          cellStyleBuilder: _buildCellStyle,
        ),
        ...widget._columns.map(
          (column) => DaviColumn(
            sortable: false,
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

  @override
  void dispose() {
    _handleRowAddingEnd();
    super.dispose();
  }

  void _toggleSelectedRow(Cargo cargo) {
    setState(() {
      if (_selectedId != cargo.id) {
        _selectedId = cargo.id;
        widget._onCargoSelect?.call(cargo);
      } else {
        _selectedId = null;
        widget._onCargoSelect?.call(null);
      }
    });
  }

  void _handleRowDelete(int id) async {
    Log('$runtimeType').debug(
      'Delete button callback; CargoID: $_selectedId',
    );
    final selectedCargo = _cargos.singleWhere((cargo) => cargo.id == id);
    switch (await widget._cargos.remove(selectedCargo)) {
      case Ok():
        setState(() {
          _cargos.removeWhere((cargo) => cargo.id == _selectedId);
          _selectedId = null;
          _model.removeRow(selectedCargo);
        });
      case Err(:final error):
        Log('$runtimeType').error(error);
    }
  }

  void _handleRowAddingStart() {
    if (_newRowIdx != null) return;
    setState(() {
      _newRowIdx = _cargos.last.asMap()['idx'] + 1;
      final newValues = Map.fromEntries(widget._columns.map(
        (column) => MapEntry(
          column.key,
          switch (column.type) {
            'int' => int.parse(column.defaultValue),
            'real' => double.parse(column.defaultValue),
            'string' || _ => column.defaultValue,
          },
        ),
      ))
        ..['idx'] = _newRowIdx!;
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
      _cargos.add(_newCargo!);
      _model.addRow(_newCargo!);
    });
  }

  void _handleRowAddingEnd({bool remove = false}) {
    if (_newCargo != null) {
      Log('$runtimeType').error(_newCargo);
      setState(() {
        if (remove) {
          _cargos.remove(_newCargo!);
          _model.removeRow(_newCargo!);
        }
        _newRowControllers?.forEach((_, controller) => controller.dispose());
        _newRowControllers = null;
        _newRowValidity = null;
        _newRowIdx = null;
        _newCargo = null;
        _newRowError = null;
      });
    }
  }

  void _handleRowAddingSave() async {
    if (_newRowIdx == null) return;
    final idx = _cargos.indexOf(_newCargo!);
    final newValues = _newCargo!.asMap().map((key, value) => MapEntry(
          key,
          _newRowControllers!.containsKey(key)
              ? switch (
                  widget._columns.singleWhere((col) => col.key == key).type) {
                  'int' => int.parse(_newRowControllers![key]!.text),
                  'real' => double.parse(_newRowControllers![key]!.text),
                  'string' || _ => _newRowControllers![key]!.text,
                }
              : value,
        ));
    final cargo = JsonCargo(json: newValues);
    switch (await widget._cargos.add(cargo)) {
      case Ok():
        setState(() {
          _cargos[idx] = cargo;
          _model.replaceRows(_cargos);
        });
        _handleRowAddingEnd();
      case Err(:final error):
        setState(() {
          _newRowError = error;
        });
    }
  }

  Widget _buildNewRowButtons() {
    final size = IconTheme.of(context).size;
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _newRowValidity?.entries.fold<String?>(
                  null,
                  (prev, entry) => prev ?? entry.value,
                ) !=
                null
            ? SizedBox(
                width: size,
                height: size,
                child: Tooltip(
                  message: const Localized('All values must be valid').v,
                  child: Icon(
                    Icons.warning_rounded,
                    color: theme.colorScheme.error,
                  ),
                ),
              )
            : SizedBox(
                width: size,
                height: size,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _handleRowAddingSave,
                  child: Icon(Icons.done, color: theme.colorScheme.primary),
                ),
              ),
        SizedBox(
          width: size,
          height: size,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _handleRowAddingEnd(remove: true),
            child: Icon(Icons.close, color: theme.colorScheme.primary),
          ),
        ),
        if (_newRowError != null)
          SizedBox(
            width: size,
            height: size,
            child: Tooltip(
              message: Localized(_newRowError?.message).v,
              child: Icon(Icons.error_outline, color: theme.colorScheme.error),
            ),
          ),
      ],
    );
  }

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

  Widget _buildEditableCell(
    DaviRow<Cargo> row,
    CargoColumn column, {
    Key? key,
  }) {
    return EditOnTapField(
      key: key,
      initialValue: '${row.data.asMap()[column.key]}',
      record: ValueRecord(
        filter: {'cargo_id': row.data.id},
        key: column.key,
        tableName: 'cargo_parameters',
        dbName: 'sss-computing',
        apiAddress: ApiAddress.localhost(port: 8080),
      ),
      textColor: Theme.of(context).colorScheme.onSurface,
      iconColor: Theme.of(context).colorScheme.primary,
      errorColor: Theme.of(context).stateColors.error,
      onSave: (value) => setState(() {
        final idx = _cargos.indexOf(row.data);
        final newValue = switch (column.type) {
          'real' => double.tryParse(value),
          'int' => int.tryParse(value),
          'string' || _ => value,
        };
        final newData = row.data.asMap()..[column.key] = newValue;
        _cargos[idx] = JsonCargo(json: newData);
        _model.replaceRows(_cargos);
      }),
      validator: column.validator ?? defaultValidator,
    );
  }

  Widget _buildCell(DaviRow<Cargo> row, CargoColumn column) {
    return row.data.asMap()['idx'] == _newRowIdx
        ? _buildNewRowCell(
            row,
            column,
          )
        : column.isEditable
            ? _buildEditableCell(
                row,
                column,
                key: ValueKey('${column.key}-${row.data.id}'),
              )
            : Text('${row.data.asMap()[column.key]}');
  }

  CellStyle? _buildCellStyle(DaviRow<Cargo> row) {
    return row.data.asMap()['id'] == _selectedId &&
            row.data.asMap()['id'] != null
        ? CellStyle(
            background: Theme.of(context).colorScheme.primary.withOpacity(0.25),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ActionButton(
              label: const Localized('Add').v,
              icon: Icons.add,
              onPressed:
                  _newRowIdx == null ? () => _handleRowAddingStart() : null,
            ),
            SizedBox(
              width: const Setting('padding', factor: 1.0).toDouble,
            ),
            ActionButton(
              label: const Localized('Delete').v,
              icon: Icons.delete,
              onPressed: _selectedId != null
                  ? () => _handleRowDelete(_selectedId!)
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
          ),
        ),
      ],
    );
  }
}
