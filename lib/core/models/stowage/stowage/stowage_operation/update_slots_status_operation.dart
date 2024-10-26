import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/extensions/extension_boolean_operations.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/extensions/extension_transform.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/stowage_operation.dart';
///
class UpdateSlotsStatusOperation implements StowageOperation {
  /// Minimum possible tier number for hold.
  static const int _minHoldTier = 2;
  /// Minimum possible tier number for deck.
  static const int _minDeckTier = 80;
  /// Maximum possible tier number for hold.
  static const int _maxHoldTier = 78;
  /// Maximum possible tier number for deck.
  static const int _maxDeckTier = 98;
  /// Numbering step between two sibling tiers of standard height,
  /// in accordance with [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  static const _nextTierStep = 2;
  ///
  final int _row;
  ///
  const UpdateSlotsStatusOperation({
    required int row,
  }) : _row = row;
  ///
  /// Puts container to slot at specified position in [stowageCollection].
  ///
  /// Returns [Ok] if container successfully added to [stowageCollection],
  /// and [Err] otherwise.
  @override
  ResultF<void> execute(StowageCollection collection) {
    final previousCollection = collection.copy();
    return _activateAllSlotsInRow(collection)
        .and(_deactivateDanglingSlotsInRow(collection))
        .and(_deactivateOverlappedOddSlots(collection))
        .and(_deactivateOverlappedEvenSlots(collection))
        .inspectErr((_) => _restoreFromBackup(collection, previousCollection));
  }
  ///
  ResultF<void> _activateAllSlotsInRow(
    StowageCollection collection,
  ) {
    final slotsToActivate = collection.toFilteredSlotList(
      row: _row,
    );
    collection.addAllSlots(slotsToActivate
        .map(
          (s) => s.activate(),
        )
        .toList());
    return const Ok(null);
  }
  ///
  ResultF<void> _deactivateDanglingSlotsInRow(
    StowageCollection collection,
  ) {
    _iterateBays(collection, sort: true).forEach(
      (bay) {
        _deactivateDanglingSlotsInRowBay(
          bay,
          _minDeckTier,
          _maxDeckTier,
          collection,
        );
        _deactivateDanglingSlotsInRowBay(
          bay,
          _minHoldTier,
          _maxHoldTier,
          collection,
        );
      },
    );
    return const Ok(null);
  }
  ///
  ResultF<void> _deactivateDanglingSlotsInRowBay(
    int bay,
    int minTier,
    int maxTier,
    StowageCollection collection,
  ) {
    for (final currentTier in _iterateTiers(maxTier, minTier: minTier)) {
      final currentSlot = collection.findSlot(
        bay,
        _row,
        currentTier,
      );
      if (currentSlot == null) continue;
      if (currentSlot.containerId != null) break;
      final belowSlots = collection.toFilteredSlotList(
        row: _row,
        tier: currentTier - _nextTierStep,
        shouldIncludeSlot: (s) => bay.isEven
            ? s.bay == bay - 1 || s.bay == bay + 1 || s.bay == bay
            : s.bay == bay,
      );
      if (belowSlots.isNotEmpty &&
          belowSlots.every((s) => s.containerId == null)) {
        collection.addSlot(currentSlot.deactivate());
      }
    }
    return const Ok(null);
  }
  ///
  ResultF<void> _deactivateOverlappedOddSlots(collection) {
    final slotsToCheck = collection.toFilteredSlotList(
      row: _row,
      shouldIncludeSlot: (s) => s.bay.isOdd && s.isActive,
    );
    slotsToCheck.forEach((slot) {
      final overlappedSlot = <Slot?>[
        collection.findSlot(
          slot.bay + 1,
          slot.row,
          slot.tier,
        ), // next even slot
        collection.findSlot(
          slot.bay - 1,
          slot.row,
          slot.tier,
        ), // previous even slot
      ];
      if (overlappedSlot.any((s) => s?.containerId != null)) {
        collection.addSlot(slot.deactivate());
      }
    });
    return const Ok(null);
  }
  ///
  ResultF<void> _deactivateOverlappedEvenSlots(collection) {
    final slotsToCheck = collection.toFilteredSlotList(
      row: _row,
      shouldIncludeSlot: (s) => s.bay.isEven && s.isActive,
    );
    slotsToCheck.forEach((slot) {
      final overlappedSlot = <Slot?>[
        collection.findSlot(
          slot.bay + 1,
          slot.row,
          slot.tier,
        ), // next odd slot
        collection.findSlot(
          slot.bay - 1,
          slot.row,
          slot.tier,
        ), // previous odd slot
        collection.findSlot(
          slot.bay + 2,
          slot.row,
          slot.tier,
        ), // next even slot
        collection.findSlot(
          slot.bay - 2,
          slot.row,
          slot.tier,
        ), // previous even slot
      ];
      if (overlappedSlot.any((s) => s?.containerId != null)) {
        collection.addSlot(slot.deactivate());
      }
    });
    return const Ok(null);
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
  /// Returns [Iterable] collection of unique bay numbers
  /// present in the stowage plan, sorted in descending order.
  ///
  /// TODO: update doc
  Iterable<int> _iterateBays(
    StowageCollection collection, {
    bool sort = false,
  }) {
    final uniqueBays = collection
        .toFilteredSlotList()
        .map(
          (slot) => slot.bay,
        )
        .toSet()
        .toList();
    if (sort) uniqueBays.sort((a, b) => b.compareTo(a));
    return uniqueBays;
  }
  ///
  /// Returns [Iterable] collection of tier numbers
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  Iterable<int> _iterateTiers(
    int maxTier, {
    int minTier = _minHoldTier,
  }) sync* {
    maxTier += maxTier.isOdd ? 1 : 0;
    for (int tier = maxTier; tier >= minTier; tier -= _nextTierStep) {
      yield tier;
    }
  }
}
