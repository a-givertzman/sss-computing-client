import 'package:sss_computing_client/core/models/criterion/criterion.dart';
///
/// [Criterion] that parses itself from json map.
class JsonCriterion implements Criterion {
  ///
  /// Json representation of the [Criterion].
  final Map<String, dynamic> _json;
  ///
  /// Creates [Criterion] that parses itself from json map.
  JsonCriterion({
    required Map<String, dynamic> json,
  }) : _json = json;
  ///
  /// Creates [JsonCriterion] from sql row.
  ///
  /// Row should have following format:
  ///
  /// ```json
  /// {
  ///   "name": "name", // String
  ///   "value": 0.0, // double
  ///   "limit": 0.0, // double
  ///   "relation": "relation", // String
  ///   "unit": "unit", // String?
  ///   "description": "description", // String?
  /// }
  /// ```
  factory JsonCriterion.fromRow(Map<String, dynamic> row) =>
      JsonCriterion(json: {
        'name': row['name'] as String,
        'value': row['value'] as double,
        'limit': row['limit'] as double,
        'relation': row['relation'] as String,
        'unit': row['unit'] as String?,
        'description': row['description'] as String?,
      });
  //
  @override
  String get name => _json['name'];
  //
  @override
  double get value => _json['value'];
  //
  @override
  double get limit => _json['limit'];
  //
  @override
  String get relation => _json['relation'];
  //
  @override
  String? get unit => _json['unit'];
  //
  @override
  String? get description => _json['description'];
  //
  @override
  Map<String, dynamic> asMap() => Map.from(_json);
}
