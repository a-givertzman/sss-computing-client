import 'package:sss_computing_client/core/models/stowage/container/container.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot.dart';
///
/// Simple representation of stowage plan,
/// in accordance with [ISO 9711-1](https://www.iso.org/ru/standard/17568.html)
abstract interface class StowagePlan {
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
  /// If any of the [bay], [row], or [tier] parameters are provided,
  /// only slots matching those criteria will be included in the returned list
  /// or passed to the [shouldIncludeSlot] callback.
  /// Otherwise, all slots will be included or passed to the [shouldIncludeSlot] callback.
  ///
  /// The optional [shouldIncludeSlot] parameter can be used to filter slots
  /// after filtering by [bay], [row], and [tier] numbers.
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
  /// Adds the given [container] to stowage slot at specified position.
  ///
  /// The [bay], [row], and [tier] parameters specify location of slot.
  ///
  /// If container is added, new slot for next tier is created
  /// and added to the plan, if possible (e.g., new slot does not exceed
  /// its maximum height).
  void addContainer(
    Container container, {
    required int bay,
    required int row,
    required int tier,
  });
  ///
  /// Removes container from stowage slot at specified position.
  ///
  /// The [bay], [row], and [tier] parameters specify location of slot.
  ///
  /// If container is removed and specified slot is the uppermost existing slot
  /// in its hold or deck, then this slot and all empty slots below it,
  /// except for the lowest one, are removed from the stowage plan.
  void removeContainer({
    required int bay,
    required int row,
    required int tier,
  });
}
