import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargos.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/field_record/field_record.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';
import 'package:sss_computing_client/presentation/loading/widgets/edit_on_tap_field.dart';
///
/// Structure with important information about [CargoTable] column
class CargoColumn<T> {
  final String type;
  final String key;
  final String name;
  final String defaultValue;
  final bool isEditable;
  final bool isResizable;
  final Validator? validator;
  final T Function(String text)? parseValue;
  final FieldRecord? record;
  final Widget Function(Cargo cargo)? buildCell;
  final double? grow;
  final double? width;
  ///
  const CargoColumn({
    required this.type,
    required this.key,
    required this.name,
    required this.defaultValue,
    this.isEditable = false,
    this.isResizable = false,
    this.validator,
    this.parseValue,
    this.record,
    this.buildCell,
    this.grow,
    this.width,
  });
}
///
/// Table with editable fields representation of provided [Cargos]
class CargoTable extends StatefulWidget {
  final List<CargoColumn> _columns;
  final List<Cargo> _cargos;
  ///
  /// Creates [CargoTable], table representation of [Cargos]
  const CargoTable({
    super.key,
    required List<CargoColumn> columns,
    required List<Cargo> cargos,
  })  : _columns = columns,
        _cargos = cargos;
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
    _cargos = widget._cargos;
    _scrollController = ScrollController();
    _model = DaviModel(
      rows: _cargos,
      columns: [
        ...widget._columns.map(
          (column) => DaviColumn(
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
            // grow: column.grow,
            name: column.name,
            cellBuilder: (_, row) =>
                column.buildCell?.call(row.data) ??
                Padding(
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
            scrollController: _scrollController,
            cellHeight: 32.0,
            cellPadding: EdgeInsets.zero,
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
      initialValue: '${row.data.asMap()[column.key] ?? column.defaultValue}',
      textColor: Theme.of(context).colorScheme.onSurface,
      iconColor: Theme.of(context).colorScheme.primary,
      errorColor: Theme.of(context).stateColors.error,
      onSubmit: (value) =>
          column.record?.persist(value, filter: {'space_id': row.data.id}) ??
          Future.value(Ok(value)),
      onSubmitted: (value) => setState(() {
        final idx = _cargos.indexOf(row.data);
        final newValue = column.parseValue?.call(value) ?? value;
        final newCargoData = row.data.asMap()..[column.key] = newValue;
        _cargos[idx] = JsonCargo(json: newCargoData);
        _model.replaceRows(_cargos);
      }),
      validator: column.validator ?? defaultValidator,
    );
  }
  ///
  Widget _buildCell(DaviRow<Cargo> row, CargoColumn column) {
    return !column.isEditable
        ? Text(
            '${row.data.asMap()[column.key] ?? column.defaultValue}',
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
    return null;
  }
}
