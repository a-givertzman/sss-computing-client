import 'package:collection/collection.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection_iterate_extension.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_map.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/stowage_plan_numbering_item.dart';
import 'package:vector_math/vector_math_64.dart';
///
/// Calculate numbering axes data for stowage plan.
class StowagePlanNumberingAxes {
  ///
  /// Creates object to calculate numbering axes data for stowage plan.
  const StowagePlanNumberingAxes();
  ///
  /// Returns list of [StowagePlanNumberingItem] for tier numbering axis
  /// using provided [slots].
  List<StowagePlanNumberingItem> tierNumberingAxis(List<Slot> slots) {
    final stowageCollection = StowageMap.fromSlotList(slots);
    final tiers = slots.map((slot) => slot.tier);
    final maxTier = tiers.max;
    final tierNumberingData = stowageCollection
        .iterateTiers(maxTier)
        .map((tier) {
          final slotInTier = stowageCollection
              .toFilteredSlotList(
                tier: tier,
              )
              .firstOrNull;
          if (slotInTier == null) return null;
          return StowagePlanNumberingItem(
            number: tier,
            start: Vector3(
              slotInTier.leftX,
              slotInTier.leftY,
              slotInTier.leftZ,
            ),
            end: Vector3(
              slotInTier.rightX,
              slotInTier.rightY,
              slotInTier.rightZ,
            ),
          );
        })
        .whereType<StowagePlanNumberingItem>()
        .toList();
    return tierNumberingData;
  }
  ///
  /// Returns list of [StowagePlanNumberingItem] for row numbering axis
  /// using provided [slots].
  List<StowagePlanNumberingItem> rowNumberingAxis(List<Slot> slots) {
    final stowageCollection = StowageMap.fromSlotList(slots);
    final rows = slots.map((slot) => slot.row);
    final maxRow = rows.max;
    final withZeroRow = rows.any((row) => row == 0);
    final rowNumberingData = stowageCollection
        .iterateRows(maxRow, withZeroRow)
        .map((row) {
          final slotInRow = stowageCollection
              .toFilteredSlotList(
                row: row,
              )
              .firstOrNull;
          if (slotInRow == null) return null;
          return StowagePlanNumberingItem(
            number: row,
            start: Vector3(
              slotInRow.leftX,
              slotInRow.leftY,
              slotInRow.leftZ,
            ),
            end: Vector3(
              slotInRow.rightX,
              slotInRow.rightY,
              slotInRow.rightZ,
            ),
          );
        })
        .whereType<StowagePlanNumberingItem>()
        .toList();
    return rowNumberingData;
  }
}
