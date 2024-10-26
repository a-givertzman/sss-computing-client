import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/slot/slot.dart';
///
/// A stowage slot with standard height
/// that is always separated from slot of next tier
/// by at least specified distance.
class StandardSlot implements Slot {
  ///
  /// 2.59 m in accordance with [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  static const double _standardHeight = 2.59;
  // static const double _standardHeight = 2.438;
  ///
  /// Maximum possible tier number,
  /// in accordance with [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  static const int _maxTier = 98;
  ///
  /// Numbering step between two sibling tiers of standard height,
  /// in accordance with [ISO 9711-1, 3.3](https://www.iso.org/ru/standard/17568.html)
  static const _nextTierStep = 2;
  //
  @override
  final bool isActive;
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
    this.isActive = true,
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
  Slot activate() {
    return StandardSlot(
      isActive: true,
      bay: bay,
      row: row,
      tier: tier,
      leftX: leftX,
      rightX: rightX,
      leftY: leftY,
      rightY: rightY,
      leftZ: leftZ,
      rightZ: rightZ,
      maxHeight: maxHeight,
      minHeight: minHeight,
      minVerticalSeparation: minVerticalSeparation,
      containerId: containerId,
    );
  }
  //
  @override
  Slot deactivate() {
    return StandardSlot(
      isActive: false,
      bay: bay,
      row: row,
      tier: tier,
      leftX: leftX,
      rightX: rightX,
      leftY: leftY,
      rightY: rightY,
      leftZ: leftZ,
      rightZ: rightZ,
      maxHeight: maxHeight,
      minHeight: minHeight,
      minVerticalSeparation: minVerticalSeparation,
      containerId: null,
    );
  }
  //
  @override
  ResultF<Slot?> createUpperSlot({double? verticalSeparation}) {
    final tierUpper = tier + _nextTierStep;
    final tierSeparation = verticalSeparation ?? minVerticalSeparation;
    final leftZUpper = rightZ + tierSeparation;
    final rightZUpper = leftZUpper + _standardHeight;
    if (tierUpper > _maxTier) {
      return Err(Failure(
        message: 'Tier must not exceed $_maxTier.',
        stackTrace: StackTrace.current,
      ));
    }
    if (tierSeparation < minVerticalSeparation) {
      return Err(Failure(
        message: 'Tier separation must be at least $minVerticalSeparation m.',
        stackTrace: StackTrace.current,
      ));
    }
    if (rightZUpper > maxHeight) return Ok(null);
    return Ok(StandardSlot(
      isActive: isActive,
      bay: bay,
      row: row,
      tier: tierUpper,
      leftX: leftX,
      rightX: rightX,
      leftY: leftY,
      rightY: rightY,
      leftZ: leftZUpper,
      rightZ: rightZUpper,
      maxHeight: maxHeight,
      minHeight: minHeight,
      minVerticalSeparation: minVerticalSeparation,
      containerId: null,
    ));
  }
  //
  @override
  ResultF<Slot> withContainer(FreightContainer container) {
    final rightZAdjusted = leftZ + container.height;
    if (rightZAdjusted > maxHeight) {
      return Err(Failure(
        message: 'Slot with container must not exceed $maxHeight m.',
        stackTrace: StackTrace.current,
      ));
    }
    return Ok(StandardSlot(
      isActive: isActive,
      bay: bay,
      row: row,
      tier: tier,
      leftX: leftX,
      rightX: rightX,
      leftY: leftY,
      rightY: rightY,
      leftZ: leftZ,
      rightZ: rightZAdjusted,
      maxHeight: maxHeight,
      minHeight: minHeight,
      minVerticalSeparation: minVerticalSeparation,
      containerId: container.id,
    ));
  }
  //
  @override
  ResultF<Slot> empty() {
    return Ok(StandardSlot(
      isActive: isActive,
      bay: bay,
      row: row,
      tier: tier,
      leftX: leftX,
      rightX: rightX,
      leftY: leftY,
      rightY: rightY,
      leftZ: leftZ,
      rightZ: rightZ,
      maxHeight: maxHeight,
      minHeight: minHeight,
      minVerticalSeparation: minVerticalSeparation,
      containerId: null,
    ));
  }
  //
  @override
  Slot copy() => StandardSlot(
        isActive: isActive,
        bay: bay,
        row: row,
        tier: tier,
        leftX: leftX,
        rightX: rightX,
        leftY: leftY,
        rightY: rightY,
        leftZ: leftZ,
        rightZ: rightZ,
        maxHeight: maxHeight,
        minHeight: minHeight,
        minVerticalSeparation: minVerticalSeparation,
        containerId: containerId,
      );
  //
  @override
  resizeToHeight(double height) {
    final rightZAdjusted = leftZ + height;
    if (containerId != null && (rightZ - leftZ) != height) {
      return Err(Failure(
        message: 'Cannot resize occupied slot to new height.',
        stackTrace: StackTrace.current,
      ));
    }
    if (rightZAdjusted > maxHeight) {
      return Err(Failure(
        message: 'Slot exceeds $maxHeight m.',
        stackTrace: StackTrace.current,
      ));
    }
    if (rightZAdjusted < leftZ) {
      return Err(Failure(
        message: 'Slot leftZ exceeds rightZ.',
        stackTrace: StackTrace.current,
      ));
    }
    return Ok(StandardSlot(
      isActive: isActive,
      bay: bay,
      row: row,
      tier: tier,
      leftX: leftX,
      rightX: rightX,
      leftY: leftY,
      rightY: rightY,
      leftZ: leftZ,
      rightZ: rightZAdjusted,
      maxHeight: maxHeight,
      minHeight: minHeight,
      minVerticalSeparation: minVerticalSeparation,
      containerId: containerId,
    ));
  }
  //
  @override
  ResultF<Slot> shiftByZ(double value) {
    final leftZAdjusted = leftZ + value;
    final rightZAdjusted = rightZ + value;
    if (rightZAdjusted > maxHeight) {
      return Err(Failure(
        message: 'Slot exceeds $maxHeight m.',
        stackTrace: StackTrace.current,
      ));
    }
    return Ok(StandardSlot(
      isActive: isActive,
      bay: bay,
      row: row,
      tier: tier,
      leftX: leftX,
      rightX: rightX,
      leftY: leftY,
      rightY: rightY,
      leftZ: leftZAdjusted,
      rightZ: rightZAdjusted,
      maxHeight: maxHeight,
      minHeight: minHeight,
      minVerticalSeparation: minVerticalSeparation,
      containerId: containerId,
    ));
  }
  //
  @override
  String toString() => '''
Key: ${'$bay'.padLeft(2, '0')}${'$row'.padLeft(2, '0')}${'$tier'.padLeft(2, '0')}
Installed container: $containerId
Is active: $isActive
''';
}
