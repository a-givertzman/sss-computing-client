import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
///
/// Common data for corresponding [Cargo].
abstract interface class Cargo {
  ///
  /// ID of the ship for [Cargo]
  int get shipId;
  ///
  /// ID of the project for [Cargo]
  int? get projectId;
  ///
  /// ID of the [Cargo]
  int? get id;
  ///
  /// Name identificator of the [Cargo]
  String? get name;
  ///
  /// Weight of the cargo
  double? get weight;
  ///
  /// Volume of the cargo
  double? get volume;
  ///
  /// Density of the cargo
  double? get density;
  ///
  /// Stowage factor of the cargo
  double? get stowageFactor;
  ///
  /// Level of the cargo
  double? get level;
  ///
  /// Vertital Center of Gravity of the [Cargo]
  double? get vcg;
  ///
  /// Longitudinal Center of Gravity
  double? get lcg;
  ///
  /// Transversal Center of Gravity
  double? get tcg;
  ///
  /// Offset of the left [Cargo] side from the midship
  double get x1;
  ///
  /// Offset of the right [Cargo] side from the midship
  double get x2;
  ///
  /// Offset of the near [Cargo] side from the midship
  double get y1;
  ///
  /// Offset of the far [Cargo] side from the midship
  double get y2;
  ///
  /// Offset of the bottom [Cargo] side from the midship
  double get z1;
  ///
  /// Offset of the top [Cargo] side from the midship
  double get z2;
  ///
  /// x-moment of inertia of the free surface of the water
  double? get mfsx;
  ///
  /// y-moment of inertia of the free surface of the water
  double? get mfsy;
  ///
  /// type of the cargo
  CargoType get type;
  ///
  /// TODO: update doc
  String? get path;
  ///
  /// Returns [Map] representation of the [Cargo]
  Map<String, dynamic> asMap();
}
