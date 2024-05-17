///
/// Common data for corresponding [Frame].
abstract interface class Frame {
  /// index of frame
  int get index;
  /// id of the ship for corresponding [Frame]
  int get shipId;
  /// id of the project for corresponding [Frame]
  int? get projectId;
  /// x coord of [Frame]
  double get x;
}
///
/// [Frame] that parses itself from json map.
final class JsonFrame implements Frame {
  final Map<String, dynamic> _json;
  /// [Frame] that parses itself from json map.
  const JsonFrame({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  int get index => _json['index'];
  //
  @override
  int get shipId => _json['shipId'];
  //
  @override
  int? get projectId => _json['projectId'];
  //
  @override
  double get x => _json['x'];
}
