import 'package:collection/collection.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_collection/stowage_collection.dart';
///
/// Provides an extension methods for pretty-printing a [StowageCollection].
extension PrettyPrint on StowageCollection {
  static const String _nullSlot = '    ';
  static const String _occupiedSlot = '[▥] ';
  static const String _emptySlot = '[ ] ';
  static const String _rowNumbersPad = '   ';
  ///
  /// Prints a textual representation of the stowage plan
  /// for all bays.
  ///
  /// If [usePairs] is `true`, the method prints the stowage plan for pairs of adjacent
  /// odd and even bays. Otherwise, it prints the stowage plan for each bay individually.
  ///
  /// If [printOnlyActive] is `true`, only active slots are printed.
  void printAll({bool usePairs = true, bool printOnlyActive = true}) {
    if (usePairs) {
      for (final group in iterateBayPairs()) {
        _printBayPair(group.odd, group.even, printOnlyActive: printOnlyActive);
      }
    } else {
      for (int bay in _iterateBays()) {
        _printBayPair(bay, null, printOnlyActive: printOnlyActive);
      }
    }
  }
  ///
  /// Prints a textual representation of the stowage plan for a specific pair of bays,
  /// including bay, row and tier numbers.
  ///
  /// The [oddBay] and [evenBay] parameters specify the pair of bays for which plan should be printed.
  /// If [oddBay] or [evenBay] is null, plan for a single bay is printed instead.
  ///
  /// If [printOnlyActive] is `true`, only active slots are printed.
  // ignore: long-method
  void _printBayPair(
    int? oddBay,
    int? evenBay, {
    required bool printOnlyActive,
  }) {
    final slotsInBayPair = toFilteredSlotList(
      shouldIncludeSlot: (slot) => slot.bay == oddBay || slot.bay == evenBay,
    );
    final bayPairTitle =
        'BAY No. ${oddBay != null ? oddBay.toString().padLeft(2, '0') : ''}${evenBay != null ? '(${evenBay.toString().padLeft(2, '0')})' : ''}';
    if (slotsInBayPair.isEmpty) {
      print('No slots found for $bayPairTitle');
      return;
    }
    print(bayPairTitle);
    final maxRow = slotsInBayPair.map((slot) => slot.row).max;
    final withZeroRow = slotsInBayPair.any((slot) => slot.row == 0);
    final maxTier = slotsInBayPair.map((slot) => slot.tier).max;
    bool isDeckEmpty = true;
    bool isHoldEmpty = true;
    for (int tier in iterateTiers(maxTier)) {
      if (tier == 78 || tier == 98) {
        isDeckEmpty = true;
        isHoldEmpty = true;
      }
      final String tierNumber = tier.toString().padLeft(2, '0');
      String slotsLine = '';
      for (int row in iterateRows(maxRow, withZeroRow)) {
        final slots = slotsInBayPair.where(
          (s) => s.row == row && s.tier == tier,
        );
        Slot? slotForDisplay =
            slots.firstWhereOrNull((s) => s.containerId != null) ??
                (printOnlyActive
                    ? slots.firstWhereOrNull((s) => s.isActive)
                    : slots.firstOrNull);
        switch (slotForDisplay) {
          case null:
            slotsLine += _nullSlot;
            break;
          case Slot(isActive: false):
            slotsLine += printOnlyActive ? _nullSlot : _emptySlot;
            break;
          case Slot(containerId: final int _):
            if (tier >= 80 && tier <= 98) isDeckEmpty = false;
            if (tier >= 2 && tier <= 78) isHoldEmpty = false;
            slotsLine += _occupiedSlot;
            break;
          case Slot(containerId: null):
            slotsLine += _emptySlot;
            break;
        }
      }
      if (slotsLine.trim().isNotEmpty) {
        print('$tierNumber $slotsLine');
      } else {
        if (tier >= 80 && tier <= 98 && !isDeckEmpty) {
          print('$tierNumber $slotsLine');
        }
        if (tier >= 2 && tier <= 78 && !isHoldEmpty) {
          print('$tierNumber $slotsLine');
        }
      }
    }
    String rowNumbers = _rowNumbersPad;
    for (int row in iterateRows(maxRow, withZeroRow)) {
      rowNumbers += ' ${row.toString().padLeft(2, '0')} ';
    }
    print(rowNumbers);
  }
  ///
  /// Returns [Iterable] collection of unique bay numbers
  /// present in the stowage plan, sorted in descending order.
  Iterable<int> _iterateBays() {
    final uniqueBays = toFilteredSlotList().map((slot) => slot.bay).toSet();
    final sortedBays = uniqueBays.toList()..sort((a, b) => b.compareTo(a));
    return sortedBays;
  }
  ///
  /// Returns [Iterable] collection of row numbers
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.2](https://www.iso.org/ru/standard/17568.html)
  Iterable<int> iterateRows(int maxRow, bool withZeroRow) sync* {
    maxRow += maxRow.isOdd ? 1 : 0;
    for (int row = maxRow; row >= 2; row -= 2) {
      yield row;
    }
    yield withZeroRow ? 0 : 1;
    for (int row = withZeroRow ? 1 : 3; row <= maxRow; row += 2) {
      yield row;
    }
  }
  ///
  /// Returns [Iterable] collection of tier numbers
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  Iterable<int> iterateTiers(int maxTier) sync* {
    maxTier += maxTier.isOdd ? 1 : 0;
    for (int tier = maxTier; tier >= 2; tier -= 2) {
      yield tier;
    }
  }
  ///
  /// Returns [Iterable] collection of non-overlapping pairs of bay numbers
  /// present in the stowage plan, in descending order.
  ///
  /// Each element of the collection is a record that may contain:
  /// - an odd bay number (`odd`) and the even bay number (`even`) that immediately precedes it,
  /// - only an odd bay number (`odd`) if no preceding even bay number exists,
  /// - only an even bay number (`even`) if no following odd bay number exists.
  Iterable<({int? odd, int? even})> iterateBayPairs() sync* {
    final bays = _iterateBays().toList();
    for (int i = 0; i < bays.length; i++) {
      final current = bays[i];
      final next = bays.elementAtOrNull(i + 1);
      if (next != null && current.isOdd && current == next + 1) {
        yield (odd: current, even: next);
        i++;
      } else {
        yield (
          odd: current.isOdd ? current : null,
          even: current.isEven ? current : null,
        );
      }
    }
  }
}
