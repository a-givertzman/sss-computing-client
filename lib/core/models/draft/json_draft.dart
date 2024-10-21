import 'package:sss_computing_client/core/models/draft/draft.dart';
///
/// [Draft] that parses itself from json map.
class JsonDraft implements Draft {
  final Map<String, dynamic> _json;
  ///
  /// Creates [Draft] that parses itself from provided json.
  JsonDraft({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  int? get projectId => _json['projectId'];
  //
  @override
  int get shipId => _json['shipId'];
  //
  @override
  String get label => _json['label'];
  //
  @override
  double get value => _json['value'];
  //
  @override
  double get x => _json['x'];
  //
  @override
  double get y => _json['y'];
  //
  @override
  Map<String, dynamic> asMap() => _json;
}
