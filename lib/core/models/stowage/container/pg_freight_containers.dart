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
}
