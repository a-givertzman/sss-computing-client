import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead.dart';
import 'package:sss_computing_client/core/models/hex_color.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
///
/// [Waypoint] that parses itself from json map.
class JsonWaypoint implements Waypoint {
  ///
  /// Default color for waypoint if not provided.
  static const Color defaultColor = Color(0x00000000);
  ///
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
  ///   "eta": "2022-01-01 00:00:00", // String
  ///   "etd": "2022-01-01 00:00:00", // String
  ///   "color": "#000000", // String
  ///   "draftLimit": 1.0, // double
  ///   "useDraftLimit": true // bool
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
          'draftLimit': row['draftLimit'] as double,
          'useDraftLimit': row['useDraftLimit'] as bool,
        },
      );
  ///
  /// Creates [JsonWaypoint] with default values.
  ///
  /// Some fields can be overridden by passed parameters.
  factory JsonWaypoint.emptyWith({
    String? portName,
    String? portCode,
    DateTime? eta,
    DateTime? etd,
    Color? color,
    double? draftLimit,
    bool? useDraftLimit,
  }) =>
      JsonWaypoint(
        json: {
          'id': -1,
          'projectId': -1,
          'shipId': -1,
          'portName': portName ?? '–',
          'portCode': portCode ?? '–',
          'eta': (eta ?? DateTime.now()).toString(),
          'etd': (etd ?? DateTime.now()).toString(),
          'color': color ?? '#000000',
          'draftLimit': draftLimit ?? 0.0,
          'useDraftLimit': useDraftLimit ?? false,
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
  @override
  Color get color => HexColor(_json['color'] as String).color();
  //
  @override
  double get draftLimit => _json['draftLimit'];
  //
  @override
  bool get useDraftLimit => _json['useDraftLimit'];
  //
  @override
  Map<String, dynamic> asMap() => Map.from(_json);
}
