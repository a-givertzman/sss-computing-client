import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/extensions/extension_boolean_operations.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/extensions/extension_transform.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/stowage_operation.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/update_slots_status_operation.dart';
///
class DelContainerOperation implements StowageOperation {
  /// Bay number of slot where container should be put.
  final int _bay;
  /// Row number of slot where container should be put.
  final int _row;
  /// Tier number of slot where container should be put.
  final int _tier;
  ///
  const DelContainerOperation({
    required int bay,
    required int row,
    required int tier,
  })  : _bay = bay,
        _row = row,
        _tier = tier;
  ///
  @override
  ResultF<void> execute(StowageCollection collection) {
    final previousCollection = collection.copy();
    return _delContainer(collection)
        .andThen(
          (_) => _delContainer(collection),
        )
        .andThen(
          (_) => UpdateSlotsStatusOperation(row: _row).execute(collection),
        )
        .inspectErr(
          (_) => _restoreFromBackup(collection, previousCollection),
        );
  }
  ///
  ResultF<void> _delContainer(StowageCollection collection) {
    return _findSlot(_bay, _row, _tier, collection).andThen(
      (existingSlot) {
        return existingSlot.empty();
      },
    ).map((slotWithContainer) {
      collection.addSlot(slotWithContainer);
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
