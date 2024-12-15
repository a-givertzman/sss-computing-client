import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/bay_pair_number.dart';
///
/// Widget to display bay pairs with certain bay pairs highlighted.
class BayPairIndication extends StatelessWidget {
  final List<({int? odd, int? even, bool isThirtyFt})> _bayPairs;
  final ItemPositionsListener _bayPairsPositionsListener;
  final ItemScrollController _bayPairsScrollController;
  final StowageCollection _stowagePlan;
  ///
  /// Widget to display [bayPairs] with certain bay pairs highlighted.
  ///
  /// [bayPairsPositionsListener] used to determine which bay pairs are visible
  /// and should be highlighted.
  /// [bayPairsScrollController] used to scroll to item associated with one of bay pairs.
  /// [stowagePlan] used to determine slots associated with each item of bay pairs.
  const BayPairIndication({
    super.key,
    required List<({int? even, int? odd, bool isThirtyFt})> bayPairs,
    required ItemPositionsListener bayPairsPositionsListener,
    required ItemScrollController bayPairsScrollController,
    required StowageCollection stowagePlan,
  })  : _bayPairs = bayPairs,
        _bayPairsPositionsListener = bayPairsPositionsListener,
        _bayPairsScrollController = bayPairsScrollController,
        _stowagePlan = stowagePlan;
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return ValueListenableBuilder<Iterable<ItemPosition>>(
      valueListenable: _bayPairsPositionsListener.itemPositions,
      builder: (context, positions, child) {
        int? min;
        int? max;
        if (positions.isNotEmpty) {
          min = positions
              .where((ItemPosition position) => position.itemTrailingEdge > 0)
              .reduce((ItemPosition min, ItemPosition position) =>
                  position.itemTrailingEdge < min.itemTrailingEdge
                      ? position
                      : min)
              .index;
          max = positions
              .where((ItemPosition position) => position.itemLeadingEdge < 1)
              .reduce((ItemPosition max, ItemPosition position) =>
                  position.itemLeadingEdge > max.itemLeadingEdge
                      ? position
                      : max)
              .index;
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _bayPairs.length,
          itemBuilder: (_, index) => GestureDetector(
            onTap: () => _bayPairsScrollController.scrollTo(
              index: index,
              duration: Duration(
                milliseconds: const Setting('animationDuration_ms').toInt,
              ),
              curve: Curves.easeInOutCubic,
              alignment: 0.5,
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: BayPairNumber(
                isThirtyFt: _bayPairs[index].isThirtyFt,
                isVisible:
                    min != null && max != null && index >= min && index <= max,
                oddBayNumber: _bayPairs[index].odd,
                evenBayNumber: _bayPairs[index].even,
                slots: _stowagePlan.toFilteredSlotList(
                  shouldIncludeSlot: (slot) =>
                      slot.bay == _bayPairs[index].odd ||
                      slot.bay == _bayPairs[index].even,
                ),
              ),
            ),
          ),
          separatorBuilder: (_, __) => SizedBox(width: blockPadding),
        );
      },
    );
  }
}
