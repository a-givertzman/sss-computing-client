import 'package:flutter/foundation.dart';

/// Ship general details
abstract interface class Ship {
  /// name of the ship
  String get name;

  @protected

  /// List of fields that can be edited.
  List<String> get editableFields;

  ///
  /// Returns the [Map] representation of the [Ship]
  Map<String, dynamic> toMap();

  /// Checks if the given [field] is found in [_editableFields] list
  /// returns true if found, false otherwise.
  /// used to determine if a field can be edited.
  bool isFieldEditable(String field) {
    return editableFields.contains(field);
  }
}

/// An instance of [Ship] from json.
class JsonShip implements Ship {
  final Map<String, dynamic> _map;
  JsonShip(this._map);

  @override
  String get name => _map['ship_name'] as String;

  @override
  Map<String, dynamic> toMap() => _map;

  @override
  List<String> get editableFields => ["ship_master", "ship_chief_mate"];

  @override
  bool isFieldEditable(String field) {
    return editableFields.contains(field);
  }
}
