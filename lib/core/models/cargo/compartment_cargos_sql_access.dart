import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
///
/// Object that provides [SqlAccess] to compartment cargos.
class CompartmentCargosSqlAccess {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  final Map<String, dynamic>? _filter;
  ///
  /// Creates object that provides [SqlAccess] to compartment cargos.
  ///
  ///   - [dbName] – name of the database;
  ///   - [apiAddress] – [ApiAddress] of server that interact with database;
  ///   - [authToken] – string  authentication token for accessing server;
  ///   - [filter] – Map with field name as key and field value as value
  /// for filtering records of table based on its fields values.
  const CompartmentCargosSqlAccess({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
    Map<String, dynamic>? filter,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken,
        _filter = filter;
  ///
  /// Retrieves and returns list of compartment [Cargo].
  Future<ResultF<List<Cargo>>> fetch() {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final filterQuery = _filter?.entries
        .map(
          (entry) => switch (entry.value) {
            num _ => '${entry.key} = ${entry.value}',
            _ => "${entry.key} = '${entry.value}'"
          },
        )
        .join(' AND ');
    return SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        // TODO: remove COALESCE
        sql: """
            SELECT
              c.project_id AS "projectId",
              c.ship_id AS "shipId",
              c.id AS "id",
              COALESCE(c.name_engl, c.name_rus) AS "name",
              c.mass AS "mass",
              c.volume AS "volume",
              c.density AS "density",
              (c.volume / c.volume_max) * 100.0 AS "level",
              c.bound_x1 AS "x1",
              c.bound_x2 AS "x2",
              c.bound_y1 AS "y1",
              c.bound_y2 AS "y2",
              c.bound_z1 AS "z1",
              c.bound_z2 AS "z2",
              c.mass_shift_x AS "lcg",
              c.mass_shift_y AS "tcg",
              c.mass_shift_z AS "vcg",
              CASE
                  WHEN c.use_max_m_f_s = TRUE THEN c.max_m_f_s_x
                  ELSE c.m_f_s_x
              END AS "mfsx",
              CASE
                  WHEN c.use_max_m_f_s = TRUE THEN c.max_m_f_s_y
                  ELSE c.m_f_s_y
              END AS "mfsy",
              c.svg_paths AS "path",
              cc.key::TEXT AS "type",
              c.use_max_m_f_s AS "useMaxMfs",
              CASE
                  WHEN cc.matter_type = 'bulk' THEN TRUE
                  ELSE FALSE
              END AS "shiftable"
            FROM
              compartment AS c
              JOIN cargo_category AS cc ON c.category_id = cc.id
              JOIN cargo_general_category AS cgc ON cc.general_category_id = cgc.id
            WHERE
              c.ship_id = $shipId AND
              c.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
              ${filterQuery == null ? '' : 'AND ($filterQuery)'}
            ORDER BY
              name;
            """,
      ),
      entryBuilder: (row) => JsonCargo.fromRow(row),
    )
        .fetch()
        .then<Result<List<Cargo>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final cargos) => Ok(cargos),
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
