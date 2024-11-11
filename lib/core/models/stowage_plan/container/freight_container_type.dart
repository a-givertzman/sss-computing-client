import 'package:flutter/material.dart';
///
/// Type of container.
/// In accordance with [ISO 668](https://www.iso.org/ru/standard/76912.html)
enum FreightContainerType {
  ///
  /// 40 ft low standard height container,
  type1A(
    '1A',
    _fourtyFtLengthCode,
    _lowStandardHeightCode,
    _fourtyFtColor,
  ),
  ///
  /// 40 ft standard height container,
  type1AA(
    '1AA',
    _fourtyFtLengthCode,
    _standardHeightCode,
    _fourtyFtColor,
  ),
  ///
  /// 40 ft high cube height container,
  type1AAA(
    '1AAA',
    _fourtyFtLengthCode,
    _highCubeHeightCode,
    _fourtyFtColor,
  ),
  ///
  /// 20 ft low standard height container,
  type1C(
    '1C',
    _twentyFtLengthCode,
    _lowStandardHeightCode,
    _twentyFtColor,
  ),
  ///
  /// 20 ft standard height container,
  type1CC(
    '1CC',
    _twentyFtLengthCode,
    _standardHeightCode,
    _twentyFtColor,
  ),
  ///
  /// 20 ft low standard height container,
  type1CCC(
    '1CCC',
    _twentyFtLengthCode,
    _highCubeHeightCode,
    _twentyFtColor,
  );
  /// Length code of 20ft container
  static const int _twentyFtLengthCode = 2;
  /// Length code of 40ft container
  static const int _fourtyFtLengthCode = 4;
  /// Height code of low standard height container
  static const int _lowStandardHeightCode = 0;
  /// Height code of standard height container
  static const int _standardHeightCode = 2;
  /// Height code of high cube height container
  static const int _highCubeHeightCode = 5;
  /// Color of 20ft container
  static const Color _twentyFtColor = Colors.green;
  /// Color of 40ft container
  static const Color _fourtyFtColor = Colors.blue;
  /// Length of 20ft container, measured in meters
  static const double _twentyFtLength = 6.058;
  /// Length of 40ft container, measured in meters
  static const double _fourtyFtLength = 12.192;
  /// Height of low standard height container, measured in meters
  static const double _lowStandardHeight = 2.438;
  /// Height of standard height container, measured in meters
  static const double _standardHeight = 2.591;
  /// Height of high cube container, measured in meters
  static const double _highCubeHeight = 2.896;
  /// Width of container, measured in meters
  static const double _width = 2.438;
  ///
  /// ISO code of container
  final String isoCode;
  ///
  /// Length code of container
  final int lengthCode;
  ///
  /// Height code of container
  final int heightCode;
  ///
  /// Color to be used for container of this type
  final Color color;
  ///
  /// Size code of container (combination of length and height codes)
  String get sizeCode => '$lengthCode$heightCode';
  ///
  /// Length of container, measured in meters
  double get length => switch (lengthCode) {
        _twentyFtLengthCode => _twentyFtLength,
        _fourtyFtLengthCode => _fourtyFtLength,
        _ => double.nan,
      };
  ///
  /// Length of container, measured in meters
  double get height => switch (heightCode) {
        _lowStandardHeightCode => _lowStandardHeight,
        _standardHeightCode => _standardHeight,
        _highCubeHeightCode => _highCubeHeight,
        _ => double.nan,
      };
  ///
  /// Width of container, measured in meters
  double get width => _width;
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
