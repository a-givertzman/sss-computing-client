import 'dart:ui';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/hex_color.dart';
///
/// Extension methods for [Setting]
extension SettingExt on Setting {
  ///
  /// Parses [Setting] value with hex string and returns [Color]
  Color toColor() {
    final hexString = toString();
    return HexColor(hexString).color();
  }
}
