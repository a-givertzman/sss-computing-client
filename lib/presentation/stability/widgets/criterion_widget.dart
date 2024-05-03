import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class CriterionWidget extends StatelessWidget {
  final double _value;
  final double _limit;
  final String _label;
  final String _relation;
  final bool _passed;
  final String? _labelMessage;
  final String? _errorMessage;
  final String? _unit;
  final Color? _color;
  final Color? _passedColor;
  final Color? _errorColor;
  ///
  const CriterionWidget({
    super.key,
    required double value,
    required double limit,
    required String label,
    required String relation,
    required bool passed,
    String? labelMessage,
    String? errorMessage,
    String? unit,
    Color? color,
    Color? passedColor,
    Color? errorColor,
  })  : _value = value,
        _limit = limit,
        _label = label,
        _relation = relation,
        _passed = passed,
        _labelMessage = labelMessage,
        _errorMessage = errorMessage,
        _unit = unit,
        _color = color,
        _passedColor = passedColor,
        _errorColor = errorColor;
  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final color = _color ?? theme.colorScheme.onSurface;
    final passedColor = _passedColor ?? Colors.lightGreen;
    final errorColor = _errorColor ?? theme.alarmColors.class3;
    final padding = const Setting('padding').toDouble;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Tooltip(
                message: _labelMessage ?? '',
                child: Text(
                  '$_label${_unit != null ? ' [$_unit]' : ''}',
                  style: textStyle?.copyWith(color: color),
                ),
              ),
            ),
            SizedBox(width: padding),
            Expanded(
              flex: 1,
              child: Text(
                _limit.toStringAsFixed(3),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: textStyle?.copyWith(color: color),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                _relation,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textStyle?.copyWith(color: color),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                _value.toStringAsFixed(3),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: textStyle?.copyWith(color: color),
              ),
            ),
            SizedBox(width: padding),
            _passed
                ? Icon(
                    Icons.done,
                    color: passedColor,
                  )
                : Tooltip(
                    message: _errorMessage ?? '',
                    child: Icon(
                      Icons.error_outline,
                      color: errorColor,
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
