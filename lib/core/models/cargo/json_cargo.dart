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
  /// Creates [Cargo] that parses itself from [json] map.
  const JsonCargo({
    required Map<String, dynamic> json,
  }) : _json = json;
  ///
  /// Creates [Cargo] that parses itself from database [row].
  ///
  /// [row] should have the following structure:
  /// ```json
  /// {
  ///   "id": 1, // int?
  ///   "shipId": 1, // int
  ///   "projectId": 1, // int?
  ///   "name": "cargoName", // String?
  ///   "weight": 1.0, // double?
  ///   "volume": 1.0, // double?
  ///   "density": 1.0, // double?
  ///   "level": 1.0, // double?
  ///   "x1": 1.0, // double?
  ///   "x2": 2.0, // double?
  ///   "y1": 1.0, // double?
  ///   "y2": 2.0, // double?
  ///   "z1": 1.0, // double?
  ///   "z2": 2.0, // double?
  ///   "vcg": 1.0, // double?
  ///   "lcg": 1.0, // double?
  ///   "tcg": 1.0, // double?
  ///   "mfsx": 1.0, // double?
  ///   "mfsy": 1.0, // double?
  ///   "type": "cargoType", // String
  ///   "shiftable": true, // bool
  ///   "useMaxMfs": true, // bool
  ///   "isTimber": true, // bool
  ///   "isOnDeck": true, // bool
  ///   "path": "{
  ///     'xy': ${svgPathData}, // String
  ///     'yz': ${svgPathData}, // String
  ///     'xz': ${svgPathData}, // String
  ///   }", // String
  /// }
  /// ```
  factory JsonCargo.fromRow(Map<String, dynamic> row) => JsonCargo(json: {
        'id': row['id'] as int?,
        'shipId': row['shipId'] as int,
        'projectId': row['projectId'] as int?,
        'name': row['name'] as String?,
        'weight': row['mass'] as double?,
        'volume': row['volume'] as double?,
        'density': row['density'] as double?,
        'level': row['level'] as double?,
        'x1': row['x1'] as double,
        'x2': row['x2'] as double,
        'y1': row['y1'] as double?,
        'y2': row['y2'] as double?,
        'z1': row['z1'] as double?,
        'z2': row['z2'] as double?,
        'vcg': row['vcg'] as double?,
        'lcg': row['lcg'] as double?,
        'tcg': row['tcg'] as double?,
        'mfsx': row['mfsx'] as double?,
        'mfsy': row['mfsy'] as double?,
        'type': row['type'] as String,
        'shiftable': (row['shiftable'] ?? false) as bool,
        'useMaxMfs': (row['useMaxMfs'] ?? false) as bool,
        'isOnDeck': (row['isOnDeck'] ?? false) as bool,
        'isTimber': (row['isTimber'] ?? false) as bool,
        'path': row['path'] as String?,
      });
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
  double? get y1 => _json['y1'];
  //
  @override
  double? get y2 => _json['y2'];
  //
  @override
  double? get z1 => _json['z1'];
  //
  @override
  double? get z2 => _json['z2'];
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
  bool get isOnDeck => _json['isOnDeck'];
  //
  @override
  bool get isTimber => _json['isTimber'];
  //
  @override
  Map<String, dynamic> asMap() => Map.from(_json);
  //
  @override
  String toString() => _json.toString();
}
