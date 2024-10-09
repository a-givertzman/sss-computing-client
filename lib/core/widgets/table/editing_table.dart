import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/widgets/table/table_view.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
import 'package:sss_computing_client/core/widgets/table/edit_on_tap_cell.dart';

///
/// Widget that displays [T] list in form of table with editing fields.
class EditingTable<T> extends StatefulWidget {
  final List<TableColumn> _columns;
  final List<T> _rows;
  final void Function(T rowData)? _onRowTap;
  final void Function(T rowData)? _onRowUpdate;
  final T? _selectedRow;
  final Color _selectedRowColor;
  final double _rowHeight;

  ///
  /// Creates widget that displays [T] list in form of table.
  ///
  /// [columns] – list of [TableColumn] to construct table.
  /// [rows] – list of rows to display.
  /// [onRowTap] – called to handle tap on row.
  /// [selected] – selected element, visually separated from the rest by a special color.
  /// [selectedColor] – color of selected item.
  /// [rowHeight] – table row height.
  const EditingTable({
    super.key,
    required List<TableColumn> columns,
    required List<T> rows,
    void Function(T rowData)? onRowTap,
    void Function(T rowData)? onRowUpdate,
    T? selectedRow,
    Color selectedColor = Colors.amber,
    double rowHeight = 32.0,
  })  : _columns = columns,
        _rows = rows,
        _onRowTap = onRowTap,
        _onRowUpdate = onRowUpdate,
        _selectedRow = selectedRow,
        _selectedRowColor = selectedColor,
        _rowHeight = rowHeight;
  //
  @override
  State<EditingTable<T>> createState() => _EditingTableState<T>();
}

///
class _EditingTableState<T> extends State<EditingTable<T>> {
  late final ScrollController _scrollController;
  late final DaviModel<T> _model;
  //
  @override
  void initState() {
    _scrollController = ScrollController();
    _model = DaviModel(
      columns: [
        ...widget._columns.map(
          (column) => DaviColumn(
            headerAlignment: column.headerAlignment,
            cellAlignment: column.cellAlignment,
            grow: column.grow,
            sortable: true,
            resizable: column.isResizable,
            stringValue: column.type == FieldType.string
                ? (rowData) => column.extractValue(rowData)
                : null,
            doubleValue: column.type == FieldType.real
                ? (rowData) => column.extractValue(rowData)
                : null,
            intValue: column.type == FieldType.int
                ? (rowData) => column.extractValue(rowData)
                : null,
            width: column.width ?? 100.0,
            name: column.name,
            cellBuilder: (_, row) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _buildCell(context, row, column),
            ),
            cellStyleBuilder: _buildCellStyle,
          ),
        ),
      ],
    );
    super.initState();
  }

  //
  @override
  void dispose() {
    _model.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  //
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
          child: TableView<T>(
            model: _model..replaceRows(widget._rows),
            cellHeight: 32.0,
            scrollController: _scrollController,
            cellPadding: EdgeInsets.zero,
            onRowTap: (rowData) => widget._onRowTap?.call(rowData),
            tableBorderColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  ///
  Widget _buildPreviewCell(
    BuildContext context,
    DaviRow<T> row,
    TableColumn column,
  ) {
    return column.buildCell(
          context,
          row.data,
          (value) => widget._onRowUpdate?.call(
            column.copyRowWith(row.data, value),
          ),
        ) ??
        Text(
          switch (column.extractValue(row.data)) {
            null => column.nullValue,
            final value => column.parseToString(value),
          },
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: switch (column.cellAlignment) {
            Alignment.centerLeft ||
            Alignment.bottomLeft ||
            Alignment.topLeft =>
              TextAlign.left,
            Alignment.centerRight ||
            Alignment.bottomRight ||
            Alignment.topRight =>
              TextAlign.right,
            _ => TextAlign.center
          },
        );
  }

  ///
  Widget _buildEditableCell(
    BuildContext context,
    DaviRow<T> row,
    TableColumn column,
  ) {
    final theme = Theme.of(context);
    return EditOnTapCell(
      initialValue: switch (column.extractValue(row.data)) {
        null => column.nullValue,
        final value => column.parseToString(value),
      },
      textColor: theme.colorScheme.onSurface,
      iconColor: theme.colorScheme.primary,
      errorColor: theme.stateColors.error,
      onSubmit: (value) =>
          column
              .buildRecord(row.data, column.parseToValue)
              ?.persist(value)
              .then((value) => switch (value) {
                    Ok(:final value) => Ok(column.parseToString(value)),
                    Err(:final error) => Err(error),
                  }) ??
          Future.value(Ok(value)),
      onSubmitted: (value) => widget._onRowUpdate?.call(
        column.copyRowWith(row.data, value),
      ),
      validator: column.validator,
      child: _buildPreviewCell(
        context,
        row,
        column,
      ),
    );
  }

  ///
  Widget _buildCell(
    BuildContext context,
    DaviRow<T> row,
    TableColumn column,
  ) {
    return column.useDefaultEditing
        ? _buildEditableCell(
            context,
            row,
            column,
          )
        : _buildPreviewCell(
            context,
            row,
            column,
          );
  }

  ///
  CellStyle? _buildCellStyle(DaviRow<T> row) {
    return row.data == widget._selectedRow
        ? CellStyle(
            background: widget._selectedRowColor.withOpacity(0.25),
          )
        : null;
  }

  ///
  void _highlightRow(T? rowData) {
    if (rowData == null) return;
    for (var idx = 0; idx < _model.rowsLength; idx++) {
      if (_model.rowAt(idx) != rowData) continue;
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
