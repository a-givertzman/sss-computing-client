import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead_place.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead_places.dart';
import 'package:sss_computing_client/core/models/bulkheads/json_bulkhead_place.dart';
import 'package:sss_computing_client/core/future_result_extension.dart';
///
/// [BulkheadPlaces] collection that stored in postgres DB.
class PgBulkheadPlaces implements BulkheadPlaces {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// [BulkheadPlaces] collection that stored in postgres DB.
  ///
  ///   - [apiAddress] – [ApiAddress] of server that interact with database;
  ///   - [dbName] – name of the database;
  ///   - [authToken] – string  authentication token for accessing server;
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
            ORDER BY "id" DESC;
            """,
      ),
      entryBuilder: (row) => JsonBulkheadPlace(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int?,
          'shipId': row['shipId'] as int,
          'name': row['name'] as String,
          'bulkheadId': row['bulkheadId'] as int?,
          'holdGroupId': row['holdGroupId'] as int,
        },
      ),
    );
    return sqlAccess.fetch().convertFailure();
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
            ORDER BY "id" DESC;
            """,
      ),
      entryBuilder: (row) => JsonBulkheadPlace(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int?,
          'shipId': row['shipId'] as int,
          'name': row['name'] as String,
          'bulkheadId': row['bulkheadId'] as int?,
          'holdGroupId': row['holdGroupId'] as int,
        },
      ),
    );
    return sqlAccess.fetch().convertFailure().then((result) => switch (result) {
          Ok(value: final entries) => entries.length == 1
              ? Ok(entries.first)
              : Err(Failure(
                  message: 'Not found',
                  stackTrace: StackTrace.current,
                )),
          Err(:final error) => Err(error),
        });
  }
  //
  @override
  Future<Result<void, Failure<String>>> installBulkheadWithId(
    int placeId,
    int bulkheadId,
  ) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            DO \$\$ BEGIN
              UPDATE bulkhead_place AS bp SET
                  bulkhead_id = NULL
              WHERE
                  bp.bulkhead_id = $bulkheadId;
              UPDATE bulkhead_place AS bp SET
                  bulkhead_id = $bulkheadId
              WHERE
                  bp.id = $placeId;
            END \$\$;
            """,
      ),
    );
    return sqlAccess.fetch().convertFailure();
  }
  //
  @override
  Future<Result<void, Failure<String>>> removeBulkheadWithId(
    int bulkheadId,
  ) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            UPDATE bulkhead_place AS bp SET
                bulkhead_id = NULL
            WHERE
                bp.bulkhead_id = $bulkheadId;
            """,
      ),
    );
    return sqlAccess.fetch().convertFailure();
  }
}
