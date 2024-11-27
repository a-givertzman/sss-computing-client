import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/future_result_extension.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargos.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
///
/// Stores general [Cargos] collection stored in postgres DB.
class PgGeneralCargos implements Cargos {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates general [Cargos] collection stored in DB.
  const PgGeneralCargos({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<Cargo>, Failure<String>>> fetchAll() async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    return SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(
        sql: """
SELECT
  c.project_id AS "projectId",
  c.ship_id AS "shipId",
  c.id AS "id",
  c.name_rus AS "name",
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
  END AS "shiftable",
  c.is_on_deck AS "isOnDeck",
  c.is_timber AS "isTimber"
FROM
  compartment AS c
  JOIN cargo_category AS cc ON c.category_id = cc.id
  JOIN cargo_general_category AS cgc ON cc.general_category_id = cgc.id
WHERE
  c.ship_id = $shipId AND
  c.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'} AND
  c.category_id = 14
ORDER BY
  name;
""",
      ),
      entryBuilder: (row) => JsonCargo.fromRow(row),
    ).fetch().convertFailure();
  }
  //
  @override
  Future<Result<Cargo, Failure<String>>> fetchById(int id) async {
    return SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(
        sql: """
SELECT
  c.project_id AS "projectId",
  c.ship_id AS "shipId",
  c.id AS "id",
  c.name_rus AS "name",
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
  END AS "shiftable",
  c.is_on_deck AS "isOnDeck",
  c.is_timber AS "isTimber"
FROM
  compartment AS c
  JOIN cargo_category AS cc ON c.category_id = cc.id
  JOIN cargo_general_category AS cgc ON cc.general_category_id = cgc.id
WHERE
  c.id = $id
ORDER BY
  name;
""",
      ),
      entryBuilder: (row) => JsonCargo.fromRow(row),
    ).fetch().convertFailure().then(
          (result) => switch (result) {
            Ok(value: final cargos) => cargos.isNotEmpty
                ? Ok(cargos.first)
                : Err(Failure(
                    message: 'not found',
                    stackTrace: StackTrace.current,
                  )),
            Err() => Err(Failure(
                message: 'fetch error',
                stackTrace: StackTrace.current,
              )),
          },
        );
  }
  ///
  /// Push new cargo to general [Cargo] collection.
  Future<Result<void, Failure<String>>> add(Cargo cargo) async {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    return SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
              INSERT INTO compartment
                (ship_id, project_id, space_id, active, category_id, name_rus, mass, mass_shift_x, mass_shift_y, mass_shift_z, bound_x1, bound_x2, bound_y1, bound_y2, bound_z1, bound_z2)
              VALUES
                ($shipId, ${projectId ?? 'NULL'}, (SELECT MAX(space_id) + 1 FROM compartment), TRUE, 14, '${cargo.name}', ${cargo.weight}, ${cargo.lcg}, ${cargo.tcg}, ${cargo.vcg}, ${cargo.x1}, ${cargo.x2}, ${cargo.y1}, ${cargo.y2}, ${cargo.z1}, ${cargo.z2});
            """,
      ),
    ).fetch().convertFailure();
  }
  ///
  /// Remove cargo from general [Cargo] collection.
  Future<Result<void, Failure<String>>> remove(Cargo cargo) async {
    return SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
              DELETE FROM compartment WHERE id = ${cargo.id};
            """,
      ),
    ).fetch().convertFailure();
  }
}
