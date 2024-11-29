import 'package:sss_computing_client/core/models/general_parameter/parameter_value.dart';
///
/// [ParameterValue] that parses itself from json map.
class JsonParameterValue implements ParameterValue {
  ///
  /// Json representation of the [ParameterValue].
  final Map<String, dynamic> _json;
  ///
  /// Creates [ParameterValue] that parses itself from [json] map.
  JsonParameterValue({
    required Map<String, dynamic> json,
  }) : _json = json;
  ///
  /// Creates [JsonParameterValue] from sql [row].
  ///
  /// Row must have following structure:
  /// ```json
  /// {
  ///   "title": "title", // String
  ///   "value": 1.0, // double
  ///   "unit": "unit", // String?
  ///   "description": "description" // String?
  /// }
  /// ```
  factory JsonParameterValue.fromRow(Map<String, dynamic> row) =>
      JsonParameterValue(json: {
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
  Map<String, dynamic> asMap() => Map.from(_json);
}
