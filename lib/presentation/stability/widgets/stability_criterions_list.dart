import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/criterion/criterion.dart';
import 'package:sss_computing_client/core/widgets/scrollable_builder_widget.dart';
import 'package:sss_computing_client/presentation/stability/widgets/criterion_indicator.dart';
import 'package:sss_computing_client/presentation/stability/widgets/criterions_summary.dart';
///
/// Widget that displays list of criterions
/// with summary about its pass status.
class StabilityCriterionsList extends StatefulWidget {
  final List<Criterion> _criterions;
  ///
  /// Creates widget that displays list of criterions
  /// with summary about its pass status.
  ///
  /// [criterions] – list of criterions that will be displayed.
  const StabilityCriterionsList({
    super.key,
    required List<Criterion> criterions,
  }) : _criterions = criterions;
  ///
  @override
  State<StabilityCriterionsList> createState() =>
      _StabilityCriterionsListState();
}
///
class _StabilityCriterionsListState extends State<StabilityCriterionsList> {
  late final ScrollController scrollController;
  //
  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }
  //
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${const Localized('Stability criterions').v}:',
              textAlign: TextAlign.start,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            CriterionsSummary(criterions: widget._criterions),
          ],
        ),
        SizedBox(height: padding),
        Expanded(
          flex: 1,
          child: _ZebraStripedListView(
            scrollController: scrollController,
            items: widget._criterions,
            buildItem: (context, item) => CriterionIndicator(criterion: item),
          ),
        ),
      ],
    );
  }
}
///
/// ListView with alternating item's background colors
/// and with scrollbar that appears only when needed
/// and adds padding so it doesn't overlap content.
class _ZebraStripedListView<T> extends StatelessWidget {
  final List<T> _items;
  final Widget Function(BuildContext context, T item) _buildItem;
  final ScrollController _scrollController;
  final double _scrollbarThickness;
  ///
  const _ZebraStripedListView({
    required List<T> items,
    required Widget Function(BuildContext, T) buildItem,
    required ScrollController scrollController,
    double scrollbarThickness = 8.0,
  })  : _items = items,
        _buildItem = buildItem,
        _scrollController = scrollController,
        _scrollbarThickness = scrollbarThickness;
  //
  @override
  Widget build(BuildContext context) {
    final itemPadding = const Setting('padding').toDouble;
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: _scrollbarThickness,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ScrollableBuilderWidget(
          controller: _scrollController,
          builder: (context, isScrollable) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(itemPadding),
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.15),
                  ),
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.only(
                      right: isScrollable ? _scrollbarThickness : 0.0,
                    ),
                    child: Builder(
                      builder: (context) => _buildItem(context, _items[index]),
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
}
