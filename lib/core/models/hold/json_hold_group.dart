import 'package:sss_computing_client/core/models/hold/hold_group.dart';
///
/// [JsonHoldGroup] that parses itself from json.
class JsonHoldGroup implements HoldGroup {
  final Map<String, dynamic> _json;
  ///
  /// Creates [JsonHoldGroup] that parses itself from provided json.
  const JsonHoldGroup({
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
