import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
/// Model that holds data for [TextFormField] or [TextField].
class FieldData<T> {
  final String id;
  final String label;
  T _initialValue;
  final T Function(String text) toValue;
  final String Function(T value) toText;
  final ValueRecord<T> _record;
  final TextEditingController _controller;
  final Validator? _validator;
  bool _isPersisted;
  ///
  /// Model that holds data for [TextFormField] or [TextField].
  ///
  ///   - [label] - text with which the target field will be labeled.
  ///   - [initialValue] - initial content of the target field. Also will be set to [value].
  ///   - [record] - database field from which we can read or to which we can write data.
  FieldData({
    required this.id,
    required this.label,
    required this.toValue,
    required this.toText,
    required T initialValue,
    required ValueRecord<T> record,
    Validator? validator,
    bool isPersisted = false,
  })  : _initialValue = initialValue,
        _record = record,
        _validator = validator,
        _isPersisted = isPersisted,
        _controller = TextEditingController(text: toText(initialValue));
  ///
  FieldData._({
    required this.id,
    required this.label,
    required this.toValue,
    required this.toText,
    required T initialValue,
    required ValueRecord<T> record,
    required TextEditingController controller,
    required Validator? validator,
    required bool isPersisted,
  })  : _record = record,
        _initialValue = initialValue,
        _controller = controller,
        _validator = validator,
        _isPersisted = isPersisted;
  ///
  /// Initial content of the target field.
  T get initialValue => _initialValue;
  ///
  /// Controller for FormField's.
  TextEditingController get controller => _controller;
  ///
  /// Whether content of the target changed or not.
  bool get isChanged => _initialValue != _controller.text;
  ///
  /// Whether content of the target synced with source or not
  bool get isSynced => _isPersisted;
  ///
  Validator? get validator => _validator;
  ///
  /// Pull data from the database through provided [record].
  Future<ResultF<T>> fetch() async {
    switch (await _record.fetch()) {
      case Ok(:final value):
        refreshWith(toText(value));
        _isPersisted = true;
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
        _isPersisted = true;
        return Ok(toValue(text));
      case final Err<void, Failure> err:
        Log('$runtimeType | fetch').error(err.error);
        return Err<T, Failure>(err.error);
    }
  }
  ///
  /// Sets initialaValue and controller value to provided one.
  void refreshWith(String text) {
    _controller.text = text;
    _initialValue = toValue(text);
  }
  ///
  /// Set current [value] to its [initialState].
  void cancel() {
    _controller.text = toText(_initialValue);
  }
  ///
  FieldData<T> copyWithValue(T value) => FieldData<T>._(
        id: id,
        label: label,
        toValue: toValue,
        toText: toText,
        initialValue: _initialValue,
        record: _record,
        controller: controller..text = toText(value),
        validator: _validator,
        isPersisted: _isPersisted,
      );
}
