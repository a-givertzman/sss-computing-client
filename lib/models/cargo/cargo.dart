///
/// Common data for corresponding cargo.
abstract interface class Cargo {
  int get id;
  // Name identificator of the cargo
  String get name;
  // Weight of the cargo
  double get weight;
}

///
/// [Cargo] that parses itself from json map.
final class JsonCargo implements Cargo {
  /// Json representaion of [Cargo].
  final Map<String, dynamic> _json;

  /// Creates [Cargo] that parses itself from json map.
  const JsonCargo({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  int get id => _json['id'];
  //
  @override
  String get name => _json['name'];
  //
  @override
  double get weight => _json['weight'];
}
