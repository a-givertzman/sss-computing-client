import 'dart:async';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_containers.dart';
import 'package:sss_computing_client/core/models/stowage/container/json_freight_container.dart';
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
        ORDER BY id;
      '''),
      entryBuilder: (row) => JsonFreightContainer.fromRow(row),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<FreightContainer>, Failure<String>>>(
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
  //
  @override
  Future<Result<void, Failure<String>>> addAll(
    List<FreightContainer> containers,
  ) {
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
                1,
                'NULL',
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
        .then<Result<void, Failure<String>>>(
          (result) => switch (result) {
            Ok() => const Ok(null),
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
        .then<Result<void, Failure<String>>>(
          (result) => switch (result) {
            Ok() => const Ok(null),
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
  //
  @override
  Future<Result<void, Failure<String>>> update(
    FreightContainer newData,
    FreightContainer oldData,
  ) async {
    final weightsError = _validateWeights(newData);
    if (weightsError != null) {
      return Err(
        Failure(message: weightsError, stackTrace: StackTrace.current),
      );
    }
    final voyageWaypointsError = await _validateVoyageWaypoints(newData);
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
        .then<Result<void, Failure<String>>>(
          (result) => switch (result) {
            Ok() => const Ok(null),
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
  //
  String? _validateWeights(FreightContainer container) {
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
    return null;
  }
  //
  Future<String?> _validateVoyageWaypoints(FreightContainer container) async {
    final polWaypointId = container.polWaypointId;
    final podWaypointId = container.podWaypointId;
    if (polWaypointId == null || podWaypointId == null) return null;
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
          (SELECT wo.order FROM waypoint_order AS wo WHERE id IS NOT DISTINCT FROM $polWaypointId) AS "polOrder",
          (SELECT wo.order FROM waypoint_order AS wo WHERE id IS NOT DISTINCT FROM $podWaypointId) AS "podOrder";
      '''),
      entryBuilder: (row) => row,
    );
    return sqlAccess
        .fetch()
        .then((result) => switch (result) {
              Ok(value: final rows) => () {
                  return rows.firstOrNull?['polOrder'] <
                          rows.firstOrNull?['podOrder']
                      ? null
                      : const Localized('POL must be before POD').v;
                }(),
              Err() => const Localized('Check of POL and POD order fails.').v,
            })
        .catchError(
          (_) => const Localized('Check of POL and POD order fails.').v,
        );
  }
}
