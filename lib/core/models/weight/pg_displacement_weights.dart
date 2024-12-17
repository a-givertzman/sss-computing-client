import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
import 'package:sss_computing_client/core/models/weight/displacement_weight.dart';
import 'package:sss_computing_client/core/models/weight/displacement_weights.dart';
import 'package:sss_computing_client/core/models/weight/json_displacement_weight.dart';
///
/// [DisplacementWeights] collection that stored in postgres DB.
class PgDisplacementWeights implements DisplacementWeights {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates [DisplacementWeights] collection that stored in postgres DB.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with database;
  /// * [dbName] – name of the database;
  /// * [authToken] – string  authentication token for accessing server;
  const PgDisplacementWeights({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<DisplacementWeight>, Failure<String>>> fetchAll() async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => _sql(shipId: shipId, projectId: projectId),
      entryBuilder: (row) => JsonDisplacementWeight.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure();
  }
  Sql _sql({required int shipId, required int? projectId}) => Sql(
        sql: '${<({int valueId})>[
          (valueId: 27),
          (valueId: 25),
          (valueId: 26),
          (valueId: 29),
          (valueId: 2),
          (valueId: 28),
          (valueId: 30),
          (valueId: 31),
        ].map(
              (ids) => _sqlQueryPart(
                shipId: shipId,
                projectId: projectId,
                valueParameterId: ids.valueId,
              ),
            ).join('\nUNION\n')};',
      );
  String _sqlQueryPart({
    required int shipId,
    required int? projectId,
    required int valueParameterId,
  }) =>
      // TODO: remove `COALESCE`
      '''
SELECT
  vpd.result AS "value",
  COALESCE(vph.title_eng, vph.title_rus) AS "name",
  NULL::REAL AS "lcg",
  NULL::REAL AS "tcg",
  NULL::REAL AS "vcg",
  NULL::REAL AS "vcgCorrection"
FROM
  parameter_data AS vpd
JOIN
  parameter_head AS vph ON
    vpd.parameter_id = vph.id AND
    vpd.ship_id = $shipId AND
    vpd.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
WHERE
  vpd.parameter_id = $valueParameterId
''';
}
