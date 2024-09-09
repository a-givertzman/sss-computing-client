import 'package:flutter/material.dart';
///
/// Enum of cargo types with colors and labels.
enum CargoType {
  ballast('Ballast tank', Colors.green, 'ballast_tank'),
  oilsAndFuels('Oils and fuels', Colors.brown, 'fuel_tank'),
  freshWater('Fresh water', Colors.blue, 'fresh_drinking_water_tank'),
  acidsAndAlkalis('Acids and alkalis', Colors.purple, 'urea_tank'),
  pollutedLiquids('Polluted liquids', Colors.black, 'sundry_tank'),
  bulkCargo('Bulk cargo', Colors.grey, 'bulk_cargo'),
  bulkCargoShiftable(
    'Bulk cargo, shiftable',
    Colors.grey,
    'bulk_cargo_shiftable',
  ),
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
  ///
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
