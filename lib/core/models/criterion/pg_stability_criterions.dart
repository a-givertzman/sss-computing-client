import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
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
              cs.title_rus AS "name",
              cs.unit_rus::TEXT AS "unit",
              cs.relation::TEXT AS "relation",
              rs.result AS "value",
              rs.target AS "limit",
            FROM
              criterion_stability AS cs JOIN result_stability AS rs
              ON rs.criterion_id = cs.id
            WHERE rs.ship_id = 1
            ORDER BY cs.id;
            """,
      ),
      entryBuilder: (row) => JsonCriterion(
        json: {
          'name': row['name'] as String,
          'value': row['value'] as double,
          'limit': row['limit'] as double,
          'relation': row['relation'] as String,
          'unit': row['unit'] as String?,
          'description': null,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<Criterion>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final criterions) => Ok(criterions),
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
