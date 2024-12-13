import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
import 'package:sss_computing_client/core/models/draft/draft.dart';
import 'package:sss_computing_client/core/models/draft/drafts.dart';
import 'package:sss_computing_client/core/models/draft/json_draft.dart';
///
/// [Drafts] collection that stored in postgres DB.
class PgDrafts implements Drafts {
  static const _log = Log('PgDrafts | ');
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates [Drafts] collection that stored in postgres DB.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with database;
  /// * [dbName] – name of the database;
  /// * [authToken] – string  authentication token for accessing server;
  const PgDrafts({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<Draft>, Failure<String>>> fetchAll() async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: '''
WITH draft_marks AS (
  SELECT
    dm.name AS "name",
    dm.criterion_id AS "criterion_id",
    dm.ship_id AS "ship_id",
    dm.project_id AS "project_id",
    avg(dm.x) AS "x",
    avg(dm.y) AS "y"
  FROM
    draft_mark AS dm
  GROUP BY
    dm.criterion_id, dm.name, dm.ship_id, dm.project_id
)
SELECT
  dm.ship_id AS "shipId",
  dm.project_id AS "projectId",
  dm.name AS "label",
  dm.x AS "x",
  dm.y AS "y",
  pd.result AS "value"
FROM
  draft_marks AS dm
LEFT JOIN
  parameter_data AS pd ON
  dm.ship_id = pd.ship_id AND
  dm.project_id IS NOT DISTINCT FROM pd.project_id AND
  dm.criterion_id = pd.parameter_id
WHERE
  dm.ship_id = $shipId AND
  dm.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'} AND
  dm.y <> 0.0
ORDER BY
  dm.name, dm.x, dm.y;
''',
      ),
      entryBuilder: (row) => JsonDraft.fromRow(row),
    );
    return sqlAccess
        .fetch()
        .logResult(
          _log,
          message: 'fetching drafts',
          okMessage: (_) => 'drafts fetched',
        )
        .convertFailure(
          errorMessage: 'fetch error',
        );
  }
}
