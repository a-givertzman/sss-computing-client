import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/criterion/criterion.dart';
import 'package:sss_computing_client/core/models/criterion/number_math_relation.dart';
///
class CriterionsSummary extends StatelessWidget {
  final List<Criterion> _criterions;
  final Color? _passedColor;
  final Color? _errorColor;
  final TextStyle? _textStyle;
  ///
  const CriterionsSummary({
    super.key,
    required List<Criterion> criterions,
    Color? passedColor,
    Color? errorColor,
    TextStyle? textStyle,
  })  : _criterions = criterions,
        _passedColor = passedColor,
        _errorColor = errorColor,
        _textStyle = textStyle;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = _textStyle ?? theme.textTheme.bodyLarge;
    final passedColor = _passedColor ?? Colors.lightGreen;
    final errorColor = _errorColor ?? theme.stateColors.alarm;
    final summary = _getSummary(_criterions);
    final passed = summary.where((passed) => passed);
    final failed = summary.where((passed) => !passed);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _SummaryItem(
          value: passed.length,
          message:
              '${passed.length} ${const Localized('criteria successfully passed').v}',
          color: passedColor,
          icon: Icons.check_circle_outline,
          style: textStyle,
        ),
        const SizedBox(width: 4.0),
        _SummaryItem(
          value: failed.length,
          message: '${failed.length} ${const Localized('criteria failed').v}',
          color: errorColor,
          icon: Icons.error_outline,
          style: textStyle,
        ),
      ],
    );
  }
  ///
  List<bool> _getSummary(List<Criterion> criterions) {
    return _criterions
        .map((criterion) => switch (
                NumberMathRelation.fromString(criterion.relation)
                    .process(criterion.value, criterion.limit)) {
              Ok(value: final isPassed) => isPassed,
              _ => false,
            })
        .toList();
  }
}
///
class _SummaryItem extends StatelessWidget {
  final int value;
  final Color color;
  final IconData icon;
  final TextStyle? style;
  final String message;
  ///
  const _SummaryItem({
    required this.value,
    required this.color,
    required this.icon,
    required this.style,
    required this.message,
  });
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding', factor: 0.5).toDouble;
    return Tooltip(
      message: message,
      child: Row(
        children: [
          Icon(icon, color: color, size: style?.fontSize),
          SizedBox(width: padding),
          Text(
            '$value',
            style: style?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
