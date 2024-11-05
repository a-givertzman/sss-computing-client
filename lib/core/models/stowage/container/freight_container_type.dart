import 'package:flutter/material.dart';
///
/// Type of container.
/// In accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html)
enum FreightContainerType {
  ///
  /// 40 ft low standard height container,
  type1A('1A', 4, 0, Colors.blue),
  ///
  /// 40 ft standard height container,
  type1AA('1AA', 4, 2, Colors.blue),
  ///
  /// 40 ft high cube height container,
  type1AAA('1AAA', 4, 5, Colors.blue),
  ///
  /// 20 ft low standard height container,
  type1C('1C', 2, 0, Colors.green),
  ///
  /// 20 ft standard height container,
  type1CC('1CC', 2, 2, Colors.green),
  ///
  /// 20 ft low standard height container,
  type1CCC('1CCC', 2, 5, Colors.green);
  ///
  /// TODO
  final String isoCode;
  ///
  /// TODO
  final int lengthCode;
  ///
  /// TODO
  final int heightCode;
  ///
  /// TODO
  final Color color;
  ///
  /// TODO
  String get sizeCode => '$lengthCode$heightCode';
  ///
  /// Length of container in meters
  double get length => switch (lengthCode) {
        2 => 6.058,
        4 => 12.192,
        _ => double.nan,
      };
  ///
  /// Length of container in meters
  double get height => switch (heightCode) {
        0 => 2.438,
        2 => 2.591,
        5 => 2.896,
        _ => double.nan,
      };
  ///
  /// Width of container in meters
  double get width => 2.438;
  //
  const FreightContainerType(
    this.isoCode,
    this.lengthCode,
    this.heightCode,
    this.color,
  );
  ///
  /// Creates [FreightContainerType] from [sizeCode].
  ///
  /// If the [sizeCode] is not found, the [type1CC] (20ft standard height) is returned.
  factory FreightContainerType.fromSizeCode(String sizeCode) =>
      FreightContainerType.values.firstWhere(
        (type) => type.sizeCode == sizeCode,
        orElse: () => type1CC,
      );
}
