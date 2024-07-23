import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
/// Model that holds data for [TextFormField] or [TextField].
class FieldData {
  final String id;
  final FieldType type;
  final String label;
  final String unit;
  final ValueRecord<String> _record;
  final TextEditingController _controller;
  final Validator? _validator;
  bool _isPersisted;
  String _initialValue;
  ///
  /// Model that holds data for [TextFormField] or [TextField].
  ///
  ///   - [label] - text with which the target field will be labeled.
  ///   - [initialValue] - initial content of the target field. Also will be set to [value].
  ///   - [record] - database field from which we can read or to which we can write data.
  FieldData({
    required this.id,
    required this.label,
    required this.unit,
    required this.type,
    required String initialValue,
    required ValueRecord<String> record,
    Validator? validator,
    bool isPersisted = false,
  })  : _record = record,
        _initialValue = initialValue,
        _controller = TextEditingController(text: initialValue),
        _validator = validator,
        _isPersisted = isPersisted;
  ///
  FieldData._({
    required this.id,
    required this.label,
    required this.unit,
    required this.type,
    required String initialValue,
    required ValueRecord<String> record,
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
  String get initialValue => _initialValue;
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
  Future<ResultF<String>> fetch() async {
    switch (await _record.fetch()) {
      case Ok(:final value):
        refreshWith(value);
        _isPersisted = true;
        return Ok(value);
      case final Err<String, Failure> err:
        Log('$runtimeType | fetch').error(err.error);
        return err;
    }
  }
  ///
  /// Persist data to the database through provided [record].
  Future<ResultF<String>> save() async {
    final value = controller.text;
    switch (await _record.persist(value)) {
      case Ok():
        refreshWith(value);
        _isPersisted = true;
        return Ok(value);
      case final Err<void, Failure> err:
        Log('$runtimeType | fetch').error(err.error);
        return Err<String, Failure>(err.error);
    }
  }
  ///
  /// Sets initialaValue and controller value to provided one.
  void refreshWith(String text) {
    controller.text = text;
    _initialValue = text;
  }
  ///
  /// Set current [value] to its [initialState].
  void cancel() {
    _controller.text = _initialValue;
  }
  ///
  FieldData copyWith({
    String? id,
    String? label,
    String? unit,
    FieldType? type,
    String? initialValue,
    ValueRecord<String>? record,
    Validator? validator,
  }) {
    return FieldData._(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      unit: unit ?? this.unit,
      initialValue: initialValue ?? _initialValue,
      record: record ?? _record,
      controller: _controller,
      isPersisted: _isPersisted,
      validator: validator ?? _validator,
    );
  }
}
