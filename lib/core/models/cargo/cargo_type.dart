import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
///
/// Extract label and color from [Cargo].
class CargoType {
  final Cargo _cargo;
  ///
  /// Creates object that extract label and color from [Cargo] type
  const CargoType({required Cargo cargo}) : _cargo = cargo;
  ///
  /// Extract type's label for [Cargo]
  String label() {
    return CargoTypeColorLabel.from(_cargo.type).label;
  }
  ///
  /// Extract type's color for [Cargo]
  Color color() {
    return CargoTypeColorLabel.from(_cargo.type).color;
  }
}
///
/// Enum of cargo types with colors and labels.
enum CargoTypeColorLabel {
  ballast('Ballast', Colors.green),
  oilsAndFuels('Oils and fuels', Colors.brown),
  freshWater('Fresh water', Colors.blue),
  acidsAndAlkalis('Acids and alkalis', Colors.purple),
  pollutedLiquids('Polluted liquids', Colors.black),
  other('Other', Colors.grey);
  final String label;
  final Color color;
  const CargoTypeColorLabel(this.label, this.color);
  ///
  /// Creates [CargoTypeColorLabel] from passed string.
  factory CargoTypeColorLabel.from(String value) {
    return switch (value) {
      'BALLAST' => CargoTypeColorLabel.ballast,
      'OILS_AND_FUELS' => CargoTypeColorLabel.oilsAndFuels,
      'FRESH_WATER' => CargoTypeColorLabel.freshWater,
      'ACIDS_AND_ALKALIS' => CargoTypeColorLabel.acidsAndAlkalis,
      'POLLUTED_LIQUIDS' => CargoTypeColorLabel.pollutedLiquids,
      _ => CargoTypeColorLabel.other,
    };
  }
}
