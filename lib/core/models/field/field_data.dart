import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
/// Object that holds data for [TextFormField] or [TextField].
class FieldData<T> {
  final String id;
  final String label;
  final FieldType fieldType;
  final T Function(String text) _toValue;
  final String Function(T value) _toText;
  final ValueRecord<T> _record;
  final TextEditingController _controller;
  final Validator? _validator;
  final Widget Function(
    String value,
    void Function(String) updateValue,
  )? _buildFormField;
  T _initialValue;
  bool _isSynced;
  ///
  /// Creates object that holds data for [TextFormField] or [TextField].
  ///  * [id] – [FieldData] unique identifier.
  ///  * [label] – text with which the target field will be labeled.
  ///  * [initialValue] – initial content of the target field. Also will be set to [value].
  ///  * [toValue] – function for parsing string representation of
  /// field into value of desired type.
  ///  * [toText] – function for converting value to it string representation.
  ///  * [record] – [ValueRecord] from which we can read or to which we can write data.
  ///  * [validator] – [Validator] for the [FieldData] value.
  ///  * [isSynced] –  indicated whether content of the [FieldData] synced with source or not.
  FieldData({
    required this.id,
    required this.label,
    required T Function(String) toValue,
    required String Function(T) toText,
    required T initialValue,
    this.fieldType = FieldType.string,
    ValueRecord<T>? record,
    Validator? validator,
    bool isSynced = false,
    Widget Function(
      String value,
      void Function(String) updateValue,
    )? buildFormField,
  })  : _toValue = toValue,
        _toText = toText,
        _initialValue = initialValue,
        _validator = validator,
        _isSynced = isSynced,
        _record = record ?? _EmptyRecord(initialValue, toValue),
        _controller = TextEditingController(text: toText(initialValue)),
        _buildFormField = buildFormField;
  ///
  /// Initial content of the target field.
  T get initialValue => _initialValue;
  ///
  /// Controller for [FormField].
  TextEditingController get controller => _controller;
  ///
  /// Returns function to build custom [FormField]
  /// using current value of [controller] and
  /// callback to update it.
  Widget Function(
    String value,
    void Function(String) updateValue,
  )? get buildFormField => _buildFormField;
  ///
  /// Whether content of the target changed or not.
  bool get isChanged => _initialValue != _toValue(controller.text);
  ///
  /// Whether content of the target synced with source or not.
  bool get isSynced => _isSynced;
  ///
  /// Returns validator for its [FieldData].
  Validator? get validator => _validator;
  ///
  /// Parses text to [value].
  T toValue(String text) => _toValue(text);
  ///
  /// Returns string representation of [value].
  String toText(T value) => _toText(value);
  ///
  /// Pull data from the database through provided [record].
  Future<ResultF<T>> fetch() async {
    switch (await _record.fetch()) {
      case Ok(:final value):
        refreshWith(_toText(value));
        _isSynced = true;
        return Ok(value);
      case final Err<T, Failure> err:
        Log('$runtimeType | fetch').error(err.error);
        return err;
    }
  }
  ///
  /// Persist data to the database through provided [record].
  Future<ResultF<T>> save() async {
    final text = controller.text;
    switch (await _record.persist(text)) {
      case Ok():
        refreshWith(text);
        _isSynced = true;
        return Ok(_toValue(text));
      case final Err<void, Failure> err:
        Log('$runtimeType | fetch').error(err.error);
        return Err<T, Failure>(err.error);
    }
  }
  ///
  /// Updates [initialValue] and [controller] text using provided [text] value.
  void refreshWith(String text) {
    _controller.text = text;
    _initialValue = _toValue(text);
  }
  ///
  /// Set current [controller] to its initial state.
  void cancel() {
    _controller.text = _toText(_initialValue);
  }
  ///
  /// Returns copy of [FieldData] with provided values.
  FieldData<T> copyWith({
    T? initialValue,
    ValueRecord<T>? record,
    Validator? validator,
    bool? isSynced,
  }) {
    return FieldData<T>(
      id: id,
      label: label,
      toValue: _toValue,
      toText: _toText,
      initialValue: initialValue ?? _initialValue,
      record: record ?? _record,
      validator: validator ?? _validator,
      isSynced: isSynced ?? _isSynced,
      buildFormField: _buildFormField,
    );
  }
}
///
/// Default [ValueRecord] for [FieldData]
/// that does not store value in any source.
final class _EmptyRecord<T> implements ValueRecord<T> {
  T _initialValue;
  final T Function(String text) _toValue;
  ///
  _EmptyRecord(this._initialValue, this._toValue);
  @override
  Future<ResultF<T>> fetch() {
    return Future.value(Ok(_initialValue));
  }
  @override
  Future<ResultF<T>> persist(String value) {
    _initialValue = _toValue(value);
    return Future.value(Ok(_initialValue));
  }
}
