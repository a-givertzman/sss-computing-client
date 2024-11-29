import 'dart:async';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
import 'package:sss_computing_client/core/models/voyage/json_waypoint.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
import 'package:sss_computing_client/core/models/voyage/waypoints.dart';
///
/// [Waypoints] stored in Postgres DB.
class PgWaypoints implements Waypoints {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates [Waypoints] stored in Postgres DB.
  const PgWaypoints({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Future<Result<List<Waypoint>, Failure<String>>> fetchAll() {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        SELECT
          w.id AS "id",
          w.ship_id AS "shipId",
          w.project_id AS "projectId",
          w.port_name AS "portName",
          w.port_code AS "portCode",
          w.eta::TEXT AS "eta",
          w.etd::TEXT AS "etd",
          w.hex_color AS "color",
          w.max_draught AS "draftLimit",
          w.use_max_draught AS "useDraftLimit"
        FROM waypoint AS w
        WHERE
          w.ship_id = $shipId AND
          w.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
        ORDER BY eta, etd, id;
      '''),
      entryBuilder: (row) => JsonWaypoint.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure();
  }
  //
  @override
  Future<Result<Waypoint, Failure<String>>> add(Waypoint waypoint) async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
      INSERT INTO
        waypoint
      (
        ship_id,
        project_id,
        port_name,
        port_code,
        eta,
        etd,
        hex_color,
        max_draught,
        use_max_draught
      )
      VALUES (
        $shipId,
        ${projectId ?? 'NULL'},
        '${waypoint.portName}',
        '${waypoint.portCode}',
        '${waypoint.eta}',
        '${waypoint.etd}',
        '${waypoint.color.value.toRadixString(16)}',
        ${waypoint.draftLimit},
        ${waypoint.useDraftLimit ? 'TRUE' : 'FALSE'}
      )
      RETURNING
        id AS "id",
        ship_id AS "shipId",
        project_id AS "projectId",
        port_name AS "portName",
        port_code AS "portCode",
        eta::TEXT AS "eta",
        etd::TEXT AS "etd",
        hex_color AS "color",
        max_draught AS "draftLimit",
        use_max_draught AS "useDraftLimit"
      ;
    '''),
      entryBuilder: (row) => JsonWaypoint.fromRow(row),
    );
    const errorMessage = 'waypoint not added';
    return sqlAccess.fetch().convertFailure().then(
          (result) => switch (result) {
            Ok(value: final waypoints) => waypoints.isNotEmpty
                ? Ok(waypoints.first)
                : Err(Failure(
                    message: errorMessage,
                    stackTrace: StackTrace.current,
                  )),
            Err() => Err(Failure(
                message: errorMessage,
                stackTrace: StackTrace.current,
              )),
          },
        );
  }
  //
  @override
  Future<Result<void, Failure<String>>> remove(Waypoint waypoint) async {
    final clearResult = await _clearContainerReference(waypoint);
    if (clearResult case Err(:final error)) return Err(error);
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
      DELETE FROM waypoint WHERE id = ${waypoint.id};
    '''),
    );
    return sqlAccess.fetch().convertFailure();
  }
  //
  @override
  Future<Result<Waypoint, Failure<String>>> update(
    Waypoint newData,
    Waypoint oldData,
  ) async {
    final validateResult = _validateId(newData, oldData);
    if (validateResult case Err(:final error)) return Err(error);
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
      UPDATE
        waypoint
      SET
        port_name = '${newData.portName}',
        port_code = '${newData.portCode}',
        eta = '${newData.eta}',
        etd = '${newData.etd}',
        hex_color = '${newData.color.value.toRadixString(16)}',
        max_draught = ${newData.draftLimit},
        use_max_draught = ${newData.useDraftLimit ? 'TRUE' : 'FALSE'}
      WHERE id = ${oldData.id}
      RETURNING
        id AS "id",
        ship_id AS "shipId",
        project_id AS "projectId",
        port_name AS "portName",
        port_code AS "portCode",
        eta::TEXT AS "eta",
        etd::TEXT AS "etd",
        hex_color AS "color",
        max_draught AS "draftLimit",
        use_max_draught AS "useDraftLimit"
      ;
    '''),
      entryBuilder: (row) => JsonWaypoint.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure().then(
          (result) => switch (result) {
            Ok(value: final rows) => rows.isNotEmpty
                ? Ok(rows.first)
                : Err(Failure(
                    message: 'no rows updated',
                    stackTrace: StackTrace.current,
                  )),
            Err(:final error) => Err(error),
          },
        );
  }
  //
  Result<void, Failure<String>> _validateId(
    Waypoint newData,
    Waypoint oldData,
  ) {
    if (newData.id != oldData.id) {
      return Err(Failure(
        message: 'id mismatch on update',
        stackTrace: StackTrace.current,
      ));
    }
    return const Ok(null);
  }
  //
  @override
  Future<Result<int, Failure<String>>> validateContainerReference(
    Waypoint waypoint,
  ) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        SELECT
          COUNT(*) AS "referenceCount"
        FROM container AS c
        WHERE
          c.pol_waypoint_id = ${waypoint.id} OR
          c.pod_waypoint_id = ${waypoint.id}
        ;
      '''),
      entryBuilder: (row) => row['referenceCount'],
    );
    const errorMessage = 'checking of containers port references failed';
    return sqlAccess.fetch().convertFailure().then((result) => switch (result) {
          Ok(value: final references) => references.isNotEmpty
              ? Ok(references.first as int)
              : Err(Failure(
                  message: errorMessage,
                  stackTrace: StackTrace.current,
                )),
          Err() => Err(Failure(
              message: errorMessage,
              stackTrace: StackTrace.current,
            )),
        });
  }
  ///
  /// Clear all containers fk with this waypoint as POL or POD
  Future<Result<void, Failure<String>>> _clearContainerReference(
    Waypoint waypoint,
  ) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        DO \$\$ BEGIN
          UPDATE
            container
          SET
            pol_waypoint_id = NULL
          WHERE
            pol_waypoint_id = ${waypoint.id};
          UPDATE
            container
          SET
            pod_waypoint_id = NULL
          WHERE
            pod_waypoint_id = ${waypoint.id};
        END \$\$;
      '''),
    );
    return sqlAccess.fetch().convertFailure();
  }
}
