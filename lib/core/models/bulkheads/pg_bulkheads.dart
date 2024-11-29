import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
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
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
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
                b.name_rus AS "name",
                b.mass AS "mass",
                bp.mass_shift_x AS "lcg",
                bp.mass_shift_y AS "tcg",
                bp.mass_shift_z AS "vcg"
            FROM
                bulkhead AS b
            LEFT JOIN
                bulkhead_place AS bp ON
                  b.id = bp.bulkhead_id AND
                  b.ship_id = bp.ship_id AND
                  b.project_id IS NOT DISTINCT FROM bp.project_id
            WHERE
                b.ship_id = $shipId AND
                b.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
            ORDER BY "id";
            """,
      ),
      entryBuilder: (row) => JsonBulkhead.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure();
  }
  //
  @override
  Future<Result<List<Bulkhead>, Failure<String>>> fetchAllRemoved() async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
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
                b.name_rus AS "name",
                b.mass AS "mass",
                bp.mass_shift_x AS "lcg",
                bp.mass_shift_y AS "tcg",
                bp.mass_shift_z AS "vcg"
            FROM
                bulkhead AS b
            LEFT JOIN
                bulkhead_place AS bp ON
                  b.id = bp.bulkhead_id AND
                  b.ship_id = bp.ship_id AND
                  b.project_id IS NOT DISTINCT FROM bp.project_id
            WHERE
                b.ship_id = $shipId AND
                b.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'} AND
                (
                  b.id NOT IN (
                    SELECT
                      bp.bulkhead_id
                    FROM
                      bulkhead_place AS bp
                    WHERE
                      bp.ship_id = $shipId AND
                      bp.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'} AND
                      bp.bulkhead_id IS DISTINCT FROM NULL
                    )
                )
            ORDER BY "id";
            """,
      ),
      entryBuilder: (row) => JsonBulkhead.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure();
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
                b.name_rus AS "name",
                b.mass AS "mass",
                bp.mass_shift_x AS "lcg",
                bp.mass_shift_y AS "tcg",
                bp.mass_shift_z AS "vcg"
            FROM
                bulkhead AS b
            LEFT JOIN
                bulkhead_place AS bp ON
                  b.id = bp.bulkhead_id AND
                  b.ship_id = bp.ship_id AND
                  b.project_id IS NOT DISTINCT FROM bp.project_id
            WHERE
              b.id = $id
            ORDER BY "id";
            """,
      ),
      entryBuilder: (row) => JsonBulkhead.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure().then(
          (result) => switch (result) {
            Ok(value: final entries) => entries.length == 1
                ? Ok(entries.first)
                : Err(Failure(
                    message: 'Not found',
                    stackTrace: StackTrace.current,
                  )),
            Err(:final error) => Err(error),
          },
        );
  }
}
