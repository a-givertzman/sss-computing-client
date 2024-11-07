import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkheads.dart';
import 'package:sss_computing_client/core/models/bulkheads/json_bulkhead.dart';
///
/// [Bulkheads] collection that stored in postgres DB.
class PgBulkheads implements Bulkheads {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// [Bulkheads] collection that stored in postgres DB.
  ///
  ///   - [apiAddress] – [ApiAddress] of server that interact with database;
  ///   - [dbName] – name of the database;
  ///   - [authToken] – string  authentication token for accessing server;
  const PgBulkheads({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<Bulkhead>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
                b.id AS "id",
                b.project_id AS "projectId",
                b.ship_id AS "shipId",
                b.name AS "name"
            FROM
                bulkhead AS b
            WHERE
                b.ship_id = 1
            ORDER BY "id";
            """,
      ),
      entryBuilder: (row) => JsonBulkhead(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int?,
          'shipId': row['shipId'] as int,
          'name': row['name'] as String,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<Bulkhead>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final bulkheads) => Ok(bulkheads),
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
  Future<Result<List<Bulkhead>, Failure<String>>> fetchAllRemoved() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
                b.id AS "id",
                b.project_id AS "projectId",
                b.ship_id AS "shipId",
                b.name AS "name"
            FROM
                bulkhead AS b
            WHERE
                b.ship_id = 1
                AND (
                  b.id NOT IN (
                    SELECT
                      bp.bulkhead_id
                    FROM
                      bulkhead_place AS bp
                    WHERE
                      bp.ship_id = 1
                      AND bp.bulkhead_id IS DISTINCT FROM NULL
                    )
                )
            ORDER BY "id";
            """,
      ),
      entryBuilder: (row) => JsonBulkhead(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int?,
          'shipId': row['shipId'] as int,
          'name': row['name'] as String,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<Bulkhead>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final bulkheads) => Ok(bulkheads),
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
  Future<Result<Bulkhead, Failure<String>>> fetchById(int id) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
                b.id AS "id",
                b.project_id AS "projectId",
                b.ship_id AS "shipId",
                b.name AS "name"
            FROM
                bulkhead AS b
            WHERE
                b.ship_id = 1
                AND b.id = $id
            ORDER BY "id";
            """,
      ),
      entryBuilder: (row) => JsonBulkhead(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int?,
          'shipId': row['shipId'] as int,
          'name': row['name'] as String,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<Bulkhead, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final bulkheads) => Ok(bulkheads.first),
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
