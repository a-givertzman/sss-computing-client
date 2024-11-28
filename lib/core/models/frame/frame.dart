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
  ///
  /// [Frame] that parses itself from json map.
  const JsonFrame({
    required Map<String, dynamic> json,
  }) : _json = json;
  ///
  /// [Frame] that parses itself from database [row]
  /// TODO: discuss concept of frame indexing
  factory JsonFrame.fromRow(Map<String, dynamic> row) => JsonFrame(json: {
        'shipId': row['shipId'] as int,
        'projectId': row['projectId'] as int?,
        'index': int.tryParse('${row['index']}') ?? -1,
        'x': row['x'] as double,
      });
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
