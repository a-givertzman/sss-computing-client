import 'package:collection/collection.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection.dart';
///
/// Provides an extension methods for iterating over [StowageCollection].
extension StowageCollectionIterateExtension on StowageCollection {
  static const int _nextRowStep = 2;
  static const int _nextTierStep = 2;
  static const int _minTier = 2;
  ///
  /// Returns [Iterable] collection of unique bay numbers
  /// present in the stowage plan, sorted in descending order.
  Iterable<int> iterateBays() {
    final uniqueBays = toFilteredSlotList().map((slot) => slot.bay).toSet();
    final sortedBays = uniqueBays.toList()..sort((a, b) => b.compareTo(a));
    return sortedBays;
  }
  ///
  /// Returns [Iterable] collection of row numbers
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.2](https://www.iso.org/ru/standard/17568.html)
  ///
  /// If [withZeroRow] is true, the collection includes the row number `0`.
  /// [maxRow] determines maximum row number in the collection.
  Iterable<int> iterateRows(int maxRow, bool withZeroRow) sync* {
    maxRow += maxRow.isOdd ? 1 : 0;
    for (int row = maxRow; row >= 2; row -= _nextRowStep) {
      yield row;
    }
    yield withZeroRow ? 0 : 1;
    for (int row = withZeroRow ? 1 : 3; row <= maxRow; row += _nextRowStep) {
      yield row;
    }
  }
  ///
  /// Returns [Iterable] collection of tier numbers
  /// in accordance with stowage numbering system for rows
  /// [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  ///
  /// Iterates from [maxTier] to minimum possible tier.
  Iterable<int> iterateTiers(int maxTier) sync* {
    maxTier += maxTier.isOdd ? 1 : 0;
    for (int tier = maxTier; tier >= _minTier; tier -= _nextTierStep) {
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
    final bays = iterateBays().toList();
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
