import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
///
class TableView<T> extends StatelessWidget {
  final DaviModel<T> _model;
  final void Function(T)? _onRowTap;
  final void Function(T)? _onRowDoubleTap;
  final Color? Function(DaviRow<T>)? _rowColor;
  final MouseCursor? Function(DaviRow<T>)? _rowCursor;
  final Border? _outerBorder;
  final double _tableBorderThickness;
  final Color? _tableBorderColor;
  final double _headerBorderThickness;
  final Color? _headerBorderColor;
  final Color? _scrollbarBackgroundColor;
  final Color? _controlElementColor;
  final Color? _thumbColor;
  final double _headerHeight;
  final double _cellHeight;
  final ScrollController? _scrollController;
  final ColumnWidthBehavior _columnWidthBehavior;
  ///
  const TableView({
    super.key,
    required DaviModel<T> model,
    void Function(T)? onRowTap,
    void Function(T)? onRowDoubleTap,
    Color? Function(DaviRow<T>)? rowColor,
    MouseCursor? Function(DaviRow<T>)? rowCursor,
    Border? outerBorder,
    double tableBorderThickness = 2.0,
    Color? tableBorderColor,
    double headerBorderThickness = 2.0,
    Color? headerBorderColor,
    Color? scrollbarBackgroundColor,
    Color? controlElementColor,
    Color? thumbColor,
    double headerHeight = 32.0,
    double cellHeight = 32.0,
    ScrollController? scrollController,
    Color? selectedRowColor,
    ColumnWidthBehavior columnWidthBehavior = ColumnWidthBehavior.scrollable,
  })  : _rowColor = rowColor,
        _columnWidthBehavior = columnWidthBehavior,
        _thumbColor = thumbColor,
        _controlElementColor = controlElementColor,
        _scrollbarBackgroundColor = scrollbarBackgroundColor,
        _tableBorderColor = tableBorderColor,
        _tableBorderThickness = tableBorderThickness,
        _headerBorderColor = headerBorderColor,
        _headerBorderThickness = headerBorderThickness,
        _onRowTap = onRowTap,
        _onRowDoubleTap = onRowDoubleTap,
        _headerHeight = headerHeight,
        _cellHeight = cellHeight,
        _rowCursor = rowCursor,
        _outerBorder = outerBorder,
        _scrollController = scrollController,
        _model = model;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controlElementColor =
        _controlElementColor ?? theme.colorScheme.primary;
    final tableBorderColor =
        _tableBorderColor ?? theme.disabledColor.withOpacity(0.3);
    final headerBorderColor =
        _headerBorderColor ?? theme.disabledColor.withOpacity(0.3);
    final scrollbarBackgroundColor =
        _scrollbarBackgroundColor ?? theme.disabledColor.withOpacity(0.07);
    final thumbColor = _thumbColor ?? theme.disabledColor.withOpacity(0.3);
    final outerBorder =
        _outerBorder ?? Border.all(color: tableBorderColor, width: 1);
    return DaviTheme(
      data: DaviThemeData(
        decoration: BoxDecoration(
          border: outerBorder,
        ),
        columnDividerColor: tableBorderColor,
        columnDividerThickness: _tableBorderThickness,
        headerCell: HeaderCellThemeData(
          sortIconColors: SortIconColors(
            ascending: controlElementColor,
            descending: controlElementColor,
          ),
          height: _headerHeight,
        ),
        header: HeaderThemeData(
          bottomBorderColor: headerBorderColor,
          bottomBorderHeight: _headerBorderThickness,
          columnDividerColor: tableBorderColor,
        ),
        row: RowThemeData(
          dividerColor: Colors.transparent,
          dividerThickness: 0.0,
          color: RowThemeData.zebraColor(
            evenColor: Colors.black.withOpacity(0.125),
            oddColor: Colors.transparent,
          ),
        ),
        cell: CellThemeData(
          alignment: Alignment.centerLeft,
          contentHeight: _cellHeight,
        ),
        scrollbar: TableScrollbarThemeData(
          margin: theme.scrollbarTheme.mainAxisMargin ??
              TableScrollbarThemeDataDefaults.margin,
          thickness: theme.scrollbarTheme.thickness
                  ?.resolve({MaterialState.hovered}) ??
              TableScrollbarThemeDataDefaults.thickness,
          verticalColor: scrollbarBackgroundColor,
          verticalBorderColor: Colors.transparent,
          pinnedHorizontalColor: scrollbarBackgroundColor,
          pinnedHorizontalBorderColor: Colors.transparent,
          unpinnedHorizontalColor: scrollbarBackgroundColor,
          unpinnedHorizontalBorderColor: Colors.transparent,
          columnDividerColor: tableBorderColor,
          thumbColor: thumbColor,
        ),
        topCornerColor: Colors.transparent,
        bottomCornerColor: scrollbarBackgroundColor,
        topCornerBorderColor: Colors.transparent,
        bottomCornerBorderColor: Colors.transparent,
      ),
      child: Davi<T>(
        _model,
        onRowTap: _onRowTap,
        onRowDoubleTap: _onRowDoubleTap,
        rowColor: _rowColor,
        rowCursor: _rowCursor,
        columnWidthBehavior: _columnWidthBehavior,
        verticalScrollController: _scrollController,
      ),
    );
  }
}
