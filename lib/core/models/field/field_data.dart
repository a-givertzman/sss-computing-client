import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
/// Object that holds data for [TextFormField] or [TextField].
class FieldData<T> {
  final String id;
  final String label;
  T _initialValue;
  final T Function(String text) _toValue;
  final String Function(T value) _toText;
  final ValueRecord<T> _record;
  final TextEditingController _controller;
  final Validator? _validator;
  bool _isSynced;
  ///
  /// Creates object that holds data for [TextFormField] or [TextField].
  ///   - [id] – [FieldData] unique identifier.
  ///   - [label] – text with which the target field will be labeled.
  ///   - [initialValue] – initial content of the target field. Also will be set to [value].
  ///   - [toValue] – function for parsing string representation of
  /// field into value of desired type.
  ///   - [toText] – function for converting value to it string representation.
  ///   - [record] – [ValueRecord] from which we can read or to which we can write data.
  ///   - [validator] – [Validator] for the [FieldData] value.
  ///   - [isSynced] –  indicated whether content of the [FieldData] synced with source or not.
  FieldData({
    required this.id,
    required this.label,
    required T Function(String) toValue,
    required String Function(T) toText,
    required T initialValue,
    required ValueRecord<T> record,
    Validator? validator,
    bool isSynced = false,
  })  : _toValue = toValue,
        _toText = toText,
        _initialValue = initialValue,
        _record = record,
        _validator = validator,
        _isSynced = isSynced,
        _controller = TextEditingController(text: toText(initialValue));
  ///
  /// Initial content of the target field.
  T get initialValue => _initialValue;
  ///
  /// Controller for FormField's.
  TextEditingController get controller => _controller;
  ///
  /// Whether content of the target changed or not.
  bool get isChanged => _toText(_initialValue) != _controller.text;
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
  /// Sets [initialaValue] and [controller] text to provided one.
  void refreshWith(String text) {
    _controller.text = text;
    _initialValue = _toValue(text);
  }
  ///
  /// Set current [value] to its initial state.
  void cancel() {
    _controller.text = _toText(_initialValue);
  }
  ///
  /// Returns copy of [FieldData] with provided values.
  FieldData<T> copyWith({
    T? initialValue,
    ValueRecord<T>? record,
    Validator? validator,
    bool? isPersisted,
  }) =>
      FieldData<T>(
        id: id,
        label: label,
        toValue: _toValue,
        toText: _toText,
        initialValue: initialValue ?? _initialValue,
        record: record ?? _record,
        validator: validator ?? _validator,
        isSynced: isPersisted ?? _isSynced,
      );
}
