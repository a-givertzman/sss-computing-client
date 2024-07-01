import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/criterion/criterion.dart';
import 'package:sss_computing_client/core/models/number_math_relation/number_math_relation.dart';
import 'package:sss_computing_client/core/widgets/scrollable_builder_widget.dart';
import 'package:sss_computing_client/presentation/stability/widgets/criterion_widget.dart';
///
class CriterionList extends StatefulWidget {
  final List<Criterion> _criterions;
  ///
  const CriterionList({
    super.key,
    required List<Criterion> criterions,
  }) : _criterions = criterions;
  ///
  @override
  State<CriterionList> createState() => _CriterionListState(
        criterions: _criterions,
      );
}
///
class _CriterionListState extends State<CriterionList> {
  final List<Criterion> _criterions;
  late final ScrollController scrollController;
  ///
  _CriterionListState({
    required List<Criterion> criterions,
  }) : _criterions = criterions;
  ///
  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }
  ///
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  ///
  @override
  Widget build(BuildContext context) {
    const scrollbarThickness = 8.0;
    final padding = const Setting('padding').toDouble;
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      thickness: scrollbarThickness,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ScrollableBuilderWiddget(
          controller: scrollController,
          builder: (context, isScrollable) {
            return ListView.builder(
              controller: scrollController,
              itemCount: _criterions.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.15),
                  ),
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.only(
                      left: padding,
                      top: padding,
                      right:
                          padding + (isScrollable ? scrollbarThickness : 0.0),
                      bottom: padding,
                    ),
                    child: Builder(
                      builder: (_) => _buildCriterionWidget(_criterions[index]),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  ///
  Widget _buildCriterionWidget(Criterion criterion) {
    final theme = Theme.of(context);
    final relation = NumberMathRelation.fromString(criterion.relation);
    final relationResult = relation.process(
      criterion.value,
      criterion.limit,
    );
    return switch (relationResult) {
      Ok(value: final isPassed) => CriterionWidget(
          value: criterion.value,
          limit: criterion.limit,
          relation: relation.operator,
          passed: isPassed,
          errorMessage: isPassed
              ? null
              : const Localized(
                  'Actual and limit values did not pass relation test',
                ).v,
          label: criterion.name,
          labelMessage: criterion.description,
          unit: criterion.unit != null ? Localized(criterion.unit!).v : null,
        ),
      Err(:final error) => CriterionWidget(
          value: criterion.value,
          limit: criterion.limit,
          relation: relation.operator,
          passed: false,
          errorMessage: error.message,
          errorColor: theme.alarmColors.class1,
          label: criterion.name,
          labelMessage: criterion.description,
          unit: criterion.unit != null ? Localized(criterion.unit!).v : null,
        ),
    };
  }
}
