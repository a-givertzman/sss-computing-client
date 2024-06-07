import 'package:sss_computing_client/core/models/metacentric_height/metacentric_height_limit.dart';
///
/// [MetacentricHeightLimit] that parses itself from json map.
final class JsonMetacentricHeightLimit implements MetacentricHeightLimit {
  final Map<String, dynamic> _json;
  /// Creates [MetacentricHeightLimit] that parses itself from json map.
  const JsonMetacentricHeightLimit({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  int get shipId => _json['shipId'];
  //
  @override
  int? get projectId => _json['projectId'];
  //
  @override
  double get dependentValue => _json['dependentValue'];
  //
  @override
  double get value => _json['low'];
}
