import 'package:sss_computing_client/core/models/bulkheads/bulkhead.dart';
///
class JsonBulkhead implements Bulkhead {
  final Map<String, dynamic> _json;
  ///
  const JsonBulkhead({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  int? get id => _json['id'];
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
  Map<String, dynamic> asMap() => Map.from(_json);
}
