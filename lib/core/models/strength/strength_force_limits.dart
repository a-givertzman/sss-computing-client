import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/frame/frame.dart';
import 'package:sss_computing_client/core/models/limit_type.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limit.dart';
///
/// Interface for controlling collection of [StrengthForceLimits].
abstract interface class StrengthForceLimits {
  /// Get all [StrengthForceLimit] in [StrengthForceLimits] collection.
  Future<Result<List<StrengthForceLimit>, Failure<String>>> fetchAll();
}
///
/// Collection of shear force [StrengthForceLimit] stored in Postgres DB
class PgShearForceLimits implements StrengthForceLimits {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const PgShearForceLimits({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Future<Result<List<StrengthForceLimit>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => _buildPgFetchAllSql('shear_force'),
      entryBuilder: (row) => _mapDbReplyToValue(row),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<StrengthForceLimit>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final forces) => Ok(forces),
            Err(:final error) => Err(
                Failure(
                  message: '$error',
                  stackTrace: StackTrace.current,
                ),
              ),
          },
        )
        .onError(
          (error, stackTrace) => Err(Failure(
            message: '$error',
            stackTrace: stackTrace,
          )),
        );
  }
}
///
/// Collection of bending moment [StrengthForceLimit] stored in Postgres DB
class PgBendingMomentLimits implements StrengthForceLimits {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const PgBendingMomentLimits({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Future<Result<List<StrengthForceLimit>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => _buildPgFetchAllSql('bending_moment'),
      entryBuilder: (row) => _mapDbReplyToValue(row),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<StrengthForceLimit>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final forces) => Ok(forces),
            Err(:final error) => Err(
                Failure(
                  message: '$error',
                  stackTrace: StackTrace.current,
                ),
              ),
          },
        )
        .onError(
          (error, stackTrace) => Err(Failure(
            message: '$error',
            stackTrace: stackTrace,
          )),
        );
  }
}
///
Sql _buildPgFetchAllSql(String forceType) {
  return Sql(
    sql: """
          SELECT
            sfl.project_id AS "projectId",
            sfl.ship_id AS "shipId",
            sfl.frame_real_index AS "frameIndex",
            pf.x AS "frameX",
            sfl.limit_type::TEXT AS "limitType",
            sfl.value / 1000.0 AS value
          FROM strength_force_limit AS sfl
          INNER JOIN
          (
            SELECT DISTINCT ON (index) * FROM (
              SELECT
                ship_id AS "shipId",
                value AS "x",
                index
              FROM physical_frame
              WHERE key = 'x'
              UNION
              SELECT
                pfx.ship_id AS "shipId",
                pfx.index + 1 AS "index",
                pfx.value + pfd.value AS "x"
              FROM physical_frame AS pfx
              INNER JOIN physical_frame AS pfd
              ON pfx.key = 'x' AND pfd.key = 'delta_x' AND pfx.index = pfd.index
              ORDER BY "index"
            )
          ) AS pf
          ON sfl.frame_real_index = pf.index AND sfl.force_type = '$forceType';
        """,
  );
}
///
StrengthForceLimit _mapDbReplyToValue(Map<String, dynamic> row) {
  return JsonStrengthForceLimit(json: {
    'projectId': row['projectId'],
    'shipId': row['shipId'],
    'value': row['value'],
    'type': switch (row['limitType']) {
      'low' => LimitType.low,
      'high' => LimitType.high,
      _ => throw Failure<String>(
          message: 'Incorrect value for LimitType of StrenghForceLimit',
          stackTrace: StackTrace.current,
        ),
    },
    'frame': JsonFrame(json: {
      'projectId': row['projectId'],
      'shipId': row['shipId'],
      'index': row['frameIndex'],
      'x': row['frameX'],
    }),
  });
}
