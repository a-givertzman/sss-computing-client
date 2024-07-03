import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stability_parameter/json_stability_parameter.dart';
import 'package:sss_computing_client/core/models/stability_parameter/stability_parameter.dart';
import 'package:sss_computing_client/core/models/stability_parameter/stability_parameters.dart';
///
/// Stability [Criterions] collection that stored in postgres DB.
class PgStabilityParameters implements StabilityParameters {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates stability [Criterions] collection that stored in postgres DB.
  const PgStabilityParameters({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  ///
  get apiAddress => _apiAddress;
  ///
  get dbName => _dbName;
  //
  @override
  Future<Result<List<StabilityParameter>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              DISTINCT
              ph.title_rus AS "title",
              ph.unit_rus::TEXT AS "unit",
              pd.ship_id AS "shipId",
              pd.project_id AS "projectId",
              pd.result AS "value"
            FROM
              parameter_head AS ph
              LEFT JOIN criterions_parameters AS cp ON ph.id = cp.parameter_id
              LEFT JOIN criterion_stability AS cs ON cp.criterion_id = cs.id
              JOIN parameter_data AS pd ON ph.id = pd.parameter_id
            WHERE
              (cp.criterion_id IS NOT NULL
              OR cp.always_visible = TRUE) AND pd.ship_id = 1
            ORDER BY "title";
            """,
      ),
      entryBuilder: (row) => JsonStabilityParameter(
        json: {
          'name': row['title'] as String,
          'value': row['value'] as double,
          'unit': row['unit'] as String?,
          'description': null,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<StabilityParameter>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final parameters) => Ok(parameters),
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
