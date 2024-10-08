import 'package:sss_computing_client/core/models/stowage/container/container.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot.dart';
///
/// A stowage slot with standard height
/// that is always separated from slot of next tier
/// by at least specified distance.
class StandardSlot implements Slot {
  ///
  /// 2.59 m in accordance with [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  static const double _standardHeight = 2.59;
  //
  @override
  final int bay;
  //
  @override
  final int row;
  //
  @override
  final int tier;
  //
  @override
  final double leftX;
  //
  @override
  final double rightX;
  //
  @override
  final double leftY;
  //
  @override
  final double rightY;
  //
  @override
  final double leftZ;
  //
  @override
  final double rightZ;
  //
  @override
  final double maxHeight;
  //
  @override
  final double minHeight;
  //
  @override
  final double minVerticalSeparation;
  //
  @override
  final int? containerId;
  ///
  /// Creates a stowage slot with the given fields.
  /// If a slot of next tier is created,
  /// rules for its separation along the vertical axis
  /// will be identical.
  const StandardSlot({
    required this.bay,
    required this.row,
    required this.tier,
    required this.leftX,
    required this.rightX,
    required this.leftY,
    required this.rightY,
    required this.leftZ,
    required this.rightZ,
    required this.maxHeight,
    required this.minHeight,
    required this.minVerticalSeparation,
    this.containerId,
  });
  //
  @override
  Slot? createUpperSlot({double? verticalSeparation}) {
    final tierUpper = tier + 2;
    final tierSeparation = verticalSeparation ?? minVerticalSeparation;
    final leftZUpper = rightZ + tierSeparation;
    final rightZUpper = leftZUpper + _standardHeight;
    if (tierSeparation < minVerticalSeparation) return null;
    if (rightZUpper > maxHeight) return null;
    return copyWith(
      containerId: null,
      tier: tierUpper,
      leftZ: leftZUpper,
      rightZ: rightZUpper,
      minVerticalSeparation: minVerticalSeparation,
    );
  }
  //
  @override
  Slot? withContainer(Container container) {
    if (containerId != null) return null;
    final rightZAdjusted = leftZ + container.height / 1000;
    if (rightZAdjusted > maxHeight) return null;
    return copyWith(
      containerId: container.id,
      rightZ: rightZAdjusted,
    );
  }
  //
  @override
  Slot? empty() {
    if (containerId == null) return null;
    return copyWith(
      containerId: null,
    );
  }
  //
  @override
  // ignore: long-parameter-list
  Slot copyWith({
    int? bay,
    int? row,
    int? tier,
    double? leftX,
    double? rightX,
    double? leftY,
    double? rightY,
    double? leftZ,
    double? rightZ,
    double? maxHeight,
    double? minHeight,
    double? minVerticalSeparation,
    required int? containerId,
  }) =>
      StandardSlot(
        bay: bay ?? this.bay,
        row: row ?? this.row,
        tier: tier ?? this.tier,
        leftX: leftX ?? this.leftX,
        rightX: rightX ?? this.rightX,
        leftY: leftY ?? this.leftY,
        rightY: rightY ?? this.rightY,
        leftZ: leftZ ?? this.leftZ,
        rightZ: rightZ ?? this.rightZ,
        maxHeight: maxHeight ?? this.maxHeight,
        minHeight: minHeight ?? this.minHeight,
        minVerticalSeparation:
            minVerticalSeparation ?? this.minVerticalSeparation,
        containerId: containerId,
      );
  //
  @override
  String toString() => 'Installed container: $containerId';
}
