///
/// Common data for corresponding [Cargo].
abstract interface class Cargo {
  ///
  int? get id;

  ///
  int get idx;

  /// Name identificator of the [Cargo]
  String get name;
  // Weight of the cargo
  double get weight;

  /// Vertital Center of Gravity of the [Cargo]
  double get vcg;

  /// Longitudinal Center of Gravity
  double get lcg;

  /// Transversal Center of Gravity
  double get tcg;

  /// Offset of the left [Cargo] side from the midship
  double get x_1;

  /// Offset of the right [Cargo] side from the midship
  double get x_2;

  /// Returns [Map] representation of the [Cargo]
  Map<String, dynamic> asMap();
}

///
/// [Cargo] that parses itself from json map.
class JsonCargo implements Cargo {
  /// Json representaion of the [Cargo].
  final Map<String, dynamic> _json;

  /// Creates [Cargo] that parses itself from json map.
  const JsonCargo({
    required Map<String, dynamic> json,
  }) : _json = json;
  @override
  int? get id => _json['id'];
  @override
  int get idx => _json['idx'];
  @override
  String get name => _json['name'];
  @override
  double get weight => _json['weight'];
  @override
  double get vcg => _json['vcg'];
  @override
  double get lcg => _json['lcg'];
  @override
  double get tcg => _json['tcg'];
  @override
  double get x_1 => _json['x_1'];
  @override
  double get x_2 => _json['x_2'];
  @override
  Map<String, dynamic> asMap() {
    return _json;
  }

  @override
  String toString() => _json.toString();
}
