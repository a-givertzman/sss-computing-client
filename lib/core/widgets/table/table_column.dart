import 'package:flutter/widgets.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
/// Objects that holds data for [EditingTable] column.
abstract interface class TableColumn<D, V> {
  ///
  /// Unique identifier of [TableColumn].
  String get key;
  ///
  /// Returns [FieldType] of [V].
  FieldType get type;
  ///
  /// Returns title of [TableColumn].
  String get name;
  ///
  /// Returns string representation for `null` value.
  String get nullValue;
  ///
  /// Returns default [V] value.
  V get defaultValue;
  ///
  /// Returns alignment for [TableColumn] header.
  Alignment get headerAlignment;
  ///
  /// Returns alignment for [TableColumn] cell.
  Alignment get cellAlignment;
  ///
  /// Returns grow factor to use for this [TableColumn].
  double? get grow;
  ///
  /// Returns width to use for this [TableColumn].
  double? get width;
  ///
  /// Is standard [EditingTable] editor used or not.
  bool get useDefaultEditing;
  ///
  /// [TableColumn] can either resize or not.
  bool get isResizable;
  ///
  /// Returns [Validator] for [V].
  Validator? get validator;
  ///
  /// Extracts and returns value from column data.
  V extractValue(D rowData);
  ///
  /// Parses and returns value from its string representation.
  V parseToValue(String text);
  ///
  /// Converts and returns value to its string representation.
  String parseToString(V value);
  ///
  /// Returns new copy of row data with provided column value.
  D copyRowWith(D rowData, V value);
  ///
  /// Builds and returns [ValueRecord] for column data.
  ValueRecord<V>? buildRecord(D rowData, V Function(String text) toValue);
  ///
  /// Builds and returns widget for column cell preview
  /// (if [useDefaultEditing] is `true` after double tap on cell
  /// standard [EditingTable] editor will be used, otherwise
  /// editing should be handled by widget returned by [buildCell] if needed).
  ///
  /// [updateValue] can be used to update column value in [rowData].
  Widget? buildCell(
    BuildContext context,
    D rowData,
    void Function(V value) updateValue,
  );
}
