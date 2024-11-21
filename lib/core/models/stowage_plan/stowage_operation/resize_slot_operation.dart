import 'package:collection/collection.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/stowage_operation.dart';
///
/// Operation that resizes stowage slot at specified position.
///
/// Resizing of slot leads to resizing of all upper slots.
class ResizeSlotOperation implements StowageOperation {
  /// Minimum possible tier number for hold.
  static const int _minHoldTier = 2;
  /// Minimum possible tier number for deck.
  // static const int _minDeckTier = 80;
  /// Maximum possible tier number for hold.
  static const int _maxHoldTier = 78;
  /// Maximum possible tier number for deck.
  static const int _maxDeckTier = 98;
  /// Numbering step between two sibling tiers of standard height,
  /// in accordance with [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  static const _nextTierStep = 2;
  /// New height for slot that should be resized.
  final double _height;
  /// Bay number of slot where container should be put.
  final int _bay;
  /// Row number of slot where container should be put.
  final int _row;
  /// Tier number of slot where container should be put.
  final int _tier;
  ///
  /// Creates operation that resizes stowage slot at specified position.
  ///
  /// Resizing of slot leads to resizing of all upper slots.
  ///
  /// The [bay], [row] and [tier] numbers specify location of slot.
  const ResizeSlotOperation({
    required double height,
    required int bay,
    required int row,
    required int tier,
  })  : _height = height,
        _bay = bay,
        _row = row,
        _tier = tier;
  ///
  /// Resize stowage slot at specified position.
  ///
  /// Returns [Ok] if slot successfully resized, and [Err] otherwise.
  @override
  ResultF<void> execute(StowageCollection collection) {
    final previousCollection = collection.copy();
    collection.removeAllSlots();
    return _copySameRowUnchangedSlots(collection, previousCollection)
        .andThen(
          (_) => _copyOtherRowsUnchangedSlots(collection, previousCollection),
        )
        .andThen(
          (_) => _resizeSlots(collection),
        )
        .andThen(
          (_) => _copyChangedOddBaySlots(collection, previousCollection),
        )
        .andThen(
          (_) => _copyChangedEvenBaySlots(collection, previousCollection),
        )
        .inspectErr(
          (_) => _restoreFromBackup(collection, previousCollection),
        );
  }
  ///
  /// Resize slot specified by [_bay], [_row], [_tier] and it paired slot
  /// if it exists.
  ResultF<void> _resizeSlots(StowageCollection collection) {
    final resizeSpecifiedResult = _resizeSlot(
      collection,
      bay: _bay,
      row: _row,
      tier: _tier,
    );
    final pairedSlotToResize = collection.findSlot(
      switch (_bay.isOdd) {
        true => _bay - 1,
        false => _bay + 1,
      },
      _row,
      _tier,
    );
    if (pairedSlotToResize != null) {
      final resizePairedResult = _resizeSlot(
        collection,
        bay: pairedSlotToResize.bay,
        row: pairedSlotToResize.row,
        tier: pairedSlotToResize.tier,
      );
      return resizeSpecifiedResult.and(resizePairedResult);
    } else {
      return resizeSpecifiedResult;
    }
  }
  ///
  /// Resized slot at specified position.
  ResultF<void> _resizeSlot(
    StowageCollection collection, {
    required int bay,
    required int row,
    required int tier,
  }) {
    return _findSlot(bay, row, tier, collection)
        .andThen((existingSlot) => existingSlot.resizeToHeight(_height))
        .map((resizedSlot) => collection.addSlot(resizedSlot));
  }
  ///
  ResultF<void> _copyOtherRowsUnchangedSlots(
    StowageCollection collection,
    StowageCollection previousCollection,
  ) {
    collection.addAllSlots(previousCollection.toFilteredSlotList(
      shouldIncludeSlot: (s) => s.row != _row,
    ));
    return const Ok(null);
  }
  ///
  ResultF<void> _copySameRowUnchangedSlots(
    StowageCollection collection,
    StowageCollection previousCollection,
  ) {
    final (minTierToSkip, maxTierToSkip) = _tier <= _maxHoldTier
        ? (_tier + _nextTierStep, _maxHoldTier)
        : (_tier + _nextTierStep, _maxDeckTier);
    for (var tierToCopy = _minHoldTier;
        tierToCopy <= _maxDeckTier;
        tierToCopy += _nextTierStep) {
      if (tierToCopy >= minTierToSkip && tierToCopy <= maxTierToSkip) {
        continue;
      }
      collection.addAllSlots(
        previousCollection.toFilteredSlotList(
          tier: tierToCopy,
          shouldIncludeSlot: (s) => s.row == _row,
        ),
      );
    }
    return const Ok(null);
  }
  ///
  ResultF<void> _copyChangedOddBaySlots(
    StowageCollection collection,
    StowageCollection previousCollection,
  ) {
    final (minTierToChange, maxTierToChange) = _tier <= _maxHoldTier
        ? (_tier + _nextTierStep, _maxHoldTier)
        : (_tier + _nextTierStep, _maxDeckTier);
    for (var tierToChange = minTierToChange;
        tierToChange <= maxTierToChange;
        tierToChange += _nextTierStep) {
      final oldSlotsInTier = previousCollection.toFilteredSlotList(
        tier: tierToChange,
        shouldIncludeSlot: (slot) => slot.bay.isOdd && slot.row == _row,
      );
      for (final oldSlot in oldSlotsInTier) {
        final newBottomSlot = collection.findSlot(
          oldSlot.bay,
          oldSlot.row,
          oldSlot.tier - _nextTierStep,
        );
        if (newBottomSlot == null) {
          return Err(Failure(
            message: 'Collection corrupted during operation execution',
            stackTrace: StackTrace.current,
          ));
        }
        final newLeftZ =
            newBottomSlot.rightZ + newBottomSlot.minVerticalSeparation;
        final copyResult = oldSlot
            .shiftByZ(newLeftZ - oldSlot.leftZ)
            .map((shiftedSlot) => collection.addSlot(shiftedSlot));
        if (copyResult.isErr()) return copyResult;
      }
    }
    return const Ok(null);
  }
  ///
  ResultF<void> _copyChangedEvenBaySlots(
    StowageCollection collection,
    StowageCollection previousCollection,
  ) {
    final (minTierToChange, maxTierToChange) = _tier <= _maxHoldTier
        ? (_tier + _nextTierStep, _maxHoldTier)
        : (_tier + _nextTierStep, _maxDeckTier);
    for (var tierToChange = minTierToChange;
        tierToChange <= maxTierToChange;
        tierToChange += _nextTierStep) {
      final oldSlotsInTier = previousCollection.toFilteredSlotList(
        tier: tierToChange,
        shouldIncludeSlot: (slot) => slot.bay.isEven && slot.row == _row,
      );
      for (final oldSlot in oldSlotsInTier) {
        final newLeftZ = collection
            .toFilteredSlotList(
              row: oldSlot.row,
              tier: oldSlot.tier - _nextTierStep,
              shouldIncludeSlot: (slot) =>
                  slot.bay == oldSlot.bay ||
                  slot.bay == oldSlot.bay - 1 ||
                  slot.bay == oldSlot.bay + 1,
            )
            .map((s) => s.rightZ + s.minVerticalSeparation)
            .maxOrNull;
        if (newLeftZ == null) {
          return Err(Failure(
            message: 'Collection corrupted during operation execution',
            stackTrace: StackTrace.current,
          ));
        }
        final copyResult = oldSlot
            .shiftByZ(newLeftZ - oldSlot.leftZ)
            .map((shiftedSlot) => collection.addSlot(shiftedSlot));
        if (copyResult.isErr()) return copyResult;
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
        message: 'Slot not found',
        stackTrace: StackTrace.current,
      ));
    }
    return Ok(existingSlot);
  }
}
