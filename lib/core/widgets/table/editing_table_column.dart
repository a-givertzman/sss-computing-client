import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// Standard [TableColumn] for [EditingTable].
class EditingTableColumn<D, V> implements TableColumn<D, V> {
  /// Default string representation for `null` values.
  static const String _defaultNullValue = '–';
  //
  @override
  final String key;
  //
  @override
  final FieldType type;
  //
  @override
  final String name;
  //
  @override
  final String nullValue;
  //
  @override
  final V defaultValue;
  //
  @override
  final Alignment headerAlignment;
  //
  @override
  final Alignment cellAlignment;
  //
  @override
  final double? grow;
  //
  @override
  final double? width;
  //
  @override
  final bool useDefaultEditing;
  //
  @override
  final bool isResizable;
  //
  @override
  final Validator? validator;
  ///
  /// Creates [TableColumn] for [EditingTable] based on passed arguments.
  ///
  /// * [extractValue] is used to extract value from [D].
  /// * [parseToValue] is used to parse [String] text into [V] value.
  /// * [parseToString] is used to parse [V] value into [String] text.
  /// * [copyRowWith] is used to copy [D] row with new [V] value.
  /// * [buildCell] is used to build custom cell widget with ability to update [V] value if needed.
  /// * [buildRecord] can be used to construct [ValueRecord] for row value, that handle value update remote source,
  /// prefer to use [EditingTable] onRowUpdate callback to handle value update manually.
  const EditingTableColumn({
    required this.key,
    this.type = FieldType.string,
    required this.name,
    this.nullValue = _defaultNullValue,
    required this.defaultValue,
    this.headerAlignment = Alignment.centerLeft,
    this.cellAlignment = Alignment.centerLeft,
    this.grow,
    this.width,
    this.useDefaultEditing = false,
    this.isResizable = true,
    this.validator,
    required V Function(D) extractValue,
    required V Function(String) parseToValue,
    String Function(V)? parseToString,
    D Function(D, V)? copyRowWith,
    ValueRecord<V> Function(D, V Function(String text)?)? buildRecord,
    Widget Function(BuildContext, D, void Function(V))? buildCell,
  })  : _extractValue = extractValue,
        _parseToValue = parseToValue,
        _parseToString = parseToString,
        _copyRowWith = copyRowWith,
        _buildRecord = buildRecord,
        _buildCell = buildCell;
  ///
  final V Function(D rowData) _extractValue;
  //
  @override
  V extractValue(D rowData) => _extractValue(rowData);
  ///
  final V Function(String text) _parseToValue;
  //
  @override
  V parseToValue(String text) => _parseToValue(text);
  ///
  final String Function(V value)? _parseToString;
  //
  @override
  String parseToString(V value) =>
      _parseToString?.call(value) ?? value.toString();
  ///
  final D Function(D rowData, V value)? _copyRowWith;
  //
  @override
  D copyRowWith(D rowData, V value) =>
      _copyRowWith?.call(rowData, value) ?? rowData;
  ///
  final ValueRecord<V> Function(
    D rowData,
    V Function(String text)? toValue,
  )? _buildRecord;
  //
  @override
  ValueRecord<V>? buildRecord(D rowData, V Function(String text) toValue) =>
      _buildRecord?.call(rowData, toValue);
  ///
  final Widget Function(
    BuildContext context,
    D rowData,
    void Function(V value) updateValue,
  )? _buildCell;
  //
  @override
  Widget? buildCell(
    BuildContext context,
    D rowData,
    void Function(V value) updateValue,
  ) =>
      _buildCell?.call(context, rowData, updateValue);
}
