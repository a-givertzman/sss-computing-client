import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/resize_slot_operation.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/stowage_operation.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/update_slots_status_operation.dart';
///
/// Operation that removes container from stowage slot
/// at specified position.
class RemoveContainerOperation implements StowageOperation {
  ///
  /// 2.59 m in accordance with [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  static const double _standardSlotHeight = 2.59;
  /// Bay number of slot where container should be put.
  final int _bay;
  /// Row number of slot where container should be put.
  final int _row;
  /// Tier number of slot where container should be put.
  final int _tier;
  ///
  /// Creates operation that removes container from stowage slot
  /// at specified position.
  ///
  /// The [bay], [row] and [tier] numbers specify location of slot.
  const RemoveContainerOperation({
    required int bay,
    required int row,
    required int tier,
  })  : _bay = bay,
        _row = row,
        _tier = tier;
  ///
  /// Removes container from slot at specified position in [collection],
  /// and resizes slot to standard slot height
  /// (2.59 m in accordance with [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html).
  ///
  /// Returns [Ok] if container successfully removed from [collection],
  /// and [Err] otherwise.
  @override
  ResultF<void> execute(StowageCollection collection) {
    final previousCollection = collection.copy();
    return _delContainer(collection)
        .andThen(
          (_) => _delContainer(collection),
        )
        .andThen(
          (slotToResize) {
            final shouldResizeSlot =
                (slotToResize.rightZ - slotToResize.leftZ) !=
                    _standardSlotHeight;
            return shouldResizeSlot
                ? ResizeSlotOperation(
                    height: _standardSlotHeight,
                    bay: _bay,
                    row: _row,
                    tier: _tier,
                  ).execute(collection)
                : const Ok(null);
          },
        )
        .andThen(
          (_) => UpdateSlotsStatusOperation(row: _row).execute(collection),
        )
        .inspectErr(
          (_) => _restoreFromBackup(collection, previousCollection),
        );
  }
  ///
  ResultF<Slot> _delContainer(StowageCollection collection) {
    return _findSlot(_bay, _row, _tier, collection).andThen(
      (existingSlot) {
        return existingSlot.empty();
      },
    ).map((emptySlot) {
      collection.addSlot(emptySlot);
      return emptySlot;
    });
  }
  ///
  /// Restores [collection] from [backup].
  void _restoreFromBackup(
    StowageCollection collection,
    StowageCollection backup,
  ) {
    collection.removeAllSlots();
    collection.addAllSlots(backup.toFilteredSlotList());
  }
  ///
  /// Find slot at specified position.
  ///
  /// Returns [Ok] with slot if found, and [Err] otherwise.
  ResultF<Slot> _findSlot(
    int bay,
    int row,
    int tier,
    StowageCollection stowageCollection,
  ) {
    final existingSlot = stowageCollection.findSlot(bay, row, tier);
    if (existingSlot == null) {
      return Err(Failure(
        message: 'Slot to put container not found: ($bay, $row, $tier)',
        stackTrace: StackTrace.current,
      ));
    }
    return Ok(existingSlot);
  }
}
