import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
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
  final shipId = const Setting('shipId').toInt;
  final projectId = int.tryParse(const Setting('projectId').toString());
  return Sql(
    sql: """
          SELECT
            sfl.project_id AS "projectId",
            sfl.ship_id AS "shipId",
            sfl.frame_x AS "frameX",
            sfl.limit_type::TEXT AS "limitType",
            sfl.value / 1000.0 AS value
          FROM
            strength_force_limit AS sfl
            JOIN ship AS s ON
              sfl.ship_id = s.id
            JOIN ship_water_area AS swa ON
              s.water_area_id = swa.id
          WHERE
            sfl.force_type = '$forceType' AND
            sfl.limit_area::TEXT = swa.name AND
            sfl.ship_id = $shipId AND
            sfl.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
          ;
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
          message: 'Incorrect value for LimitType of StrengthForceLimit',
          stackTrace: StackTrace.current,
        ),
    },
    'frame': JsonFrame(json: {
      'projectId': row['projectId'],
      'shipId': row['shipId'],
      'index': 0,
      'x': row['frameX'],
    }),
  });
}
