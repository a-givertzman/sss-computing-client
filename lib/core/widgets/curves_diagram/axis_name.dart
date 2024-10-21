import 'package:flutter/material.dart';
///
/// Displays title for axis.
class AxisName extends StatelessWidget {
  final String _title;
  final String? _unit;
  final Color _color;
  /// Creates widget that displays axis title. Title text is generated
  /// based on passed [title] and [unit]. [color] sets color of rendered title.
  const AxisName({
    super.key,
    required String title,
    String? unit,
    required Color color,
  })  : _title = title,
        _unit = unit,
        _color = color;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelMedium ?? const TextStyle();
    return Text(
      '$_title${_unit != null ? ' [$_unit]' : ''}',
      style: textStyle.copyWith(color: _color),
    );
  }
}
