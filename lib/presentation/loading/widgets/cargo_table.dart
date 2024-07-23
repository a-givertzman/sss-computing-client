import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';
import 'package:sss_computing_client/presentation/loading/widgets/edit_on_tap_field.dart';
///
/// Structure with important information about [CargoTable] column
class CargoColumn<T> {
  final String type;
  final String key;
  final String name;
  final String defaultValue;
  final Alignment headerAlignment;
  final Alignment cellAlignment;
  final bool isEditable;
  final bool isResizable;
  final Validator? validator;
  final T Function(String text)? parseValue;
  final T Function(Cargo cargo)? extractValue;
  final ValueRecord Function(Cargo cargo)? buildRecord;
  final Widget Function(Cargo cargo)? buildCell;
  final double? grow;
  final double? width;
  ///
  const CargoColumn({
    required this.type,
    required this.key,
    required this.name,
    required this.defaultValue,
    this.headerAlignment = Alignment.centerLeft,
    this.cellAlignment = Alignment.centerLeft,
    this.isEditable = false,
    this.isResizable = false,
    this.validator,
    this.parseValue,
    this.extractValue,
    this.buildRecord,
    this.buildCell,
    this.grow,
    this.width,
  });
}
///
/// Widget that displays [Cargo] list in form of table.
class CargoTable extends StatefulWidget {
  final List<CargoColumn> _columns;
  final List<Cargo> _cargos;
  final void Function(Cargo cargo)? _onRowTap;
  final Cargo? _selectedRow;
  final Color _selectedRowColor;
  final double _rowHeight;
  ///
  /// Creates widget that displays [Cargo] list in form of table.
  ///
  /// `columns` - list of [CargoColumn] to construct table.
  /// `cargos` - list of cargos to display.
  /// `onRowTap` - called to handle tap on row.
  /// `selected` - selected element, visually separated from the rest by a special color.
  /// `selectedColor` - color of selected item.
  /// `rowHeight` - table row height.
  const CargoTable({
    super.key,
    required List<CargoColumn> columns,
    required List<Cargo> cargos,
    void Function(Cargo cargo)? onRowTap,
    Cargo? selected,
    Color selectedColor = Colors.amber,
    double rowHeight = 32.0,
  })  : _columns = columns,
        _cargos = cargos,
        _onRowTap = onRowTap,
        _selectedRow = selected,
        _selectedRowColor = selectedColor,
        _rowHeight = rowHeight;
  //
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
  ///
  @override
  void initState() {
    _scrollController = ScrollController();
    _cargos = widget._cargos;
    _model = DaviModel(
      rows: _cargos,
      columns: [
        ...widget._columns.map(
          (column) => DaviColumn(
            headerAlignment: column.headerAlignment,
            cellAlignment: column.cellAlignment,
            grow: column.grow,
            sortable: true,
            resizable: column.isResizable,
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
            name: column.name,
            cellBuilder: (_, row) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _buildCell(row, column),
            ),
            cellStyleBuilder: _buildCellStyle,
          ),
        ),
      ],
    );
    super.initState();
  }
  ///
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  ///
  @override
  Widget build(BuildContext context) {
    _highlightRow(widget._selectedRow);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: const Setting('padding', factor: 1.0).toDouble,
        ),
        Expanded(
          flex: 1,
          child: TableView<Cargo>(
            model: _model,
            cellHeight: 32.0,
            scrollController: _scrollController,
            cellPadding: EdgeInsets.zero,
            onRowTap: (cargo) => widget._onRowTap?.call(cargo),
            tableBorderColor: Colors.transparent,
          ),
        ),
      ],
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
      initialValue:
          '${column.extractValue?.call(row.data) ?? row.data.asMap()[column.key] ?? column.defaultValue}',
      textColor: Theme.of(context).colorScheme.onSurface,
      iconColor: Theme.of(context).colorScheme.primary,
      errorColor: Theme.of(context).stateColors.error,
      onSubmit: (value) async {
        final newValue =
            await column.buildRecord?.call(row.data).persist(value) ??
                Ok(value);
        final idx = _cargos.indexOf(row.data);
        final newCargoJson = row.data.asMap();
        for (final column in widget._columns) {
          final record = column.buildRecord?.call(row.data);
          if (record == null) continue;
          final newColumnValue = await record.fetch();
          if (newColumnValue is Ok) {
            final newValue = (newColumnValue as Ok).value;
            newCargoJson[column.key] =
                column.parseValue?.call(newValue) ?? newValue;
          }
        }
        _cargos[idx] = JsonCargo(json: newCargoJson);
        _model.replaceRows(_cargos);
        setState(() {
          return;
        });
        return newValue;
      },
      validator: column.validator ?? defaultValidator,
      child: column.buildCell?.call(row.data),
    );
  }
  ///
  Widget _buildCell(DaviRow<Cargo> row, CargoColumn column) {
    return !column.isEditable
        ? column.buildCell?.call(row.data) ??
            Text(
              '${column.extractValue?.call(row.data) ?? row.data.asMap()[column.key] ?? column.defaultValue}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
        : _buildEditableCell(
            row,
            column,
            key: ValueKey('${column.key}-${row.data.id}'),
          );
  }
  ///
  CellStyle? _buildCellStyle(DaviRow<Cargo> row) {
    return row.data.id == widget._selectedRow?.id
        ? CellStyle(
            background: widget._selectedRowColor.withOpacity(0.25),
          )
        : null;
  }
  ///
  void _highlightRow(Cargo? cargo) {
    if (cargo == null) return;
    for (var idx = 0; idx < _model.rowsLength; idx++) {
      if (_model.rowAt(idx).id != cargo.id) continue;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            (idx * widget._rowHeight).clamp(
              _scrollController.position.minScrollExtent,
              _scrollController.position.maxScrollExtent,
            ),
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
        }
      });
      break;
    }
  }
}
