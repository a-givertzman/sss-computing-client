import 'package:flutter/material.dart';
///
/// Enum of cargo types with colors and labels.
enum CargoType {
  ballast('Ballast', Colors.green),
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
      'BALLAST' => CargoType.ballast,
      'OILS_AND_FUELS' => CargoType.oilsAndFuels,
      'FRESH_WATER' => CargoType.freshWater,
      'ACIDS_AND_ALKALIS' => CargoType.acidsAndAlkalis,
      'POLLUTED_LIQUIDS' => CargoType.pollutedLiquids,
      _ => CargoType.other,
    };
  }
}
