import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/general_parameter/json_parameter_value.dart';
import 'package:sss_computing_client/core/models/general_parameter/parameter_value.dart';
///
/// [ParameterValue] collection that stored in postgres DB.
class PgParameterValues {
  static const _log = Log('PgParameterValues');
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates [ParameterValue] collection that stored in postgres DB.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with database;
  /// * [dbName] – name of the database;
  /// * [authToken] – string  authentication token for accessing server;
  const PgParameterValues({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  ///
  /// Fetches and returns [ParameterValue] by [id]
  Future<Result<ParameterValue, Failure<String>>> fetchById(int id) async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: '''
SELECT
  DISTINCT
  ph.title_rus AS "title",
  u.symbol_rus::TEXT AS "unit",
  pd.ship_id AS "shipId",
  pd.project_id AS "projectId",
  pd.result AS "value"
FROM
  parameter_head AS ph
  JOIN parameter_data AS pd ON ph.id = pd.parameter_id
  LEFT JOIN unit AS u ON ph.unit_id = u.id
WHERE
  ph.id = $id AND
  pd.ship_id = $shipId AND
  pd.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
;
            ''',
      ),
      entryBuilder: (row) => JsonParameterValue.fromRow(row),
    );
    // TODO: if ok write extension method to fetch with logging
    return sqlAccess.fetch().then(
          (result) => result
              .inspect((parameters) => _log.info(
                    'fetched ${parameters.length} rows by id: $id',
                  ))
              .inspectErr((error) => _log.error(
                    error,
                  ))
              .mapErr((_) => Failure(
                    message: 'fetch error',
                    stackTrace: StackTrace.current,
                  ))
              .andThen((parameters) => parameters.isNotEmpty
                  ? Ok(parameters.first)
                  : Err(Failure(
                      message: 'not found',
                      stackTrace: StackTrace.current,
                    ))),
        );
  }
}
