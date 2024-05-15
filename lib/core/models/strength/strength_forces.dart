import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/frame/frames.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
///
/// Interface for controlling collection of [StrengthForces].
abstract interface class StrengthForces {
  /// Get all [StrengthForce] in [StrengthForces] collection.
  Future<Result<List<StrengthForce>, Failure<String>>> fetchAll();
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
      entryBuilder: (row) => row,
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final rows) => await _mapRowsToValues(
          rows,
          _apiAddress,
          _dbName,
          _authToken,
        ),
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
      entryBuilder: (row) => row,
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final rows) => await _mapRowsToValues(
          rows,
          _apiAddress,
          _dbName,
          _authToken,
        ),
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
Future<Result<List<StrengthForce>, Failure<String>>> _mapRowsToValues(
  List<Map<String, dynamic>> rows,
  ApiAddress apiAddress,
  String dbName,
  String? authToken,
) async {
  try {
    final values = List<StrengthForce>.empty(growable: true);
    for (final row in rows) {
      final int frameIndex = row['frameIndex'];
      switch (await PgFramesTheoretical(
        dbName: dbName,
        apiAddress: apiAddress,
        authToken: authToken,
      ).fetchByIndex(frameIndex)) {
        case Ok(value: final frame):
          values.add(JsonStrengthForce(
            json: row
              ..['frame'] = frame
              ..['lowLimit'] = -500.0
              ..['highLimit'] = 500.0,
          ));
          break;
        case Err(:final error):
          return Err(Failure<String>(
            message: '$error',
            stackTrace: StackTrace.current,
          ));
      }
    }
    // final frames = await Future.wait(rows.map((row) {
    //   return PgFramesTheoretical(
    //     dbName: dbName,
    //     apiAddress: apiAddress,
    //     authToken: authToken,
    //   ).fetchByIndex(row['frameIndex']);
    // }));
    // for (int i = 0; i < rows.length; i++) {
    //   switch (frames[i]) {
    //     case Ok(value: final frame):
    //       values.add(JsonStrengthForce(
    //         json: rows[i]
    //           ..['frame'] = frame
    //           ..['lowLimit'] = -500.0
    //           ..['highLimit'] = 500.0,
    //       ));
    //       break;
    //     case Err(:final error):
    //       return Err(Failure<String>(
    //         message: '$error',
    //         stackTrace: StackTrace.current,
    //       ));
    //   }
    // }
    return Ok(values);
  } catch (error) {
    return Err(Failure<String>(
      message: '$error',
      stackTrace: StackTrace.current,
    ));
  }
}
