import 'package:flutter/material.dart';
///
/// Object holding data for tab.
class TabSetting {
  final String _label;
  final Widget _content;
  final Widget? _icon;
  ///
  /// Creates object holding data for tab.
  ///
  ///   `label` and `icon` are used for tab title.
  ///   `content` - widget with content of tab.
  const TabSetting({
    required String label,
    required Widget content,
    Widget? icon,
  })  : _label = label,
        _content = content,
        _icon = icon;
  ///
  /// Returns tab label.
  String get label => _label;
  ///
  /// Returns tab icon.
  Widget? get icon => _icon;
  ///
  /// Returns content widget for tab.
  Widget get content => _content;
}
