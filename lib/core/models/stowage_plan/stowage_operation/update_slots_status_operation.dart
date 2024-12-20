import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/stowage_operation.dart';
///
/// Operation that updates stowage slots status.
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
  /// Row to update.
  final int _row;
  ///
  /// Creates operation that updates stowage slots status in specified [row].
  const UpdateSlotsStatusOperation({
    required int row,
  }) : _row = row;
  ///
  /// Updates stowage slots status in [collection] at specified [row].
  ///
  /// Activate and deactivate slots in [collection]:
  /// - deactivate all dangling slots (no slots with containers above within same compartment).
  /// - deactivate all overlapped slots (slot that overlaps other slot with container).
  /// - deactivate all odd slots above even slots with containers.
  /// - deactivate all even slots below odd slots with containers.
  @override
  ResultF<void> execute(StowageCollection collection) {
    final previousCollection = collection.copy();
    return _activateAllSlotsInRow(collection)
        .andThen((_) => _deactivateDanglingSlotsInRow(collection))
        .andThen((_) => _deactivateOverlappedOddSlots(collection))
        .andThen((_) => _deactivateOverlappedEvenSlots(collection))
        .andThen((_) => _deactivateOverlappingWithThirtyFtBays(collection))
        .andThen((_) => _deactivateOddSlotsAboveEven(collection))
        .andThen((_) => _deactivateEvenSlotsBelowOdd(collection))
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
          bay.number,
          bay.isThirtyFt,
          _minDeckTier,
          _maxDeckTier,
          collection,
        );
        _deactivateDanglingSlotsInRowBay(
          bay.number,
          bay.isThirtyFt,
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
    bool isThirtyFt,
    int minTier,
    int maxTier,
    StowageCollection collection,
  ) {
    for (final currentTier in _iterateTiers(maxTier, minTier: minTier)) {
      final currentSlot = collection.findSlot(
        bay,
        _row,
        currentTier,
        isThirtyFt: isThirtyFt,
      );
      if (currentSlot == null) continue;
      if (currentSlot.containerId != null) break;
      final belowSlots = collection.toFilteredSlotList(
        row: _row,
        tier: currentTier - _nextTierStep,
        isThirtyFt: isThirtyFt,
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
          isThirtyFt: slot.isThirtyFt,
        ), // next even slot
        collection.findSlot(
          slot.bay - 1,
          slot.row,
          slot.tier,
          isThirtyFt: slot.isThirtyFt,
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
          isThirtyFt: slot.isThirtyFt,
        ), // next odd slot
        collection.findSlot(
          slot.bay - 1,
          slot.row,
          slot.tier,
          isThirtyFt: slot.isThirtyFt,
        ), // previous odd slot
        collection.findSlot(
          slot.bay + 2,
          slot.row,
          slot.tier,
          isThirtyFt: slot.isThirtyFt,
        ), // next even slot
        collection.findSlot(
          slot.bay - 2,
          slot.row,
          slot.tier,
          isThirtyFt: slot.isThirtyFt,
        ), // previous even slot
      ];
      if (overlappedSlot.any((s) => s?.containerId != null)) {
        collection.addSlot(slot.deactivate());
      }
    });
    return const Ok(null);
  }
  ///
  ResultF<void> _deactivateOverlappingWithThirtyFtBays(
    StowageCollection collection,
  ) {
    for (final bay in _iterateBays(collection)) {
      final isAnyContainerInstalled = collection
          .toFilteredSlotList(
            row: _row,
            bay: bay.number,
            isThirtyFt: bay.isThirtyFt,
          )
          .any((s) => s.containerId != null);
      if (!isAnyContainerInstalled) continue;
      collection
          .toFilteredSlotList(
            row: _row,
            isThirtyFt: !bay.isThirtyFt,
            shouldIncludeSlot: (s) => switch (bay.number.isOdd) {
              true => s.bay == bay.number || s.bay == bay.number - 1,
              false => s.bay == bay.number || s.bay == bay.number + 1,
            },
          )
          .forEach((s) => collection.addSlot(s.deactivate()));
    }
    return const Ok(null);
  }
  ///
  ResultF<void> _deactivateOddSlotsAboveEven(StowageCollection collection) {
    for (final bay in _iterateBays(collection)) {
      if (bay.number.isEven) {
        _deactivateOddSlotsAboveEvenInBayTiers(
          collection,
          bay.number,
          _minHoldTier,
          _maxHoldTier,
        );
        _deactivateOddSlotsAboveEvenInBayTiers(
          collection,
          bay.number,
          _minDeckTier,
          _maxDeckTier,
        );
      }
    }
    return const Ok(null);
  }
  ///
  ResultF<void> _deactivateOddSlotsAboveEvenInBayTiers(
    StowageCollection collection,
    int bay,
    int minTier,
    int maxTier,
  ) {
    for (final tier in _iterateTiers(
      maxTier,
      minTier: minTier,
      ascending: true,
    )) {
      final currentSlot = collection.findSlot(
        bay,
        _row,
        tier,
        isThirtyFt: false,
      );
      if (currentSlot?.containerId != null) {
        collection
            .toFilteredSlotList(
              row: _row,
              shouldIncludeSlot: (s) =>
                  (s.bay == bay - 1 || s.bay == bay + 1) &&
                  s.tier > tier &&
                  !s.isThirtyFt &&
                  s.isActive,
            )
            .forEach(
              (s) => collection.addSlot(s.deactivate()),
            );
        break;
      }
    }
    return const Ok(null);
  }
  ///
  ResultF<void> _deactivateEvenSlotsBelowOdd(StowageCollection collection) {
    for (final bay in _iterateBays(collection)) {
      if (bay.number.isOdd) {
        _deactivateEvenSlotsBelowOddInBayTiers(
          collection,
          bay.number,
          _minHoldTier,
          _maxHoldTier,
        );
        _deactivateEvenSlotsBelowOddInBayTiers(
          collection,
          bay.number,
          _minDeckTier,
          _maxDeckTier,
        );
      }
    }
    return const Ok(null);
  }
  ///
  ResultF<void> _deactivateEvenSlotsBelowOddInBayTiers(
    StowageCollection collection,
    int bay,
    int minTier,
    int maxTier,
  ) {
    for (final tier in _iterateTiers(
      maxTier,
      minTier: minTier,
      ascending: false,
    )) {
      final currentSlot = collection.findSlot(
        bay,
        _row,
        tier,
        isThirtyFt: false,
      );
      if (currentSlot?.containerId != null) {
        collection
            .toFilteredSlotList(
              row: _row,
              shouldIncludeSlot: (s) =>
                  (s.bay == bay - 1 || s.bay == bay + 1) &&
                  s.tier < tier &&
                  !s.isThirtyFt &&
                  s.isActive,
            )
            .forEach(
              (s) => collection.addSlot(s.deactivate()),
            );
        break;
      }
    }
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
  /// present in the stowage plan.
  ///
  /// If [sort] is true, the collection is sorted in descending order.
  Iterable<({int number, bool isThirtyFt})> _iterateBays(
    StowageCollection collection, {
    bool sort = false,
  }) {
    final uniqueBays = collection
        .toFilteredSlotList()
        .map(
          (slot) => (number: slot.bay, isThirtyFt: slot.isThirtyFt),
        )
        .toSet()
        .toList();
    if (sort) uniqueBays.sort((a, b) => b.number.compareTo(a.number));
    return uniqueBays;
  }
  ///
  /// Returns [Iterable] collection of tier numbers
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  ///
  /// Iterates from [minTier] to [maxTier] if [ascending] is true
  /// and from [maxTier] to [minTier] if [ascending] otherwise.
  Iterable<int> _iterateTiers(
    int maxTier, {
    int minTier = _minHoldTier,
    bool ascending = false,
  }) sync* {
    maxTier += maxTier.isOdd ? 1 : 0;
    final startingTier = ascending ? minTier : maxTier;
    final endingTier = ascending ? maxTier : minTier;
    final nextTierStep = ascending ? _nextTierStep : -_nextTierStep;
    for (int tier = startingTier; tier >= endingTier; tier += nextTierStep) {
      yield tier;
    }
  }
}
