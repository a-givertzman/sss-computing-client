import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/future_result_extension.dart';
import 'package:sss_computing_client/core/models/options_field/options_field.dart';
import 'package:sss_computing_client/core/models/voyage/voyage_details.dart';
///
/// Voyage details that are stored in postgres DB.
class PgVoyageDetails {
  static const _log = Log('PgVoyageDetails');
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  const PgVoyageDetails({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  ///
  /// Creates [VoyageDetails] that are stored in postgres DB.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with database;
  /// * [dbName] – name of the database;
  /// * [authToken] – string  authentication token for accessing server;
  /// Fetches and returns the details of the voyage from the database
  Future<Result<VoyageDetails, Failure<String>>> fetch() async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        WITH
          icing_type_options AS (
            SELECT
              ship_id,
              json_agg(json_build_object(
                'id', "option_id",
                'value', "option_name",
                'isActive', "is_option_active"
              )) AS "options"
            FROM (
              SELECT
                s.id AS "ship_id",
                si.id AS "option_id",
                si.icing_type AS "option_name",
                CASE
                  WHEN s.icing_type_id = si.id THEN TRUE
                ELSE FALSE
                END AS "is_option_active"
              FROM ship_icing AS si
              JOIN ship AS s ON s.id = $shipId
            )
            GROUP BY ship_id
          ),
          water_area_options AS (
            SELECT
              ship_id,
              json_agg(json_build_object(
                'id', "option_id",
                'value', "option_name",
                'isActive', "is_option_active"
              )) AS "options"
            FROM (
              SELECT
                s.id AS "ship_id",
                wa.id AS "option_id",
                wa.name AS "option_name",
                CASE
                  WHEN s.water_area_id = wa.id THEN TRUE
                ELSE FALSE
                END AS "is_option_active"
              FROM ship_water_area AS wa
              JOIN ship AS s ON s.id = $shipId
            )
            GROUP BY ship_id
          ),
          load_line_options AS (
            SELECT
              ship_id,
              json_agg(json_build_object(
                'id', "option_id",
                'value', "option_name",
                'isActive', "is_option_active"
              )) AS "options"
            FROM (
              SELECT
                sllt.ship_id AS "ship_id",
                llt.id AS "option_id",
                llt.name AS "option_name",
                sllt.is_active AS "is_option_active"
              FROM ship_available_load_line_types AS sllt
              JOIN load_line_type AS llt ON sllt.load_line_type_id = llt.id
              WHERE
                sllt.ship_id = $shipId AND
                sllt.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
              ORDER BY llt.id
            )
            GROUP BY ship_id
          )
        SELECT
          s.name::TEXT AS "shipName",
          v.code AS "voyageCode",
          v.description AS "voyageDescription",
          wd.value::TEXT AS "intakeWaterDensity",
          wdt.value::TEXT AS "wettingDeck",
          ito.options AS "icingTypes",
          wao.options AS "waterAreaTypes",
          llo.options AS "loadLineTypes"
        FROM ship AS s
        JOIN ship_parameters AS wd ON
          s.id = wd.ship_id AND
          wd.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'} AND
          wd.key = 'Water Density'
        JOIN ship_parameters as wdt ON
          s.id = wdt.ship_id AND
          wdt.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'} AND
          wdt.key = 'Wetting of deck timber'
        JOIN voyage AS v ON
          s.id = v.ship_id AND
          v.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
        JOIN icing_type_options AS ito ON
          s.id = ito.ship_id
        JOIN water_area_options AS wao ON
          s.id = wao.ship_id
        JOIN load_line_options AS llo ON
          s.id = llo.ship_id
        WHERE
          s.id = $shipId
        ;
      '''),
      entryBuilder: (row) => JsonVoyageDetails.fromRow(row),
    );
    _log.info('voyage details, fetching');
    return sqlAccess.fetch().convertFailure().then((result) {
      switch (result) {
        case Ok(value: final details):
          if (details.isEmpty) {
            _log.error('voyage details not found');
            return Err(Failure(
              message: 'not found',
              stackTrace: StackTrace.current,
            ));
          }
          _log.info('voyage details fetched');
          return Ok(details.first);
        case Err(:final error):
          _log.error(error);
          return Err(Failure(
            message: 'fetch error',
            stackTrace: StackTrace.current,
          ));
      }
    });
  }
  ///
  /// Updates intake water density with new [value] for stored [VoyageDetails].
  Future<Result<void, Failure<String>>> updateIntakeWaterDensity(
    String value,
  ) async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        UPDATE
          ship_parameters
        SET
          value = '$value'
        WHERE
          ship_id = $shipId AND
          project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'} AND
          key = 'Water Density'
        RETURNING value::TEXT;
      '''),
    );
    return sqlAccess.fetch().convertFailure();
  }
  ///
  /// Updates wetting deck with new [value] for stored [VoyageDetails].
  Future<Result<void, Failure<String>>> updateWettingDeck(
    String value,
  ) async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        UPDATE
          ship_parameters
        SET
          value = '$value'
        WHERE
          ship_id = $shipId AND
          project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'} AND
          key = 'Wetting of deck timber'
        RETURNING value::TEXT;
      '''),
    );
    return sqlAccess.fetch().convertFailure();
  }
  ///
  /// Updates voyage code with new [value] for stored [VoyageDetails].
  Future<Result<void, Failure<String>>> updateVoyageCode(
    String value,
  ) async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        UPDATE
          voyage
        SET
          code = '$value'
        WHERE
          ship_id = $shipId AND
          project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
        RETURNING code;
      '''),
    );
    return sqlAccess.fetch().convertFailure();
  }
  ///
  /// Updates voyage description with new [value] for stored [VoyageDetails].
  Future<Result<void, Failure<String>>> updateVoyageDescription(
    String value,
  ) async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        UPDATE
          voyage
        SET
          description = '$value'
        WHERE
          ship_id = $shipId AND
          project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
        RETURNING description;
      '''),
    );
    return sqlAccess.fetch().convertFailure();
  }
  ///
  /// Updates icing type with new [value] for stored [VoyageDetails].
  Future<Result<void, Failure<String>>> updateIcingType(
    FieldOption<String> value,
  ) async {
    final shipId = const Setting('shipId').toInt;
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        UPDATE
          ship
        SET
          icing_type_id = ${value.id}
        WHERE
          id = $shipId
        RETURNING icing_type_id;
      '''),
    );
    return sqlAccess.fetch().convertFailure();
  }
  ///
  /// Update water area type with new [value] for stored [VoyageDetails].
  Future<Result<void, Failure<String>>> updateWaterAreaType(
    FieldOption<String> value,
  ) async {
    final shipId = const Setting('shipId').toInt;
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        UPDATE
          ship
        SET
          water_area_id = ${value.id}
        WHERE
          id = $shipId
        RETURNING water_area_id;
      '''),
    );
    return sqlAccess.fetch().convertFailure();
  }
  ///
  /// Update draft mark type with new [value] for stored [VoyageDetails].
  Future<Result<void, Failure<String>>> updateDraftMarkType(
    FieldOption<String> value,
  ) async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        DO \$\$ BEGIN
          UPDATE
            ship_available_load_line_types
          SET
            is_active = FALSE
          WHERE
            ship_id = $shipId AND
            project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'};
          UPDATE
            ship_available_load_line_types
          SET
            is_active = TRUE
          WHERE
            load_line_type_id = ${value.id} AND
            ship_id = $shipId AND
            project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'};
        END \$\$;
      '''),
    );
    return sqlAccess.fetch().convertFailure();
  }
}
