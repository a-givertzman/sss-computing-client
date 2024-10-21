import 'dart:convert';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
import 'package:sss_computing_client/core/models/figure/json_svg_path_projections.dart';
import 'package:sss_computing_client/core/models/figure/path_projections.dart';
///
/// [Cargo] that parses itself from json map.
class JsonCargo implements Cargo {
  final Map<String, dynamic> _json;
  ///
  /// Creates [Cargo] that parses itself from json map.
  const JsonCargo({
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
  int? get id => _json['id'];
  //
  @override
  String? get name => _json['name'];
  //
  @override
  double? get weight => _json['weight'];
  //
  @override
  double? get volume => _json['volume'];
  //
  @override
  double? get density => _json['density'];
  //
  @override
  double? get stowageFactor => _json['stowageFactor'];
  //
  @override
  double? get level => _json['level'];
  //
  @override
  double? get vcg => _json['vcg'];
  //
  @override
  double? get lcg => _json['lcg'];
  //
  @override
  double? get tcg => _json['tcg'];
  //
  @override
  double get x1 => _json['x1'];
  //
  @override
  double get x2 => _json['x2'];
  //
  @override
  double get y1 => _json['y1'] ?? 0.0;
  //
  @override
  double get y2 => _json['y2'] ?? 0.0;
  //
  @override
  double get z1 => _json['z1'] ?? 0.0;
  //
  @override
  double get z2 => _json['z2'] ?? 0.0;
  //
  @override
  double? get mfsx => _json['mfsx'];
  //
  @override
  double? get mfsy => _json['mfsy'];
  //
  @override
  bool get useMaxMfs => _json['useMaxMfs'];
  //
  @override
  PathProjections? get paths => switch (_json['path']) {
        String jsonString => JsonSvgPathProjections(
            json: json.decode(jsonString),
          ),
        _ => null,
      };
  //
  @override
  CargoType get type => CargoType.from(_json['type']);
  //
  @override
  bool get shiftable => _json['shiftable'];
  //
  @override
  Map<String, dynamic> asMap() => Map.from(_json);
  //
  @override
  String toString() => _json.toString();
}
