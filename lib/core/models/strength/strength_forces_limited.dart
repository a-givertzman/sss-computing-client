import 'dart:ui';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/frame/frame.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limit.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limited.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limits.dart';
import 'package:sss_computing_client/core/models/strength/strength_forces.dart';
///
/// Interface for controlling collection of [StrengthForcesLimited].
abstract interface class StrengthForcesLimited {
  /// Get all [StrengthForceLimited] in [StrengthForcesLimited] collection.
  Future<Result<List<StrengthForceLimited>, Failure<String>>> fetchAll();
}
///
/// Collection of shear force [StrengthForceLimited] stored in Postgres DB
class PgShearForcesLimited implements StrengthForcesLimited {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const PgShearForcesLimited({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Future<Result<List<StrengthForceLimited>, Failure<String>>> fetchAll() async {
    return _fetchStrengthForceLimited(
      fetchForces: PgShearForces(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
      ).fetchAll(),
      fetchLimits: PgShearForceLimits(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
      ).fetchAll(),
    );
  }
}
///
/// Collection of bending moment [StrengthForceLimited] stored in Postgres DB
class PgBendingMomentsLimited implements StrengthForcesLimited {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const PgBendingMomentsLimited({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Future<Result<List<StrengthForceLimited>, Failure<String>>> fetchAll() async {
    return _fetchStrengthForceLimited(
      fetchForces: PgBendingMoments(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
      ).fetchAll(),
      fetchLimits: PgBendingMomentLimits(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
      ).fetchAll(),
    );
  }
}
///
Future<Result<List<StrengthForceLimited>, Failure<String>>>
    _fetchStrengthForceLimited({
  required Future<ResultF<List<StrengthForce>>> fetchForces,
  required Future<ResultF<List<StrengthForceLimit>>> fetchLimits,
}) async {
  late final List<StrengthForce> forces;
  late final List<StrengthForceLimit> limits;
  switch (await fetchForces) {
    case Err(:final error):
      return Err(Failure(
        message: '$error',
        stackTrace: StackTrace.current,
      ));
    case Ok(value: final values):
      forces = values;
  }
  switch (await fetchLimits) {
    case Err(:final error):
      return Err(Failure(
        message: '$error',
        stackTrace: StackTrace.current,
      ));
    case Ok(value: final values):
      limits = values;
  }
  return _extractForcesWithLimit(forces: forces, limits: limits);
}
///
Result<List<StrengthForceLimited>, Failure<String>> _extractForcesWithLimit({
  required List<StrengthForce> forces,
  required List<StrengthForceLimit> limits,
}) {
  try {
    return Ok(
      forces
          .map((force) => JsonStrengthForceLimited(json: {
                'force': force,
                'lowLimit': _extractLimitForFrame(
                  force.frame,
                  limits.where(
                    (limit) => limit.type == LimitType.low,
                  ),
                ),
                'highLimit': _extractLimitForFrame(
                  force.frame,
                  limits.where(
                    (limit) => limit.type == LimitType.high,
                  ),
                ),
              }))
          .toList(),
    );
  } catch (error) {
    return Err(Failure(
      message: '$error',
      stackTrace: StackTrace.current,
    ));
  }
}
///
StrengthForceLimit _extractLimitForFrame(
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
  final limitOnFrame = switch ((limitOnLeft, limitOnRight)) {
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
  return JsonStrengthForceLimit(json: {
    'projectId': frame.projectId,
    'shipId': frame.shipId,
    'frame': frame,
    'type': limits.first.type,
    'value': limitOnFrame,
  });
}
