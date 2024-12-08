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
        sql: """
            SELECT
              dmr.project_id AS "projectId",
              dmr.ship_id AS "shipId",
              dmr.name AS "label",
              dmr.value AS "value",
              dmr.x AS "x",
              dmr.y AS "y"
            FROM draft_mark_result AS dmr
            WHERE
              dmr.ship_id = $shipId AND
              dmr.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
            ORDER BY dmr.id;
            """,
      ),
      entryBuilder: (row) => JsonDraft.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure();
  }
}
