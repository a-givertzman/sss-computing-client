import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
///
/// Widget that shows label for using draft limit and allows to change it.
class UseDraftLimitLabel extends StatelessWidget {
  final bool _useDraftLimit;
  final void Function(bool value) _updateUseDraftLimit;
  final ThemeData _theme;
  ///
  /// Creates widget that shows label for using draft limit and allows to change it,
  /// [updateUseDraftLimit] is called when value is changed.
  ///
  /// [theme] used for styling this widget.
  const UseDraftLimitLabel({
    super.key,
    required bool useDraftLimit,
    required void Function(bool value) updateUseDraftLimit,
    required ThemeData theme,
  })  : _useDraftLimit = useDraftLimit,
        _updateUseDraftLimit = updateUseDraftLimit,
        _theme = theme;
  //
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _theme,
      child: Tooltip(
        message: _useDraftLimit
            ? const Localized('Draft limit is used').v
            : const Localized('Draft limit is not used').v,
        child: Checkbox(
          value: _useDraftLimit,
          onChanged: (value) => _updateUseDraftLimit(value ?? false),
        ),
      ),
    );
  }
}
