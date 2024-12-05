import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
import 'package:sss_computing_client/core/models/projects/json_project.dart';
import 'package:sss_computing_client/core/models/projects/project.dart';
import 'package:sss_computing_client/core/models/projects/projects.dart';
///
/// [Project] collection stored in postgres database.
class PgProjects implements Projects {
  static const _log = Log('PgProjects');
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
    ).fetch().convertFailure().then(
          (result) => result
              .inspect(
                (project) => _log.info('project saved'),
              )
              .inspectErr(
                (error) => _log.error('$error'),
              )
              .mapErr(
                (error) => Failure(
                  message: 'fetch error',
                  stackTrace: StackTrace.current,
                ),
              ),
        );
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
    ).fetch().convertFailure().then(
          (result) => result
              .inspect(
                (_) => _log.info('project ${project.name} saved'),
              )
              .inspectErr(
                (error) => _log.error('$error'),
              )
              .mapErr(
                (error) => Failure(
                  message: 'saving error',
                  stackTrace: StackTrace.current,
                ),
              ),
        );
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
    ).fetch().convertFailure().then(
          (result) => result
              .inspect(
                (_) => _log.info('project ${project.name} replaced'),
              )
              .inspectErr(
                (error) => _log.error('$error'),
              )
              .mapErr(
                (error) => Failure(
                  message: 'saving error',
                  stackTrace: StackTrace.current,
                ),
              ),
        );
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
    ).fetch().convertFailure().then(
          (result) => result
              .inspect(
                (_) => _log.info('project ${project.name} loaded'),
              )
              .inspectErr(
                (error) => _log.error('$error'),
              )
              .mapErr(
                (error) => Failure(
                  message: 'loading error',
                  stackTrace: StackTrace.current,
                ),
              ),
        );
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
    ).fetch().convertFailure().then(
          (result) => result
              .inspect(
                (_) => _log.info('project ${project.name} deleted'),
              )
              .inspectErr(
                (error) => _log.error('$error'),
              )
              .mapErr(
                (error) => Failure(
                  message: 'deleting error',
                  stackTrace: StackTrace.current,
                ),
              ),
        );
  }
}
