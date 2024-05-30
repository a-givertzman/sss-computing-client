import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/limit_type.dart';
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
    return _fetchStrengthForcesLimited(
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
    return _fetchStrengthForcesLimited(
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
    _fetchStrengthForcesLimited({
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
                'lowLimit': LerpStrengthForceLimit(
                  frame: force.frame,
                  limits: limits
                      .where(
                        (limit) => limit.type == LimitType.low,
                      )
                      .toList(),
                  limitType: LimitType.low,
                ),
                'highLimit': LerpStrengthForceLimit(
                  frame: force.frame,
                  limits: limits
                      .where(
                        (limit) => limit.type == LimitType.high,
                      )
                      .toList(),
                  limitType: LimitType.high,
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
