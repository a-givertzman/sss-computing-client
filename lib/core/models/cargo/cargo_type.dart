import 'package:flutter/material.dart';
///
/// Enum of cargo types with colors and labels.
enum CargoType {
  ballast('Ballast tank', Colors.green),
  oilsAndFuels('Oils and fuels', Colors.brown),
  freshWater('Fresh water', Colors.blue),
  acidsAndAlkalis('Acids and alkalis', Colors.purple),
  pollutedLiquids('Polluted liquids', Colors.black),
  other('Other', Colors.grey);
  ///
  /// Text label for cargo type
  final String label;
  ///
  /// Color of cargo
  final Color color;
  ///
  const CargoType(this.label, this.color);
  ///
  /// Creates [CargoType] from passed string representation.
  factory CargoType.from(String value) {
    return switch (value) {
      'ballast_tank' => CargoType.ballast,
      'fuel_tank' => CargoType.oilsAndFuels,
      'lubricating_oil_tank' => CargoType.oilsAndFuels,
      'fresh_drinking_water_tank' => CargoType.freshWater,
      'urea_tank' => CargoType.acidsAndAlkalis,
      'sundry_tank' => CargoType.pollutedLiquids,
      _ => CargoType.other,
    };
  }
}
