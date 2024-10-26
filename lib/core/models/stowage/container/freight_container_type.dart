import 'package:flutter/material.dart';
///
/// Type of container.
/// In accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html)
enum FreightContainerType {
  ///
  /// 40 ft container with TODO height,
  type1A('1A', '40', Colors.blue),
  ///
  /// 20 ft container with TODO height,
  type1C('1C', '20', Colors.green),
  ///
  /// 40 ft container with standard height,
  type1AA('1AA', '42', Colors.blue),
  ///
  /// 20 ft container with standard height,
  type1CC('1CC', '22', Colors.green);
  //
  final String isoName;
  //
  final String lengthCode;
  //
  final Color color;
  ///
  const FreightContainerType(this.isoName, this.lengthCode, this.color);
}
