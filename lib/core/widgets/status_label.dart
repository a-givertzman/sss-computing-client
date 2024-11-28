import 'package:flutter/material.dart';
///
/// Widget that shows status of voyage waypoint validity.
class StatusLabel extends StatelessWidget {
  final ThemeData _theme;
  final Color _errorColor;
  final Color _okColor;
  final String? _errorMessage;
  ///
  /// Creates widget that shows status of voyage waypoint validity.
  ///
  ///  * [theme] - theme to use for this widget
  ///  * [errorColor] - color to use for error icon
  ///  * [okColor] - color to use for ok icon
  ///  * [errorMessage] - error message to show, if validation failed
  const StatusLabel({
    super.key,
    required ThemeData theme,
    required Color errorColor,
    required Color okColor,
    String? errorMessage,
  })  : _theme = theme,
        _errorColor = errorColor,
        _okColor = okColor,
        _errorMessage = errorMessage;
  //
  @override
  Widget build(BuildContext context) {
    return _errorMessage != null
        ? Theme(
            data: _theme,
            child: Tooltip(
              message: _errorMessage,
              child: Icon(Icons.warning_amber_rounded, color: _errorColor),
            ),
          )
        : Icon(Icons.check_rounded, color: _okColor);
  }
}
