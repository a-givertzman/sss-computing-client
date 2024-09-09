import 'package:sss_computing_client/core/models/bulkheads/bulkhead_place.dart';
///
/// [BulkheadPlace] that parses itself from json map.
class JsonBulkheadPlace implements BulkheadPlace {
  final Map<String, dynamic> _json;
  ///
  /// Creates [BulkheadPlace] that parses itself from provided `json` map.
  const JsonBulkheadPlace({
    required Map<String, dynamic> json,
  }) : _json = json;
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
  int? get bulkheadId => _json['bulkheadId'];
  //
  @override
  int get holdGroupId => _json['holdGroupId'];
  //
  @override
  Map<String, dynamic> asMap() => Map.from(_json);
}
