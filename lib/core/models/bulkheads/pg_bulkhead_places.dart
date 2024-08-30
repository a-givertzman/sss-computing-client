import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead_place.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead_places.dart';
import 'package:sss_computing_client/core/models/bulkheads/json_bulkhead_place.dart';
///
/// [BulkheadPlaces] collection that stored in postgres DB.
class PgBulkheadPlaces implements BulkheadPlaces {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// [BulkheadPlaces] collection that stored in postgres DB.
  ///
  ///   - `apiAddress` - [ApiAddress] of server that interact with database;
  ///   - `dbName` - name of the database;
  ///   - `authToken` - string  authentication token for accessing server;
  const PgBulkheadPlaces({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<BulkheadPlace>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
                bp.id AS "id",
                bp.project_id AS "projectId",
                bp.ship_id AS "shipId",
                bp.name AS "name",
                bp.bulkhead_id AS "bulkheadId",
                bp.hold_group_id AS "holdGroupId"
            FROM
                bulkhead_place AS bp
            WHERE
                bp.ship_id = 1
            ORDER BY "id";
            """,
      ),
      entryBuilder: (row) => JsonBulkheadPlace(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int,
          'shipId': row['shipId'] as int,
          'name': row['title'] as String,
          'bulkheadId': row['bulkheadId'] as int?,
          'holdGroupId': row['holdGroupId'] as int,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<BulkheadPlace>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final bulkheadPlaces) => Ok(bulkheadPlaces),
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
  //
  @override
  Future<Result<BulkheadPlace, Failure<String>>> fetchById(int id) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
                bp.id AS "id",
                bp.project_id AS "projectId",
                bp.ship_id AS "shipId",
                bp.name AS "name",
                bp.bulkhead_id AS "bulkheadId",
                bp.hold_group_id AS "holdGroupId"
            FROM
                bulkhead_place AS bp
            WHERE
                bp.ship_id = 1
                AND bp.id = $id
            ORDER BY "id";
            """,
      ),
      entryBuilder: (row) => JsonBulkheadPlace(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int,
          'shipId': row['shipId'] as int,
          'name': row['title'] as String,
          'bulkheadId': row['bulkheadId'] as int?,
          'holdGroupId': row['holdGroupId'] as int,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<BulkheadPlace, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final bulkheadPlaces) => Ok(bulkheadPlaces.first),
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
  //
  @override
  Future<Result<BulkheadPlace, Failure<String>>> updateWithId(
    int id,
    BulkheadPlace bulkheadPlace,
  ) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            UPDATE bulkhead_place AS bp SET
                project_id = ${bulkheadPlace.projectId},
                ship_id = ${bulkheadPlace.shipId},
                name = ${bulkheadPlace.name},
                bulkhead_id = ${bulkheadPlace.bulkheadId},
                hold_group_id = ${bulkheadPlace.holdGroupId}
            WHERE
                bp.ship_id = 1
                AND bp.id = 2
            RETURNING
              bp.id AS "id",
              bp.project_id AS "projectId",
              bp.ship_id AS "shipId",
              bp.name AS "name",
              bp.bulkhead_id AS "bulkheadId",
              bp.hold_group_id AS "holdGroupId"
            ;
            """,
      ),
      entryBuilder: (row) => JsonBulkheadPlace(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int,
          'shipId': row['shipId'] as int,
          'name': row['title'] as String,
          'bulkheadId': row['bulkheadId'] as int?,
          'holdGroupId': row['holdGroupId'] as int,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<BulkheadPlace, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final bulkheadPlaces) => Ok(bulkheadPlaces.first),
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
