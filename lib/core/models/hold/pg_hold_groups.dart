import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/hold/hold_group.dart';
import 'package:sss_computing_client/core/models/hold/hold_groups.dart';
import 'package:sss_computing_client/core/models/hold/json_hold_group.dart';
///
/// [HoldGroups] collection that stored in postgres DB.
class PgHoldGroups implements HoldGroups {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// [HoldGroups] collection that stored in postgres DB.
  ///
  ///   - [apiAddress] – [ApiAddress] of server that interact with database;
  ///   - [dbName] – name of the database;
  ///   - [authToken] – string  authentication token for accessing server;
  const PgHoldGroups({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<HoldGroup>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
                hg.id AS "id",
                hg.project_id AS "projectId",
                hg.ship_id AS "shipId",
                hg.name AS "name"
            FROM
                hold_group AS hg
            WHERE
                hg.ship_id = 1
            ORDER BY "id";
            """,
      ),
      entryBuilder: (row) => JsonHoldGroup(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int,
          'shipId': row['shipId'] as int,
          'name': row['title'] as String,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<HoldGroup>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final holdGroups) => Ok(holdGroups),
            Err(:final error) => Err(Failure(
                message: '$error',
                stackTrace: StackTrace.current,
              )),
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
  Future<Result<HoldGroup, Failure<String>>> fetchById(int id) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
                hg.id AS "id",
                hg.project_id AS "projectId",
                hg.ship_id AS "shipId",
                hg.name AS "name"
            FROM
                hold_group AS hg
            WHERE
                hg.ship_id = 1
                AND hg.id = $id
            ORDER BY "id";
            """,
      ),
      entryBuilder: (row) => JsonHoldGroup(
        json: {
          'id': row['id'] as int,
          'projectId': row['projectId'] as int,
          'shipId': row['shipId'] as int,
          'name': row['title'] as String,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<HoldGroup, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final holdGroups) => Ok(holdGroups.first),
            Err(:final error) => Err(Failure(
                message: '$error',
                stackTrace: StackTrace.current,
              )),
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
