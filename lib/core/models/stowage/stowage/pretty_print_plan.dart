import 'package:collection/collection.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_plan.dart';
///
/// Provides an extension methods for pretty-printing a [StowagePlan].
extension PrettyPrint on StowagePlan {
  static const String _nullSlot = '    ';
  static const String _occupiedSlot = '[▥] ';
  static const String _emptySlot = '[ ] ';
  static const String _rowNumbersPad = '   ';
  ///
  /// Prints a textual representation of the stowage plan
  /// for all bays. If [usePairs] is `true`, the method prints the stowage plan for pairs of adjacent
  /// odd and even bays. Otherwise, it prints the stowage plan for each bay individually.
  void printAll({bool usePairs = true}) {
    if (usePairs) {
      for (final group in _iterateBayPairs()) {
        _printBayPair(group.odd, group.even);
      }
    } else {
      for (int bay in _iterateBays()) {
        _printBayPair(bay, null);
      }
    }
  }
  ///
  /// Prints a textual representation of the stowage plan for a specific pair of bays,
  /// including bay, row and tier numbers.
  ///
  /// The [oddBay] and [evenBay] parameters specify the pair of bays for which plan should be printed.
  /// If [oddBay] or [evenBay] is null, plan for a single bay is printed instead.
  void _printBayPair(int? oddBay, int? evenBay) {
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
    for (int tier in _iterateTiers(maxTier)) {
      final String tierNumber = tier.toString().padLeft(2, '0');
      String slotsLine = '';
      for (int row in _iterateRows(maxRow, withZeroRow)) {
        final slots = slotsInBayPair.where(
          (s) => s.row == row && s.tier == tier,
        );
        Slot? slotForDisplay =
            slots.firstWhereOrNull((s) => s.containerId != null) ??
                slots.firstOrNull;
        switch (slotForDisplay) {
          case null:
            slotsLine += _nullSlot;
            break;
          case Slot(containerId: final int _):
            slotsLine += _occupiedSlot;
            break;
          case Slot(containerId: null):
            slotsLine += _emptySlot;
            break;
        }
      }
      if (slotsLine.trim().isNotEmpty) print('$tierNumber $slotsLine');
    }
    String rowNumbers = _rowNumbersPad;
    for (int row in _iterateRows(maxRow, withZeroRow)) {
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
  Iterable<int> _iterateRows(int maxRow, bool withZeroRow) sync* {
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
  Iterable<int> _iterateTiers(int maxTier) sync* {
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
  Iterable<({int? odd, int? even})> _iterateBayPairs() sync* {
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
