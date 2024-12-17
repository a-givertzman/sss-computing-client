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
        sql: '${<({int valueId, int lcgId, int tcgId, int vcgId, bool asHeader, bool asSubitem})>[
          (valueId: 2, lcgId: 32, tcgId: 52, vcgId: -1, asHeader: false, asSubitem: false), // Displacement
          (valueId: 28, lcgId: -1, tcgId: -1, vcgId: -1, asHeader: true, asSubitem: false), // DWT
          (valueId: 27, lcgId: 61, tcgId: 66, vcgId: 72, asHeader: false, asSubitem: true), // Cargo
          (valueId: 25, lcgId: 59, tcgId: 64, vcgId: 70, asHeader: false, asSubitem: true), // Ballast
          (valueId: 26, lcgId: 60, tcgId: 65, vcgId: 71, asHeader: false, asSubitem: true), // Stores
          (valueId: 30, lcgId: 62, tcgId: 68, vcgId: 74, asHeader: false, asSubitem: false), // Icing
          (valueId: 31, lcgId: 63, tcgId: 69, vcgId: 75, asHeader: false, asSubitem: false), // Timber
          (valueId: 29, lcgId: 58, tcgId: 77, vcgId: 78, asHeader: false, asSubitem: false), // Lightship
        ].map(
              (parameters) => _sqlQueryPart(
                shipId: shipId,
                projectId: projectId,
                ids: (valueId: parameters.valueId, lcgId: parameters.lcgId, tcgId: parameters.tcgId, vcgId: parameters.vcgId),
                options: (asHeader: parameters.asHeader, asSubitem: parameters.asSubitem),
              ),
            ).join('\nUNION ALL\n')};',
      );
  String _sqlQueryPart({
    required int shipId,
    required int? projectId,
    required ({int valueId, int lcgId, int tcgId, int vcgId}) ids,
    required ({bool asHeader, bool asSubitem}) options,
  }) =>
      // TODO: remove `COALESCE`
      '''
SELECT
  vpd.result AS "value",
  COALESCE(vph.title_eng, vph.title_rus) AS "name",
  lcgpd.result AS "lcg",
  tcgpd.result AS "tcg",
  vcgpd.result AS "vcg",
  NULL::REAL AS "vcgCorrection",
  ${options.asHeader ? 'TRUE' : 'FALSE'} AS "asHeader",
  ${options.asSubitem ? 'TRUE' : 'FALSE'} AS "asSubitem"
FROM
  parameter_data AS vpd
LEFT JOIN
  parameter_head AS vph ON
    vpd.parameter_id = vph.id AND
    vpd.ship_id = $shipId AND
    vpd.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
LEFT JOIN
  parameter_data AS lcgpd ON
    lcgpd.parameter_id = ${ids.lcgId} AND
    lcgpd.ship_id = $shipId AND
    lcgpd.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
LEFT JOIN
  parameter_data AS tcgpd ON
    tcgpd.parameter_id = ${ids.tcgId} AND
    tcgpd.ship_id = $shipId AND
    tcgpd.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
LEFT JOIN
  parameter_data AS vcgpd ON
    vcgpd.parameter_id = ${ids.vcgId} AND
    vcgpd.ship_id = $shipId AND
    vcgpd.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
WHERE
  vpd.parameter_id = ${ids.valueId}
''';
}
