import 'package:sss_computing_client/core/models/stability_parameter/stability_parameter.dart';
///
/// [StabilityParameter] that parses itself from json map.
class JsonStabilityParameter implements StabilityParameter {
  ///
  /// Json representation of the [StabilityParameter].
  final Map<String, dynamic> _json;
  ///
  /// Creates [StabilityParameter] that parses itself from json map.
  JsonStabilityParameter({
    required Map<String, dynamic> json,
  }) : _json = json;
  ///
  /// Creates [JsonStabilityParameter] from sql row.
  ///
  /// Row must have following structure:
  /// ```json
  /// {
  ///   "title": String,
  ///   "value": double,
  ///   "unit": String?,
  ///   "description": String?,
  /// }
  /// ```
  factory JsonStabilityParameter.fromRow(Map<String, dynamic> row) =>
      JsonStabilityParameter(json: {
        'name': row['title'] as String,
        'value': row['value'] as double,
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
  String? get unit => _json['unit'];
  //
  @override
  String? get description => _json['description'];
  //
  @override
  Map<String, dynamic> asMap() {
    return _json;
  }
}
