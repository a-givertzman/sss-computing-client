import 'package:flutter/material.dart';
///
/// Hold color represented by hex string.
class HexColor {
  static const Color _defaultColor = Colors.transparent;
  final String _hexString;
  ///
  /// Creates object that holds color represented by hex string.
  const HexColor(String hexString) : _hexString = hexString;
  ///
  /// Returns [Color] parsed from hex string,
  /// if parsing failed returns [orElse] or [_defaultColor].
  Color color({
    Color Function(String hexString)? orElse,
  }) =>
      _tryParseHex(_hexString) ?? orElse?.call(_hexString) ?? _defaultColor;
  ///
  /// Returns hex string representation of parsed color in standard format
  /// (`#AARRGGBB` or `AARRGGBB`).
  String toHexString({bool includeSharp = false}) =>
      '${includeSharp ? '#' : ''}${color().value.toRadixString(16)}';
  //
  Color? _tryParseHex(String text) {
    final normalizedHexString = text.replaceFirst('#', '');
    if (normalizedHexString.length != 8 && normalizedHexString.length != 6) {
      return null;
    }
    final hexValue = int.tryParse(
      normalizedHexString.padLeft(8, 'F'),
      radix: 16,
    );
    if (hexValue == null) return null;
    if (hexValue > int.parse('FFFFFFFF', radix: 16)) return null;
    return Color(hexValue);
  }
}
