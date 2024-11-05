import 'dart:async';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/json_waypoint.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/waypoint.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/waypoints.dart';
/// TODO:
class PgWaypoints implements Waypoints {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  /// TODO
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
          w.hex_color AS "color"
        FROM waypoint AS w
        ORDER BY eta, etd;
      '''),
      entryBuilder: (row) => JsonWaypoint.fromRow(row),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<Waypoint>, Failure<String>>>(
          (result) => switch (result) {
            Ok(:final value) => Ok(value),
            Err(:final error) => Err(Failure(
                message: '$error',
                stackTrace: StackTrace.current,
              )),
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
