import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/stowage/container/container_1aa.dart';
import 'package:sss_computing_client/core/models/stowage/container/container_1cc.dart';
///
/// Simple representation of freight container;
abstract interface class Container {
  ///
  /// Unique identifier of container.
  int get id;
  ///
  /// Serial number of container.
  int get serial;
  ///
  /// Size of container along the longitudinal axis, measured in mm.
  int get width;
  ///
  /// Size of container along the transverse axis, measured in mm.
  int get length;
  ///
  /// Size of container along the vertical axis, measured in mm.
  int get height;
  ///
  /// Tare weight of container, measured in t;
  double get tareWeight;
  ///
  /// Weight of cargo inside container, measured in t;
  double get cargoWeight;
  ///
  /// Combined weight of container plus cargo, measured in t;
  double get grossWeight;
  ///
  /// Type data of container in accordance with
  /// [ISO 668](https://www.iso.org/ru/standard/76912.html).
  ContainerType get type;
  ///
  /// Creates a [Container] instance based on its [sizeCode],
  /// as defined in [ISO 668](https://www.iso.org/ru/standard/76912.html).
  ///
  /// The [sizeCode] should be a string representing the container size and type
  /// (e.g., '1AA' for a 40ft standard container, '1CC' for a 20ft standard container).
  ///
  /// The [id] parameter specifies the unique identifier of the container.
  ///
  /// The [tareWeight] (tons) and [cargoWeight] (tons) parameters specify weight of empty
  /// container and weight of cargo inside container, respectively.
  /// The gross weight of container is calculated as the sum of these two weights.
  ///
  /// Throws an [ArgumentError] if the [sizeCode] is invalid.
  factory Container.fromSizeCode(
    String sizeCode, {
    required int id,
    int serial = 0,
    double tareWeight = 0.0,
    double cargoWeight = 0.0,
  }) =>
      switch (sizeCode.trim().toUpperCase()) {
        '1AA' => Container1AA(
            id: id,
            serial: serial,
            tareWeight: tareWeight,
            cargoWeight: cargoWeight,
          ),
        '1CC' => Container1CC(
            id: id,
            serial: serial,
            tareWeight: tareWeight,
            cargoWeight: cargoWeight,
          ),
        _ => throw ArgumentError(sizeCode, 'sizeCode'),
      };
}
///
enum ContainerType {
  ///
  type1AA('1AA', 42, Colors.blue),
  ///
  type1CC('1CC', 22, Colors.green);
  //
  final String isoName;
  //
  final int lengthCode;
  //
  final Color color;
  ///
  const ContainerType(this.isoName, this.lengthCode, this.color);
}
