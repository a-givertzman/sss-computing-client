import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/models/field/field_type.dart';
import 'package:sss_computing_client/models/persistable/persistable.dart';

///
/// Model that holds data for [TextFormField] or [TextField].
class FieldData {
  final String id;
  final FieldType type;
  final String label;
  final String unit;
  final Persistable<String> _record;
  final TextEditingController _controller;
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
    required Persistable<String> record,
    bool isPersisted = false,
  })  : _record = record,
        _initialValue = initialValue,
        _controller = TextEditingController(text: initialValue),
        _isPersisted = isPersisted;

  FieldData._({
    required this.id,
    required this.label,
    required this.unit,
    required this.type,
    required String initialValue,
    required Persistable<String> record,
    required TextEditingController controller,
    required bool isPersisted,
  })  : _record = record,
        _initialValue = initialValue,
        _controller = controller,
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
  /// Set current [value] with provided [newValue].
  // void update(String newValue) {
  //   _controller.text = newValue;
  // }
  ///
  FieldData copyWith({
    String? id,
    String? label,
    String? unit,
    FieldType? type,
    String? initialValue,
    Persistable<String>? record,
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
    );
  }
}
