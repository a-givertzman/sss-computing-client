import 'package:flutter/material.dart';
///
/// Enum of [Cargo] types with colors and labels.
enum CargoType {
  ///
  /// "water ballast" in OCX:liquidCargoType
  ballast('Ballast tank', Colors.green, 'ballast_tank'),
  ///
  /// oils (e.g. vegetable oil, fuel oil) in OCX:liquidCargoType
  oilsAndFuels('Oils and fuels', Colors.brown, 'fuel_tank'),
  ///
  /// "fresh water" in OCX:liquidCargoType
  freshWater('Fresh water', Colors.blue, 'fresh_drinking_water_tank'),
  ///
  /// "ammonia" in OCX:liquidCargoType
  acidsAndAlkalis('Acids and alkalis', Colors.purple, 'urea_tank'),
  ///
  /// TODO: determine type based on the OCX standard
  pollutedLiquids('Polluted liquids', Colors.black, 'sundry_tank'),
  ///
  /// "general" in OCX:bulkCargoType
  bulkCargo('Bulk cargo', Colors.grey, 'bulk_cargo'),
  ///
  /// "grain" in OCX:bulkCargoType
  bulkCargoShiftable(
    'Bulk cargo, shiftable',
    Colors.grey,
    'bulk_cargo_shiftable',
  ),
  ///
  /// "unspecified" in OCX:unitCargoType
  other('Other', Colors.grey, 'other');
  ///
  /// Text label for cargo type
  final String label;
  ///
  /// Color of cargo
  final Color color;
  ///
  /// Unique String identifier for cargo type
  final String key;
  //
  const CargoType(this.label, this.color, this.key);
  ///
  /// Creates [CargoType] from passed string representation.
  factory CargoType.from(String value) {
    return CargoType.values.firstWhere(
      (type) => type.key == value,
      orElse: () => CargoType.other,
    );
  }
}
