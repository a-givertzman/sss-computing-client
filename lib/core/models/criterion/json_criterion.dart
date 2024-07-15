import 'package:sss_computing_client/core/models/criterion/criterion.dart';
///
/// [Criterion] that parses itself from json map.
class JsonCriterion implements Criterion {
  /// Json representaion of the [Criterion].
  final Map<String, dynamic> _json;
  /// Creates [Criterion] that parses itself from json map.
  JsonCriterion({
    required Map<String, dynamic> json,
  }) : _json = json;
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
  Map<String, dynamic> asMap() {
    return _json;
  }
}
