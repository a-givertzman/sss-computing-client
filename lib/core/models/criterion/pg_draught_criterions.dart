import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
import 'package:sss_computing_client/core/models/criterion/criterion.dart';
import 'package:sss_computing_client/core/models/criterion/criterions.dart';
import 'package:sss_computing_client/core/models/criterion/json_criterion.dart';
///
/// Draught [Criterions] collection that stored in postgres DB.
class PgDraughtCriterions implements Criterions {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates draught [Criterions] collection that stored in postgres DB.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with database;
  /// * [dbName] – name of the database;
  /// * [authToken] – string  authentication token for accessing server;
  const PgDraughtCriterions({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<Criterion>, Failure<String>>> fetchAll() async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              c.title_rus AS "name",
              c.math_relation::TEXT AS "relation",
              u.symbol_rus AS "unit",
              cv.ship_id,
              cv.project_id,
              cv.actual_value AS "value",
              cv.limit_value AS "limit"
            FROM
              criterion AS c
              JOIN criterion_values AS cv ON
                  cv.criterion_id = c.id
              LEFT JOIN load_line_type_criterions AS lltc ON
                  lltc.criterion_id = c.id
              LEFT JOIN ship_available_load_line_types AS sallt ON
                  sallt.load_line_type_id = lltc.load_line_type_id AND
                  sallt.ship_id = cv.ship_id AND
                  sallt.project_id IS NOT DISTINCT FROM cv.project_id
              LEFT JOIN unit AS u ON
                  c.unit_id = u.id
            WHERE
              cv.ship_id = $shipId AND
              cv.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'} AND
              c.category_id = 2 AND
              (
                  sallt.is_active = TRUE OR
                  sallt.is_active IS NOT DISTINCT FROM NULL
              )
            ORDER BY c.id;
            """,
      ),
      entryBuilder: (row) => JsonCriterion.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure();
  }
}
