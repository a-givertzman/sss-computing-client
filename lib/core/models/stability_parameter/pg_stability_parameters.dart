import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
import 'package:sss_computing_client/core/models/stability_parameter/json_stability_parameter.dart';
import 'package:sss_computing_client/core/models/stability_parameter/stability_parameter.dart';
import 'package:sss_computing_client/core/models/stability_parameter/stability_parameters.dart';
///
/// [StabilityParameter] collection that stored in postgres DB.
class PgStabilityParameters implements StabilityParameters {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates [StabilityParameter] collection that stored in postgres DB.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with database;
  /// * [dbName] – name of the database;
  /// * [authToken] – string  authentication token for accessing server;
  const PgStabilityParameters({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<StabilityParameter>, Failure<String>>> fetchAll() async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        // TODO: remove COALESCE
        sql: """
            SELECT
              DISTINCT
              COALESCE(ph.title_eng, ph.title_rus) AS "title",
              u.symbol_eng::TEXT AS "unit",
              pd.ship_id AS "shipId",
              pd.project_id AS "projectId",
              pd.result AS "value"
            FROM
              parameter_head AS ph
              LEFT JOIN criterions_parameters AS cp ON ph.id = cp.parameter_id
              LEFT JOIN criterion AS c ON cp.criterion_id = c.id
              LEFT JOIN unit AS u ON ph.unit_id = u.id
              JOIN parameter_data AS pd ON ph.id = pd.parameter_id
            WHERE
              (cp.criterion_id IS NOT NULL OR cp.always_visible = TRUE) AND
              pd.ship_id = $shipId AND
              pd.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
            ORDER BY "title";
            """,
      ),
      entryBuilder: (row) => JsonStabilityParameter.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure();
  }
}
