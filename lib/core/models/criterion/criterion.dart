///
/// Common data for corresponding [Criterion].
abstract interface class Criterion {
  /// Name of [Criterion]
  String get name;
  /// Value of [Criterion]
  double get value;
  /// Limit of value for [Criterion]
  double get limit;
  /// Relation between value and limit for [Criterion]
  String get relation;
  /// Unit of value for [Criterion]
  String? get unit;
  /// Additional description for [Criterion]
  String? get description;
  /// Returns [Map] representation of [Criterion]
  Map<String, dynamic> asMap();
}
///
/// [Criterion] that parses itself from json map.
class JsonCriterion implements Criterion {
  /// Json representaion of the [Criterion].
  final Map<String, dynamic> _json;
  /// Creates [Criterion] that parses itself from json map.
  JsonCriterion({
    required Map<String, dynamic> json,
  })  : _json = json,
        assert(
          json.containsKey('name') && json['name'] is String,
          'json must contains name key with String value',
        ),
        assert(
          json.containsKey('value') && json['value'] is double,
          'json must contains value key with double value',
        ),
        assert(
          json.containsKey('limit') && json['limit'] is double,
          'json must contains limit key with double value',
        ),
        assert(
          json.containsKey('relation') && json['relation'] is String,
          'json must contains relation key with String value',
        );
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
  String? get unit => _json.containsKey('unit') ? _json['unit'] : null;
  //
  @override
  String? get description =>
      _json.containsKey('description') ? _json['description'] : null;
  //
  @override
  Map<String, dynamic> asMap() {
    return _json;
  }
}
