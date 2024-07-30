import 'package:sss_computing_client/core/models/draft/draft.dart';
///
/// [Draft] that parses itself from json map.
class JsonDraft implements Draft {
  /// Json representaion of the [Criterion].
  final Map<String, dynamic> _json;
  /// Creates [Criterion] that parses itself from json map.
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
