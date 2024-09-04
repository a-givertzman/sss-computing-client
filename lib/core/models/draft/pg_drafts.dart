import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/draft/draft.dart';
import 'package:sss_computing_client/core/models/draft/drafts.dart';
import 'package:sss_computing_client/core/models/draft/json_draft.dart';
///
/// Stability [Drafts] collection that stored in postgres DB.
class PgDrafts implements Drafts {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates stability [Drafts] collection that stored in postgres DB.
  ///
  ///   - `apiAddress` - [ApiAddress] of server that interact with database;
  ///   - `dbName` - name of the database;
  ///   - `authToken` - string  authentication token for accessing server;
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
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              project_id AS "projectId",
              ship_id AS "shipId",
              name AS "label",
              value AS "value",
              x - 59.194 AS "x",
              y AS "y"
            FROM draft_mark_result
            WHERE
              ship_id = 1
            ORDER BY id;
            """,
      ),
      entryBuilder: (row) => JsonDraft(
        json: {
          'shipId': row['shipId'] as int,
          'projectId': row['projectId'] as int?,
          'label': row['label'] as String,
          'value': row['value'] as double,
          'x': row['x'] as double,
          'y': row['y'] as double,
        },
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<Draft>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final drafts) => Ok(drafts),
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
