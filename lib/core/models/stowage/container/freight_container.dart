import 'package:sss_computing_client/core/models/stowage/container/container_1a.dart';
import 'package:sss_computing_client/core/models/stowage/container/container_1aa.dart';
import 'package:sss_computing_client/core/models/stowage/container/container_1c.dart';
import 'package:sss_computing_client/core/models/stowage/container/container_1cc.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container_port.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container_type.dart';
///
/// Simple representation of freight container;
abstract interface class FreightContainer {
  ///
  /// Unique identifier of container.
  int get id;
  ///
  /// TODO: add doc
  int get serial;
  ///
  /// Size of container along the longitudinal axis, measured in m.
  double get width;
  ///
  /// Size of container along the transverse axis, measured in m.
  double get length;
  ///
  /// Size of container along the vertical axis, measured in m.
  double get height;
  ///
  /// Weight of empty container, measured in t.
  double get tareWeight;
  ///
  /// Weight of cargo inside container, measured in t.
  double get cargoWeight;
  ///
  /// Combined weight of container plus cargo, measured in t;
  double get grossWeight;
  ///
  /// Type of container.
  /// In accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html)
  FreightContainerType get type;
  /// TODO
  FreightContainerPort? get pol;
  /// TODO
  FreightContainerPort? get pod;
  ///
  /// Creates a [FreightContainer] instance based on its [sizeCode],
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
  factory FreightContainer.fromSizeCode(
    String sizeCode, {
    required int id,
    required int serial,
    double tareWeight = 0.0,
    double cargoWeight = 0.0,
  }) =>
      switch (sizeCode.trim().toUpperCase()) {
        '1A' => Container1A(
            id: id,
            serial: serial,
            tareWeight: tareWeight,
            cargoWeight: cargoWeight,
          ),
        '1C' => Container1C(
            id: id,
            serial: serial,
            tareWeight: tareWeight,
            cargoWeight: cargoWeight,
          ),
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
