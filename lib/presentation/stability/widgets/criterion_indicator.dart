import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/criterion/criterion.dart';
import 'package:sss_computing_client/core/models/number_math_relation/number_math_relation.dart';
///
/// Widget that check criterion and
/// displays it data in readable view.
class CriterionIndicator extends StatelessWidget {
  final Criterion _criterion;
  ///
  /// Creates widget that check criterion and
  /// displays it data in readable view.
  const CriterionIndicator({
    super.key,
    required Criterion criterion,
  }) : _criterion = criterion;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final criterionRelation =
        NumberMathRelation.fromString(_criterion.relation);
    final criterionPassStatus = criterionRelation.process(
      _criterion.value,
      _criterion.limit,
    );
    return switch (criterionPassStatus) {
      Ok(value: final isPassed) => _CriterionIndicatorView(
          value: _criterion.value,
          limit: _criterion.limit,
          relation: criterionRelation.operator,
          passed: isPassed,
          errorMessage: isPassed
              ? const Localized(
                  'criterion passed',
                ).v
              : const Localized(
                  'criterion failed',
                ).v,
          label: _criterion.name,
          labelMessage: _criterion.description,
          unit: _criterion.unit != null ? Localized(_criterion.unit!).v : null,
        ),
      Err(:final error) => _CriterionIndicatorView(
          value: _criterion.value,
          limit: _criterion.limit,
          relation: criterionRelation.operator,
          passed: false,
          errorMessage: error.message,
          errorColor: theme.alarmColors.class1,
          label: _criterion.name,
          labelMessage: _criterion.description,
          unit: _criterion.unit != null ? Localized(_criterion.unit!).v : null,
        ),
    };
  }
}
///
class _CriterionIndicatorView extends StatelessWidget {
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
  const _CriterionIndicatorView({
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
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final color = _color ?? theme.colorScheme.onSurface;
    final passedColor = _passedColor ?? Theme.of(context).stateColors.on;
    final errorColor = _errorColor ?? theme.alarmColors.class3;
    final padding = const Setting('padding').toDouble;
    final label = Localized(_label);
    final unit = _unit != null ? ' [${Localized(_unit)}]' : '';
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
                  '$label$unit',
                  style: textStyle?.copyWith(color: color),
                ),
              ),
            ),
            SizedBox(width: padding),
            Expanded(
              flex: 1,
              child: Text(
                _value.toStringAsFixed(3),
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
                _limit.toStringAsFixed(3),
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
