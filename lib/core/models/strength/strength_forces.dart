import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/frame/frame.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
///
/// Interface for controlling collection of [StrengthForces].
abstract interface class StrengthForces {
  /// Get all [StrengthForceLimit] in [StrengthForces] collection.
  Future<Result<List<StrengthForce>, Failure<String>>> fetchAll();
}
///
/// Collection of shear force [StrengthForceLimit] stored in Postgres DB
class PgShearForces implements StrengthForces {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const PgShearForces({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Future<Result<List<StrengthForce>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => _buildPgFetchAllSql('value_shear_force'),
      entryBuilder: (row) => _mapDbReplyToValue(row),
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final rows) => Ok(rows),
      Err(:final error) => Err(
          Failure<String>(
            message: '$error',
            stackTrace: StackTrace.current,
          ),
        ),
    };
  }
}
///
/// Collection of bending moment [StrengthForceLimit] stored in Postgres DB
class PgBendingMoments implements StrengthForces {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const PgBendingMoments({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Future<Result<List<StrengthForce>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => _buildPgFetchAllSql('value_bending_moment'),
      entryBuilder: (row) => _mapDbReplyToValue(row),
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final rows) => Ok(rows),
      Err(:final error) => Err(
          Failure<String>(
            message: '$error',
            stackTrace: StackTrace.current,
          ),
        ),
    };
  }
}
///
Sql _buildPgFetchAllSql(String valueType) {
  return Sql(
    sql: """
          SELECT DISTINCT
            sr.project_id AS "projectId",
            sr.ship_id AS "shipId",
            sr.index AS "frameIndex",
            cf.value AS "frameX",
            sr.$valueType / 1000.0 AS value
          FROM strength_result AS sr
          INNER JOIN computed_frame AS cf
          ON
            (sr.index = cf.index AND sr.ship_id = cf.ship_id AND cf.key = 'start_x')
          OR
            (sr.index = cf.index + 1 AND sr.ship_id = cf.ship_id AND cf.key = 'end_x')
          ORDER BY "frameIndex";
        """,
  );
}
///
StrengthForce _mapDbReplyToValue(Map<String, dynamic> row) {
  return JsonStrengthForce(
    json: row
      ..['frame'] = JsonFrame(json: {
        'projectId': row['projectId'],
        'shipId': row['shipId'],
        'index': row['frameIndex'],
        'x': row['frameX'],
      }),
  );
}
