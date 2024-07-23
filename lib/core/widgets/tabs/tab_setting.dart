import 'package:flutter/material.dart';
///
class TabSetting {
  final String label;
  final Widget content;
  final Widget? icon;
  ///
  const TabSetting({
    required this.label,
    required this.content,
    this.icon,
  });
}
