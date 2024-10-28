import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/extensions/extension_boolean_operations.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/extensions/extension_transform.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/resize_slot_operation.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/stowage_operation.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/update_slots_status_operation.dart';
///
/// Operation that puts container to stowage slot
/// at specified position.
class AddContainerOperation implements StowageOperation {
  /// The container to be put to stowage slot.
  final FreightContainer _container;
  /// Bay number of slot where container should be put.
  final int _bay;
  /// Row number of slot where container should be put.
  final int _row;
  /// Tier number of slot where container should be put.
  final int _tier;
  ///
  /// Creates operation that puts the given [container] to stowage slot
  /// at specified position.
  ///
  /// The [bay], [row] and [tier] numbers specify location of slot.
  const AddContainerOperation({
    required FreightContainer container,
    required int bay,
    required int row,
    required int tier,
  })  : _container = container,
        _bay = bay,
        _row = row,
        _tier = tier;
  ///
  /// Puts container to slot at specified position in [stowageCollection].
  ///
  /// Returns [Ok] if container successfully added to [stowageCollection],
  /// and [Err] otherwise.
  @override
  ResultF<void> execute(StowageCollection collection) {
    final previousCollection = collection.copy();
    return _findSlot(_bay, _row, _tier, collection)
        .andThen(
          (slotToResize) {
            final shouldResizeSlot =
                (slotToResize.rightZ - slotToResize.leftZ) != _container.height;
            return shouldResizeSlot
                ? ResizeSlotOperation(
                    height: _container.height,
                    bay: _bay,
                    row: _row,
                    tier: _tier,
                  ).execute(collection)
                : const Ok(null);
          },
        )
        .andThen(
          (_) => _putContainer(collection),
        )
        .andThen(
          (_) => UpdateSlotsStatusOperation(row: _row).execute(collection),
        )
        .inspectErr(
          (_) => _restoreFromBackup(collection, previousCollection),
        );
  }
  ///
  /// Puts container to slot at specified position in [collection].
  ResultF<void> _putContainer(StowageCollection collection) {
    return _findSlot(_bay, _row, _tier, collection).andThen(
      (existingSlot) {
        return existingSlot.withContainer(_container);
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
    final existingSlot = stowageCollection.findSlot(
      bay,
      row,
      tier,
    );
    if (existingSlot == null) {
      return Err(Failure(
        message: 'Slot to put container not found: ($bay, $row, $tier)',
        stackTrace: StackTrace.current,
      ));
    }
    return Ok(existingSlot);
  }
}
