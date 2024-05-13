import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
///
/// Interface for controlling collection of [StrengthForces].
abstract interface class StrengthForces {
  /// Get all [StrengthForce] in [StrengthForces] collection.
  Future<ResultF<List<StrengthForce>>> fetchAll();
}
///
/// Collection of shear force [StrengthForce] stored in Postgres DB
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
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              project_id AS "projectId",
              ship_id AS "shipId",
              index AS "frameIndex",
              value_shear_force / 1000.0 AS value
            FROM strength_result
            ORDER BY "frameIndex";
            """,
      ),
      entryBuilder: (row) => JsonStrengthForce(
        json: row
          ..['lowLimit'] = -300.0
          ..['highLimit'] = 300.0,
      ),
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final forces) => Ok(forces),
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
/// Collection of bending moment [StrengthForce] stored in Postgres DB
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
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              project_id AS "projectId",
              ship_id AS "shipId",
              index AS "frameIndex",
              value_bending_moment / 1000.0 AS value
            FROM strength_result
            ORDER BY "frameIndex";
            """,
      ),
      entryBuilder: (row) => JsonStrengthForce(
        json: row
          ..['lowLimit'] = -1000.0
          ..['highLimit'] = 1000.0,
      ),
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final forces) => Ok(forces),
      Err(:final error) => Err(
          Failure<String>(
            message: '$error',
            stackTrace: StackTrace.current,
          ),
        ),
    };
  }
}
