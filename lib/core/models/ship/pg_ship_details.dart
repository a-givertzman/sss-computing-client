import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
import 'package:sss_computing_client/core/models/ship/ship_details.dart';
///
/// Ship general details collection that stored in postgres DB.
class PgShipDetails {
  static const _log = Log('PgShipDetails');
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates [ShipDetails] collection that stored in postgres DB.
  ///
  /// * [apiAddress] – [ApiAddress] of server that interact with database;
  /// * [dbName] – name of the database;
  /// * [authToken] – string  authentication token for accessing server;
  const PgShipDetails({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  ///
  /// Fetches and returns [ShipDetails].
  Future<Result<JsonShipDetails, Failure<String>>> fetch() async {
    final shipId = const Setting('shipId').toInt;
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        SELECT
          s.name::TEXT AS "shipName",
          s.call_sign::TEXT AS "callSign",
          s.imo::TEXT AS "imo",
          s.mmsi::TEXT AS "mmsi",
          s.year_of_built::TEXT AS "buildYear",
          s.place_of_built::TEXT AS "buildPlace",
          s.classification_society::TEXT AS "shipClassification",
          s.registration_number::TEXT AS "registration",
          s.port_of_registry::TEXT AS "registrationPort",
          s.flag_state::TEXT AS "flagState",
          s.ship_owner::TEXT AS "shipOwner",
          s.ship_owner_code::TEXT AS "shipOwnerCode",
          s.yard_of_build::TEXT AS "buildYard",
          s.ship_builder_hull_number::TEXT AS "shipBuilderNumber",
          str.title_eng::TEXT AS "shipType",
          na.area::TEXT AS "navigationArea",
          s.ship_master::TEXT AS "shipMaster",
          s.ship_chief_mate::TEXT AS "shipChiefMate"
        FROM ship AS s
        JOIN ship_type AS st ON s.ship_type_id = st.id
        JOIN ship_type_rmrs AS str ON st.type_rmrs = str.id
        JOIN navigation_area AS na ON s.navigation_area_id = na.id
        WHERE s.id = $shipId;
      '''),
      entryBuilder: (row) => JsonShipDetails.fromRow(row),
    );
    _log.info('ship details, fetching');
    return sqlAccess.fetch().convertFailure().then((result) {
      switch (result) {
        case Ok(value: final detailsList):
          if (detailsList.isEmpty) {
            _log.error('ship details not found');
            return Err(Failure(
              message: 'not found',
              stackTrace: StackTrace.current,
            ));
          }
          _log.info('ship details fetched');
          return Ok(detailsList.first);
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
  /// Updates ship details entry by its [key] and [value].
  Future<Result<String, Failure<String>>> updateByKey({
    required String key,
    required String value,
  }) async {
    final shipId = const Setting('shipId').toInt;
    final valueFormatted =
        value.trim().isEmpty ? '—' : value.trim().replaceAll("'", "''");
    final sql = switch (key) {
      'shipMaster' => Sql(sql: '''
        UPDATE ship
        SET ship_master = '$valueFormatted'
        WHERE id = $shipId
        RETURNING ship_master::TEXT AS "updatedValue";
      '''),
      'shipChiefMate' => Sql(sql: '''
        UPDATE ship
        SET ship_chief_mate = '$valueFormatted'
        WHERE id = $shipId
        RETURNING ship_chief_mate::TEXT AS "updatedValue";
      '''),
      _ => null,
    };
    if (sql == null) {
      _log.error('unknown field to update: $key');
      return Err(Failure(
        message: 'unknown field to update',
        stackTrace: StackTrace.current,
      ));
    }
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => sql,
      entryBuilder: (row) => row['updatedValue'] as String,
    );
    _log.info('ship details, updating');
    return sqlAccess.fetch().convertFailure().then((result) {
      switch (result) {
        case Ok(value: final values):
          if (values.isEmpty) {
            _log.error('ship details to update not found');
            return Err(Failure(
              message: 'not found',
              stackTrace: StackTrace.current,
            ));
          }
          _log.info('ship details updated');
          return Ok(values.first);
        case Err(:final error):
          _log.error(error);
          return Err(Failure(
            message: 'fetch error',
            stackTrace: StackTrace.current,
          ));
      }
    });
  }
}
