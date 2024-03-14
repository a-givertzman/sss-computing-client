///
/// Common data for corresponding cargo.
abstract interface class Cargo {
  int get id;
  // Name identificator of the cargo
  String get name;
  // Weight of the cargo
  double get weight;
  //
  double get vcg;
  //
  double get lcg;
  //
  double get tcg;
  //
  double get leftSideX;
  //
  double get rightSideX;
  //
  Cargo copyWith({
    int? id,
    String? name,
    double? weight,
    double? vcg,
    double? lcg,
    double? tcg,
    double? leftSideX,
    double? rightSideX,
  });
}

///
/// [Cargo] that parses itself from json map.
class JsonCargo implements Cargo {
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
  //
  @override
  double get vcg => _json['vcg'];
  //
  @override
  double get lcg => _json['lcg'];
  //
  @override
  double get tcg => _json['tcg'];
  //
  @override
  double get leftSideX => _json['leftSideX'];
  //
  @override
  double get rightSideX => _json['rightSideX'];
  @override
  // ignore: long-parameter-list
  Cargo copyWith({
    int? id,
    String? name,
    double? weight,
    double? vcg,
    double? lcg,
    double? tcg,
    double? leftSideX,
    double? rightSideX,
  }) {
    final json = {
      'id': id ?? _json['id'],
      'name': name ?? _json['name'],
      'weight': weight ?? _json['weight'],
      'vcg': vcg ?? _json['vcg'],
      'lcg': lcg ?? _json['lcg'],
      'tcg': tcg ?? _json['tcg'],
      'leftSideX': leftSideX ?? _json['leftSideX'],
      'rightSideX': rightSideX ?? _json['rightSideX'],
    };
    return JsonCargo(json: json);
  }

  @override
  String toString() {
    return {
      'id': _json['id'],
      'name': _json['name'],
      'weight': _json['weight'],
      'vcg': _json['vcg'],
      'lcg': _json['lcg'],
      'tcg': _json['tcg'],
      'leftSideX': _json['leftSideX'],
      'rightSideX': _json['rightSideX'],
    }.toString();
  }
}
