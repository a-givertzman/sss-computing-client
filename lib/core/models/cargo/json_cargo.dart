import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
///
/// [Cargo] that parses itself from json map.
class JsonCargo implements Cargo {
  final Map<String, dynamic> _json;
  ///
  /// Creates [Cargo] that parses itself from json map.
  const JsonCargo({
    required Map<String, dynamic> json,
  }) : _json = json;
  @override
  int get shipId => _json['shipId'];
  @override
  int? get projectId => _json['projectId'];
  @override
  int? get id => _json['id'];
  @override
  String? get name => _json['name'];
  @override
  double? get weight => _json['mass'];
  @override
  double? get vcg => _json['vcg'];
  @override
  double? get lcg => _json['lcg'];
  @override
  double? get tcg => _json['tcg'];
  @override
  double get x1 => _json['bound_x1'];
  @override
  double get x2 => _json['bound_x2'];
  @override
  double get y1 => _json['bound_y1'] ?? 0.0;
  @override
  double get y2 => _json['bound_y2'] ?? 0.0;
  @override
  double get z1 => _json['bound_z1'] ?? 0.0;
  @override
  double get z2 => _json['bound_z2'] ?? 0.0;
  @override
  double? get mfsx => _json['m_f_s_x'];
  @override
  double? get mfsy => _json['m_f_s_y'];
  @override
  String? get path => _json['path'];
  @override
  CargoType get type => CargoType.from(_json['type']);
  @override
  Map<String, dynamic> asMap() {
    return _json;
  }
  @override
  String toString() => _json.toString();
}
