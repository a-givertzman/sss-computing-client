import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/future_result_extension.dart';
import 'package:sss_computing_client/core/models/criterion/criterion.dart';
import 'package:sss_computing_client/core/models/criterion/criterions.dart';
import 'package:sss_computing_client/core/models/criterion/json_criterion.dart';
///
/// Stability [Criterions] collection that stored in postgres DB.
class PgStabilityCriterions implements Criterions {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates stability [Criterions] collection that stored in postgres DB.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with database;
  /// * [dbName] – name of the database;
  /// * [authToken] – string  authentication token for accessing server;
  const PgStabilityCriterions({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<Criterion>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              c.title_rus AS "name",
              u.symbol_rus AS "unit",
              c.math_relation::TEXT AS "relation",
              cv.actual_value AS "value",
              cv.limit_value AS "limit"
            FROM
              criterion AS c
              JOIN criterion_values AS cv ON
                cv.criterion_id = c.id
              LEFT JOIN unit AS u ON
                c.unit_id = u.id
            WHERE cv.ship_id = 1 AND c.category_id = 1
            ORDER BY c.id;
            """,
      ),
      entryBuilder: (row) => JsonCriterion.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure();
  }
}
