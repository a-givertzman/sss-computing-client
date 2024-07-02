import 'package:sss_computing_client/core/models/stability_parameter/stability_parameter.dart';
///
/// [StabilityParameter] that parses itself from json map.
class JsonStabilityParameter implements StabilityParameter {
  /// Json representaion of the [StabilityParameter].
  final Map<String, dynamic> _json;
  /// Creates [StabilityParameter] that parses itself from json map.
  JsonStabilityParameter({
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
