import 'package:sss_computing_client/core/models/weight/displacement_weight.dart';
///
///  [DisplacementWeight] that parses itself from json map.
class JsonDisplacementWeight implements DisplacementWeight {
  final Map<String, dynamic> _json;
  ///
  /// Creates [DisplacementWeight] that parses itself from [json] map.
  const JsonDisplacementWeight(Map<String, dynamic> json) : _json = json;
  ///
  /// Creates [JsonDisplacementWeight] from database [row].
  ///
  /// [row] should have the following format:
  /// ```json
  /// {
  ///   "name": "name", // String
  ///   "value": 0.0, // double?
  ///   "unit": "unit", // String?
  ///   "lcg": 0.0, // double?
  ///   "vcg": 0.0, // double?
  ///   "tcg": 0.0, // double?
  ///   "vcgCorrection": 0.0, // double?
  ///   "asHeader": false, // bool
  ///   "asSubitem": false, // bool
  /// }
  /// ```
  factory JsonDisplacementWeight.fromRow(Map<String, dynamic> row) =>
      JsonDisplacementWeight({
        'name': row['name'] as String,
        'value': row['value'] as double?,
        'lcg': row['lcg'] as double?,
        'vcg': row['vcg'] as double?,
        'tcg': row['tcg'] as double?,
        'vcgCorrection': row['vcgCorrection'] as double?,
        'asHeader': row['asHeader'] as bool,
        'asSubitem': row['asSubitem'] as bool,
      });
  //
  @override
  String get name => _json['name'];
  //
  @override
  bool get asHeader => _json['asHeader'];
  //
  @override
  bool get asSubitem => _json['asSubitem'];
  //
  @override
  double? get value => _json['value'];
  //
  @override
  double? get lcg => _json['lcg'];
  //
  @override
  double? get vcg => _json['vcg'];
  //
  @override
  double? get tcg => _json['tcg'];
  //
  @override
  double? get vcgCorrection => _json['vcgCorrection'];
}
