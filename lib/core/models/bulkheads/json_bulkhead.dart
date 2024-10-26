import 'package:sss_computing_client/core/models/bulkheads/bulkhead.dart';
///
/// [Bulkhead] that parses itself from json map.
class JsonBulkhead implements Bulkhead {
  final Map<String, dynamic> _json;
  ///
  /// Creates [Bulkhead] that parses itself from provided [json] map.
  const JsonBulkhead({
    required Map<String, dynamic> json,
  }) : _json = json;
  ///
  /// Creates [JsonBulkhead] from database row.
  ///
  /// Row should have following format:
  /// ```json
  /// {
  ///   "id": 1, // int
  ///   "project_id": 1, // int?
  ///   "ship_id": 1, // int
  ///   "name": "Bulkhead #1", // String
  ///   "mass": 5.0 // double?
  ///   "lcg": 0.0 // double?
  ///   "tcg": 0.0 // double?
  ///   "vcg": 0.0 // double?
  /// }
  /// ```
  factory JsonBulkhead.fromRow(Map<String, dynamic> row) => JsonBulkhead(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int?,
          'shipId': row['shipId'] as int,
          'name': row['name'] as String,
          'mass': row['mass'] as double?,
          'lcg': row['lcg'] as double?,
          'tcg': row['tcg'] as double?,
          'vcg': row['vcg'] as double?,
        },
      );
  //
  @override
  int get id => _json['id'];
  //
  @override
  int? get projectId => _json['projectId'];
  //
  @override
  int get shipId => _json['shipId'];
  //
  @override
  String get name => _json['name'];
  //
  @override
  double? get mass => _json['mass'];
  //
  @override
  double? get lcg => _json['lcg'];
  //
  @override
  double? get tcg => _json['tcg'];
  //
  @override
  double? get vcg => _json['vcg'];
  //
  @override
  Map<String, dynamic> asMap() => Map.from(_json);
}
