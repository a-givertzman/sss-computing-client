import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/resize_slot_operation.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/stowage_operation.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/update_slots_status_operation.dart';
///
/// Operation that puts container to stowage slot
/// at specified position.
class PutContainerOperation implements StowageOperation {
  /// The container to be put to stowage slot.
  final FreightContainer _container;
  /// Bay number of slot where container should be put.
  final int _bay;
  /// Row number of slot where container should be put.
  final int _row;
  /// Tier number of slot where container should be put.
  final int _tier;
  /// Either slot to put is 30 ft or not.
  final bool _isThirtyFt;
  ///
  /// Creates operation that puts the given [container] to stowage slot
  /// at specified position.
  ///
  /// The [bay], [row] and [tier] numbers specify location of slot.
  const PutContainerOperation({
    required FreightContainer container,
    required int bay,
    required int row,
    required int tier,
    bool isThirtyFt = false,
  })  : _container = container,
        _bay = bay,
        _row = row,
        _tier = tier,
        _isThirtyFt = isThirtyFt;
  ///
  /// Puts container to slot at specified position in [collection].
  ///
  /// Returns [Ok] if container successfully added to [collection],
  /// and [Err] otherwise.
  @override
  ResultF<void> execute(StowageCollection collection) {
    final previousCollection = collection.copy();
    return _findSlot(_bay, _row, _tier, _isThirtyFt, collection)
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
                    isThirtyFt: _isThirtyFt,
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
    return _findSlot(_bay, _row, _tier, _isThirtyFt, collection).andThen(
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
    bool isThirtyFt,
    StowageCollection stowageCollection,
  ) {
    final existingSlot = stowageCollection.findSlot(
      bay,
      row,
      tier,
      isThirtyFt: isThirtyFt,
    );
    if (existingSlot == null) {
      return Err(Failure(
        message: 'Slot to put container not found',
        stackTrace: StackTrace.current,
      ));
    }
    return Ok(existingSlot);
  }
}
