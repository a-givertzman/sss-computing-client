///
/// Common data for corresponding [FrameSpace].
abstract interface class FrameSpace {
  /// index of frame
  int get index;
  /// id of the ship for corresponding [FrameSpace]
  int get shipId;
  /// id of the project for corresponding [FrameSpace]
  int? get projectId;
  /// x coord of left side of [FrameSpace]
  double get start;
  /// x coord of right side of [FrameSpace]
  double get end;
}
///
/// [FrameSpace] that parses itself from json map.
final class JsonFrameSpace implements FrameSpace {
  final Map<String, dynamic> _json;
  /// [FrameSpace] that parses itself from json map.
  const JsonFrameSpace({
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
  double get start => _json['start'];
  //
  @override
  double get end => _json['end'];
}
