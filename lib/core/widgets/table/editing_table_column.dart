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
  final V Function(D rowData) _extractValue;
  final V Function(String text) _parseToValue;
  final String Function(V value)? _parseToString;
  final D Function(D rowData, V value)? _copyRowWith;
  final ValueRecord<V> Function(
    D rowData,
    V Function(String text)? toValue,
  )? _buildRecord;
  final Widget Function(
    BuildContext context,
    D rowData,
    void Function(V value) updateValue,
  )? _buildCell;
  ///
  /// Creates [TableColumn] for [EditingTable] based on passed arguments.
  /// TODO
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
  //
  @override
  V extractValue(D rowData) => _extractValue(rowData);
  //
  @override
  V parseToValue(String text) => _parseToValue(text);
  //
  @override
  String parseToString(V value) =>
      _parseToString?.call(value) ?? value.toString();
  //
  @override
  D copyRowWith(D rowData, V value) =>
      _copyRowWith?.call(rowData, value) ?? rowData;
  //
  @override
  ValueRecord<V>? buildRecord(D rowData, V Function(String text) toValue) =>
      _buildRecord?.call(rowData, toValue);
  //
  @override
  Widget? buildCell(
    BuildContext context,
    D rowData,
    void Function(V value) updateValue,
  ) =>
      _buildCell?.call(context, rowData, updateValue);
}
