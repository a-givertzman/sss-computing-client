import 'dart:ui';
import 'package:sss_computing_client/core/models/limit_type.dart';
import 'package:sss_computing_client/core/models/metacentric_height/metacentric_height_limit.dart';
///
/// [MetacentricHeightLimit] that interpolate itself based on
/// passed displacement (in t.) and [List] of [MetacentricHeightLimit]
final class LerpMetacentricHeightLimit implements MetacentricHeightLimit {
  final int? _projectId;
  final int _shipId;
  final double _displacement;
  final List<MetacentricHeightLimit> _limits;
  ///
  /// Creates [LerpMetacentricHeightLimit] that used to interpolate
  /// [MetacentricHeightLimit] based on passed displacement (in tonnes)
  /// and [List] of [MetacentricHeightLimit].
  ///
  /// If displacement outside the range of passed limits, returns value
  /// at boundary.
  const LerpMetacentricHeightLimit({
    int? projectId,
    required int shipId,
    required double displacement,
    required List<MetacentricHeightLimit> limits,
  })  : _projectId = projectId,
        _shipId = shipId,
        _displacement = displacement,
        _limits = limits;
  //
  @override
  int get shipId => _shipId;
  //
  @override
  int? get projectId => _projectId;
  //
  @override
  double get dependentValue => _displacement;
  //
  @override
  double? get value => _extractLimitValue(
        type: LimitType.low,
        displacement: _displacement,
        limits: _limits,
      );
  ///
  double? _extractLimitValue({
    required LimitType type,
    required double displacement,
    required Iterable<MetacentricHeightLimit> limits,
  }) {
    final limitsSorted = limits.toList()
      ..sort(
        (one, other) =>
            (one.dependentValue - other.dependentValue) < 0 ? -1 : 1,
      );
    final limitsOnLeft = limitsSorted
        .where(
          (limit) => limit.dependentValue <= displacement,
        )
        .toList();
    final limitsOnRight = limitsSorted
        .where(
          (limit) => limit.dependentValue >= displacement,
        )
        .toList();
    final limitOnLeft = limitsOnLeft.isEmpty ? null : limitsOnLeft.last;
    final limitOnRight = limitsOnRight.isEmpty ? null : limitsOnRight.first;
    return switch ((limitOnLeft, limitOnRight)) {
      (MetacentricHeightLimit left, MetacentricHeightLimit right) => lerpDouble(
          left.value,
          right.value,
          (displacement - left.dependentValue) /
              (right.dependentValue - left.dependentValue),
        ),
      (MetacentricHeightLimit left, null) => left.value,
      (null, MetacentricHeightLimit right) => right.value,
      (null, null) => null,
    };
  }
}
