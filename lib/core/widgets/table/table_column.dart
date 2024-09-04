import 'package:flutter/widgets.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
abstract interface class TableColumn<D, V> {
  ///
  String get key;
  ///
  FieldType get type;
  ///
  String get name;
  ///
  String get nullValue;
  ///
  V get defaultValue;
  ///
  Alignment get headerAlignment;
  ///
  Alignment get cellAlignment;
  ///
  double? get grow;
  ///
  double? get width;
  ///
  bool get useDefaultEditing;
  ///
  bool get isResizable;
  ///
  Validator? get validator;
  ///
  V extractValue(D rowData);
  ///
  V parseToValue(String text);
  ///
  String parseToString(V value);
  ///
  D copyRowWith(D rowData, String text);
  ///
  ValueRecord<V>? buildRecord(D rowData, V Function(String text) toValue);
  ///
  Widget? buildCell(
    BuildContext context,
    D rowData,
    void Function(String text) updateValue,
  );
}
