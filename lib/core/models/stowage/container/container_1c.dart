import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container_port.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container_type.dart';
///
/// 20 ft container with TODO height,
/// in accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html)
class Container1C implements FreightContainer {
  final double _tareWeight;
  final double _cargoWeight;
  //
  @override
  final int id;
  //
  @override
  final int serial;
  //
  @override
  final FreightContainerPort? pol;
  //
  @override
  final FreightContainerPort? pod;
  ///
  /// Creates 20 ft container with TODO height.
  /// Gross weight of container is calculated
  /// as the sum of [tareWeight] (tons) and [cargoWeight] (tons).
  const Container1C({
    required this.id,
    required this.serial,
    this.pol,
    this.pod,
    double tareWeight = 0.0,
    double cargoWeight = 0.0,
  })  : _tareWeight = tareWeight,
        _cargoWeight = cargoWeight;
  //
  @override
  double get width => 2438 / 1000;
  //
  @override
  double get length => 6058 / 1000;
  //
  @override
  double get height => 2438 / 1000;
  //
  @override
  double get grossWeight => _tareWeight + _cargoWeight;
  //
  @override
  double get tareWeight => _tareWeight;
  //
  @override
  double get cargoWeight => _cargoWeight;
  //
  @override
  FreightContainerType get type => FreightContainerType.type1C;
}
