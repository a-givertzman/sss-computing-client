import 'package:sss_computing_client/core/models/stowage/stowage/slot/slot.dart';
///
/// Structure to store simple representation of stowage plan,
/// in accordance with [ISO 9711-1](https://www.iso.org/ru/standard/17568.html)
abstract interface class StowageCollection {
  ///
  /// Returns stowage slot
  /// at position specified by [bay], [row] and [tier] numbers.
  ///
  /// Returns `null` if stowage slot at specified position does not exist.
  Slot? findSlot(
    int bay,
    int row,
    int tier,
  );
  ///
  /// Returns a list of stowage slots filtered by the specified criteria.
  ///
  /// If any of the [bay], [row] or [tier] numbers are provided,
  /// only slots matching those criteria will be included in the returned list
  /// or passed to the [shouldIncludeSlot] callback.
  /// Otherwise, all slots will be included or passed to the [shouldIncludeSlot] callback.
  ///
  /// The optional [shouldIncludeSlot] parameter can be used to filter slots
  /// after filtering by [bay], [row] and [tier] numbers.
  /// If [shouldIncludeSlot] callback is provided it must return `true` for slots
  /// that should be included in the returned list
  /// and `false` for slots that should be excluded.
  List<Slot> toFilteredSlotList({
    int? bay,
    int? row,
    int? tier,
    bool Function(Slot slot)? shouldIncludeSlot,
  });
  ///
  /// Adds a slot with the same properties as the given [slot]
  /// to stowage collection at its position specified
  /// by [bay], [row] and [tier] numbers.
  ///
  /// If slot is already in the collection (slot with the same
  /// [bay], [row] and [tier] numbers),
  /// its value will be overwritten.
  void addSlot(Slot slot);
  ///
  /// Adds new slots with the same properties as the given [slots]
  /// to stowage collection at positions specified by
  /// [bay], [row] and [tier] numbers of each slot.
  ///
  /// If any of given slots is already in the collection
  /// (slot with the same [bay], [row] and [tier] numbers),
  /// its value will be overwritten.
  void addAllSlots(List<Slot> slots);
  ///
  /// Removes slot from stowage collection, if presents,
  /// at position specified by [bay], [row] and [tier] numbers.
  void removeSlot(int bay, int row, int tier);
  ///
  /// Removes all slots from stowage collection.
  void removeAllSlots();
  ///
  /// Returns a copy of the stowage collection.
  StowageCollection copy();
}
