import 'dart:ui';
import 'package:sss_computing_client/core/models/frame/frame.dart';
enum LimitType { low, high }
///
/// Common data for corresponding [StrengthForceLimit].
abstract interface class StrengthForceLimit {
  /// id of the ship for corresponding [StrengthForceLimit]
  int get shipId;
  /// id of the project for corresponding [StrengthForceLimit]
  int? get projectId;
  /// frame for correspondig [StrengthForceLimit]
  Frame get frame;
  /// type of [StrengthForceLimit]
  LimitType get type;
  /// value of [StrengthForceLimit]
  double? get value;
}
///
/// [StrengthForceLimit] that parses itself from json map.
final class JsonStrengthForceLimit implements StrengthForceLimit {
  final Map<String, dynamic> _json;
  /// [StrengthForceLimit] that parses itself from json map.
  const JsonStrengthForceLimit({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  int get shipId => _json['shipId'];
  //
  @override
  int? get projectId => _json['projectId'];
  //
  @override
  Frame get frame => _json['frame'];
  //
  @override
  LimitType get type => _json['type'];
  //
  @override
  double? get value => _json['value'];
}
/// [StrengthForceLimit] that interpolate itself based on
/// passed [Frame] and [List] of [StrengthForceLimit]
final class LerpStrengthForceLimit implements StrengthForceLimit {
  final Frame _frame;
  final List<StrengthForceLimit> _limits;
  final LimitType _limitType;
  ///
  const LerpStrengthForceLimit({
    required Frame frame,
    required List<StrengthForceLimit> limits,
    required LimitType limitType,
  })  : _frame = frame,
        _limits = limits,
        _limitType = limitType;
  //
  @override
  int? get projectId => _frame.projectId;
  //
  @override
  int get shipId => _frame.shipId;
  //
  @override
  Frame get frame => _frame;
  //
  @override
  LimitType get type => _limitType;
  //
  @override
  double? get value => _extractLimitValue(_frame, _limits);
  ///
  double? _extractLimitValue(
    Frame frame,
    Iterable<StrengthForceLimit> limits,
  ) {
    final limitsSorted = limits.toList()
      ..sort(
        (one, other) => (one.frame.x - other.frame.x) < 0 ? -1 : 1,
      );
    final limitsOnLeft = limitsSorted
        .where(
          (limit) => limit.frame.x <= frame.x,
        )
        .toList();
    final limitsOnRight = limitsSorted
        .where(
          (limit) => limit.frame.x >= frame.x,
        )
        .toList();
    final limitOnLeft = limitsOnLeft.isEmpty ? null : limitsOnLeft.last;
    final limitOnRight = limitsOnRight.isEmpty ? null : limitsOnRight.first;
    return switch ((limitOnLeft, limitOnRight)) {
      (
        StrengthForceLimit left,
        StrengthForceLimit right,
      ) =>
        lerpDouble(
          left.value,
          right.value,
          (frame.x - left.frame.x) / (right.frame.x - left.frame.x),
        ),
      _ => null,
    };
  }
}
