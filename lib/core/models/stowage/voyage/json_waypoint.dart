import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/waypoint.dart';
///
/// [Waypoint] that parses itself from json map.
class JsonWaypoint implements Waypoint {
  final Map<String, dynamic> _json;
  ///
  /// Creates [Bulkhead] that parses itself from provided [json] map.
  const JsonWaypoint({
    required Map<String, dynamic> json,
  }) : _json = json;
  ///
  /// Creates [JsonWaypoint] from database row.
  ///
  /// Row should have following format:
  /// ```json
  /// {
  ///   "id": 1, // int
  ///   "projectId": 1, // int?
  ///   "shipId": 1, // int
  ///   "portName": "Port Name", // String
  ///   "portCode": "Port Code", // String
  ///   "eta": "2022-01-01 00:00:00", // String?
  ///   "etd": "2022-01-01 00:00:00", // String?
  ///   "color": "#000000", // String
  /// }
  /// ```
  factory JsonWaypoint.fromRow(Map<String, dynamic> row) => JsonWaypoint(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int?,
          'shipId': row['shipId'] as int,
          'portName': row['portName'] as String,
          'portCode': row['portCode'] as String,
          'eta': row['eta'] as String,
          'etd': row['etd'] as String,
          'color': row['color'] as String,
        },
      );
  //
  @override
  int get id => _json['id'];
  //
  @override
  int get shipId => _json['shipId'];
  //
  @override
  int? get projectId => _json['projectId'];
  //
  @override
  String get portName => _json['portName'];
  //
  @override
  String get portCode => _json['portCode'];
  // TODO: handle parse error
  @override
  DateTime get eta => DateTime.parse(_json['eta'] as String);
  // TODO: handle parse error
  @override
  DateTime get etd => DateTime.parse(_json['etd'] as String);
  //
  // TODO: add class with tests
  Color? fromHexString(String hexString) {
    final normalizedHexString = hexString.replaceFirst('#', '').padLeft(8, 'F');
    if (normalizedHexString.length != 8) return null;
    final hex = int.tryParse(normalizedHexString, radix: 16);
    if (hex == null) return null;
    return Color(hex);
  }
  //
  @override
  Color get color => fromHexString(_json['color']) ?? const Color(0x00000000);
  //
  @override
  Map<String, dynamic> asMap() => Map.from(_json);
}
