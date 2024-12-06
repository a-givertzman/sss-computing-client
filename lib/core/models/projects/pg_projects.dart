import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
import 'package:sss_computing_client/core/models/projects/json_project.dart';
import 'package:sss_computing_client/core/models/projects/project.dart';
import 'package:sss_computing_client/core/models/projects/projects.dart';
///
/// [Project] collection stored in postgres database.
class PgProjects implements Projects {
  static const _log = Log('PgProjects | ');
  final ApiAddress apiAddress;
  final String dbName;
  final String authToken;
  ///
  /// Creates [Project] collection stored in postgres database.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with database;
  /// * [dbName] – name of the database;
  /// * [authToken] – string authentication token for accessing server;
  const PgProjects({
    required this.apiAddress,
    required this.dbName,
    required this.authToken,
  });
  //
  @override
  Future<Result<List<Project>, Failure<String>>> fetchAll() {
    return SqlAccess(
      address: apiAddress,
      database: dbName,
      authToken: authToken,
      sqlBuilder: (_, __) => Sql(
        sql: '''
SELECT
  dc.id AS "id",
  dc.name AS "name",
  dc.created_at AS "createdAt",
  dc.last_loaded_at AS "loadedAt",
  dc.is_active AS "isLoaded"
FROM
  custom_metadata.db_checkpoint AS dc
ORDER BY
  dc.id DESC;
''',
      ),
      entryBuilder: (row) => JsonProject.fromRow(row),
    )
        .fetch()
        .logResult(
          _log,
          message: 'fetching projects',
          okMessage: (projects) => 'projects fetched: ${projects.length}',
        )
        .convertFailure(errorMessage: (_) => 'fetch error');
  }
  //
  @override
  Future<Result<void, Failure<String>>> add(Project project) {
    return SqlAccess(
      address: apiAddress,
      database: dbName,
      authToken: authToken,
      sqlBuilder: (_, __) => Sql(
        sql: '''
INSERT INTO
  custom_metadata.db_checkpoint (name, database_info_id)
SELECT
  '${project.name}', di.id
FROM
  custom_metadata.db_info AS di
WHERE
  di.database_name = '$dbName';
''',
      ),
      entryBuilder: (row) => JsonProject.fromRow(row),
    )
        .fetch()
        .logResult(
          _log,
          message: 'saving project "${project.name}"',
          okMessage: (_) => 'project "${project.name}" added',
        )
        .convertFailure(errorMessage: (_) => 'saving error');
  }
  //
  @override
  Future<Result<void, Failure<String>>> replace(Project old, Project project) {
    return SqlAccess(
      address: apiAddress,
      database: dbName,
      authToken: authToken,
      sqlBuilder: (_, __) => Sql(
        sql: '''
DO \$\$ BEGIN
  DELETE FROM
    custom_metadata.db_checkpoint
  WHERE
    id = ${old.id};
  INSERT INTO
    custom_metadata.db_checkpoint (name, database_info_id)
  SELECT
    '${project.name}', di.id
  FROM
    custom_metadata.db_info AS di
  WHERE
    di.database_name = '$dbName';
END \$\$;
''',
      ),
      entryBuilder: (row) => JsonProject.fromRow(row),
    )
        .fetch()
        .logResult(
          _log,
          message: 'replacing project "${project.name}"',
          okMessage: (_) => 'project "${project.name}" replaced',
        )
        .convertFailure(errorMessage: (_) => 'saving error');
  }
  //
  @override
  Future<Result<void, Failure<String>>> load(Project project) {
    return SqlAccess(
      address: apiAddress,
      database: dbName,
      authToken: authToken,
      sqlBuilder: (_, __) => Sql(
        sql: '''
UPDATE custom_metadata.db_checkpoint
SET
  is_active = true
WHERE
  id = ${project.id};
''',
      ),
    )
        .fetch()
        .logResult(
          _log,
          message: 'loading project "${project.name}"',
          okMessage: (_) => 'project "${project.name}" loaded',
        )
        .convertFailure(errorMessage: (_) => 'loading error');
  }
  //
  @override
  Future<Result<void, Failure<String>>> remove(Project project) {
    return SqlAccess(
      address: apiAddress,
      database: dbName,
      authToken: authToken,
      sqlBuilder: (_, __) => Sql(
        sql: '''
DELETE FROM custom_metadata.db_checkpoint
WHERE
  id = ${project.id};
''',
      ),
    )
        .fetch()
        .logResult(
          _log,
          message: 'removing project "${project.name}"',
          okMessage: (_) => 'project "${project.name}" removed',
        )
        .convertFailure(errorMessage: (_) => 'deleting error');
  }
}
