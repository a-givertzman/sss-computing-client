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
  double get x_1;
  //
  double get x_2;
  //
  Cargo copyWith({
    int? id,
    String? name,
    double? weight,
    double? vcg,
    double? lcg,
    double? tcg,
    double? x_1,
    double? x_2,
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
  double get x_1 => _json['x_1'];
  //
  @override
  double get x_2 => _json['x_2'];
  @override
  // ignore: long-parameter-list
  Cargo copyWith({
    int? id,
    String? name,
    double? weight,
    double? vcg,
    double? lcg,
    double? tcg,
    double? x_1,
    double? x_2,
  }) {
    final json = {
      'id': id ?? _json['id'],
      'name': name ?? _json['name'],
      'weight': weight ?? _json['weight'],
      'vcg': vcg ?? _json['vcg'],
      'lcg': lcg ?? _json['lcg'],
      'tcg': tcg ?? _json['tcg'],
      'x_1': x_1 ?? _json['x_1'],
      'x_2': x_2 ?? _json['x_2'],
    };
    return JsonCargo(json: json);
  }

  @override
  String toString() => _json.toString();
}
