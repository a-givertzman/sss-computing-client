import 'dart:async';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_containers.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/json_freight_container.dart';
///
/// Collection of [FreightContainer]s that stored in postgres DB.
class PgFreightContainers implements FreightContainers {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates collection of [FreightContainer]s that stored in postgres DB.
  const PgFreightContainers({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Future<Result<List<FreightContainer>, Failure<String>>> fetchAll() {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        SELECT
          c.id AS "id",
          c.iso_code AS "isoCode",
          c.serial_code AS "serialCode",
          c.type_code AS "typeCode",
          c.owner_code AS "ownerCode",
          c.check_digit AS "checkDigit",
          c.gross_mass AS "grossWeight",
          c.max_gross_mass AS "maxGrossWeight",
          c.tare_mass AS "tareWeight",
          c.pol_waypoint_id AS "polWaypointId",
          c.pod_waypoint_id AS "podWaypointId"
        FROM container AS c
        WHERE
          c.ship_id = $shipId AND
          c.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
        ORDER BY id;
      '''),
      entryBuilder: (row) => JsonFreightContainer.fromRow(row),
    );
    return sqlAccess.fetch().convertFailure();
  }
  //
  @override
  Future<Result<void, Failure<String>>> addAll(
    List<FreightContainer> containers,
  ) async {
    final weightsError = _validateWeights(containers);
    if (weightsError != null) {
      return Err(
        Failure(message: weightsError, stackTrace: StackTrace.current),
      );
    }
    final voyageWaypointsError = await _validateVoyageWaypoints(containers);
    if (voyageWaypointsError != null) {
      return Err(
        Failure(message: voyageWaypointsError, stackTrace: StackTrace.current),
      );
    }
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        INSERT INTO container (
          ship_id,
          project_id,
          iso_code,
          serial_code,
          type_code,
          owner_code,
          check_digit,
          gross_mass,
          max_gross_mass,
          tare_mass,
          pol_waypoint_id,
          pod_waypoint_id
        )
        VALUES
           ${containers.map((container) => '(${[
                shipId,
                projectId ?? 'NULL',
                "'${container.type.isoCode}'",
                container.serialCode,
                "'${container.typeCode}'",
                "'${container.ownerCode}'",
                container.checkDigit,
                container.grossWeight,
                container.maxGrossWeight,
                container.tareWeight,
                container.polWaypointId ?? 'NULL',
                container.podWaypointId ?? 'NULL',
              ].join(', ')})').join(',\n')}
        ;
      '''),
      entryBuilder: (row) => JsonFreightContainer.fromRow(row),
    );
    return sqlAccess
        .fetch()
        .then((result) => result.and(const Ok(null)))
        .convertFailure();
  }
  //
  @override
  Future<Result<void, Failure<String>>> removeById(int id) {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        DELETE FROM container
        WHERE id = $id;
      '''),
      entryBuilder: (row) => JsonFreightContainer.fromRow(row),
    );
    return sqlAccess
        .fetch()
        .then((result) => result.and(const Ok(null)))
        .convertFailure();
  }
  //
  @override
  Future<Result<void, Failure<String>>> update(
    FreightContainer newData,
    FreightContainer oldData,
  ) async {
    final weightsError = _validateWeights([newData]);
    if (weightsError != null) {
      return Err(
        Failure(message: weightsError, stackTrace: StackTrace.current),
      );
    }
    final voyageWaypointsError = await _validateVoyageWaypoints([newData]);
    if (voyageWaypointsError != null) {
      return Err(
        Failure(message: voyageWaypointsError, stackTrace: StackTrace.current),
      );
    }
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        UPDATE
          container
        SET
          iso_code = '${newData.type.isoCode}',
          serial_code = ${newData.serialCode},
          type_code = '${newData.typeCode}',
          owner_code = '${newData.ownerCode}',
          check_digit = ${newData.checkDigit},
          gross_mass = ${newData.grossWeight},
          max_gross_mass = ${newData.maxGrossWeight},
          tare_mass = ${newData.tareWeight},
          pol_waypoint_id = ${newData.polWaypointId ?? 'NULL'},
          pod_waypoint_id = ${newData.podWaypointId ?? 'NULL'}
        WHERE id = ${oldData.id};
      '''),
      entryBuilder: (row) => row,
    );
    return sqlAccess
        .fetch()
        .then((result) => result.and(const Ok(null)))
        .convertFailure();
  }
  //
  String? _validateWeights(List<FreightContainer> containers) {
    for (final container in containers) {
      if (container.grossWeight > container.maxGrossWeight) {
        return '${const Localized(
          'Container gross weight must be less than or equal to max gross weight',
        ).v} – ${container.maxGrossWeight}${const Localized('t').v}';
      }
      if (container.grossWeight < container.tareWeight) {
        return '${const Localized(
          'Container gross weight must be greater than or equal to tare weight',
        ).v} – ${container.tareWeight}${const Localized('t').v}';
      }
      if (container.cargoWeight < 0 ||
          container.tareWeight < 0 ||
          container.grossWeight < 0 ||
          container.maxGrossWeight < 0) {
        return const Localized(
          'Container weights must be greater than or equal to 0',
        ).v;
      }
    }
    return null;
  }
  //
  Future<String?> _validateVoyageWaypoints(
    List<FreightContainer> containers,
  ) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        WITH waypoint_order AS (
          SELECT
            row_number() OVER (ORDER BY w.eta ASC, w.eta ASC) AS "order",
            w.id AS "id"
          FROM waypoint AS w
        )
        SELECT
          wo_pol.order::INT AS "polOrder",
          wo_pod.order::INT AS "podOrder"
        FROM (
          VALUES
            ${containers.map(
                (container) =>
                    '(${container.polWaypointId}::INT, ${container.podWaypointId}::INT)',
              ).join(',\n')}
        ) AS container_ports(pol_id, pod_id)
        LEFT JOIN waypoint_order AS wo_pol ON wo_pol.id IS NOT DISTINCT FROM container_ports.pol_id
        LEFT JOIN waypoint_order AS wo_pod ON wo_pod.id IS NOT DISTINCT FROM container_ports.pod_id;
      '''),
      entryBuilder: (row) => row,
    );
    return sqlAccess.fetch().convertFailure().then(
          (result) => switch (result) {
            Ok(value: final rows) => rows.any((row) {
                if (row['polOrder'] == null || row['podOrder'] == null) {
                  return false;
                }
                return row['podOrder'] < row['polOrder'];
              })
                  ? const Localized('POL must be before POD').v
                  : null,
            Err() => const Localized('Check of POL and POD order fails.').v,
          },
        );
  }
}
