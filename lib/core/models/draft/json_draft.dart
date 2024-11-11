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
  ///
  /// Creates [JsonDraft] from database [row].
  ///
  /// Row should have following format:
  /// ```json
  /// {
  ///   "shipId": 1, // int
  ///   "projectId": 1, // int?
  ///   "label": "Draft #1", // String
  ///   "value": 5.0, // double
  ///   "x": 0.0, // double
  ///   "y": 0.0, // double
  /// }
  /// ```
  factory JsonDraft.fromRow(Map<String, dynamic> row) => JsonDraft(
        json: {
          'shipId': row['shipId'] as int,
          'projectId': row['projectId'] as int?,
          'label': row['label'] as String,
          'value': row['value'] as double,
          'x': row['x'] as double,
          'y': row['y'] as double,
        },
      );
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
  Map<String, dynamic> asMap() => Map.from(_json);
}
