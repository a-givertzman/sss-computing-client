import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargos.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
///
/// [Cargos] collection stored in postgres DB.
class PgCargos implements Cargos {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates [Cargos] collection stored in DB.
  const PgCargos({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<Cargo>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            (SELECT
              c.project_id AS "projectId",
              c.ship_id AS "shipId",
              c.space_id AS "id",
              c.name AS "name",
              c.mass AS "mass",
              c.bound_x1 - sp.value::REAL AS "bound_x1",
              c.bound_x2 - sp.value::REAL AS "bound_x2",
              c.mass_shift_x - sp.value::REAL AS "lcg",
              c.mass_shift_y AS "tcg",
              c.mass_shift_z AS "vcg",
              c.m_f_s_x AS "mfsx",
              c.m_f_s_y AS "mfsy",
              c.svg_paths AS "path",
              c.cargo_type::TEXT AS "type"
            FROM compartment AS c
            INNER JOIN ship_parameters AS sp
            ON c.ship_id = sp.ship_id AND sp.key = 'X midship from Fr0'
            WHERE c.ship_id = 1 AND c.bound_type = 'm')
            UNION
            (SELECT
              c.project_id AS "projectId",
              c.ship_id AS "shipId",
              c.space_id AS "id",
              c.name AS "name",
              c.mass AS "mass",
              pf1.pos_x - sp.value::REAL AS "bound_x1",
              pf2.pos_x - sp.value::REAL AS "bound_x2",
              c.mass_shift_x - sp.value::REAL AS "lcg",
              c.mass_shift_y AS "tcg",
              c.mass_shift_z AS "vcg",
              c.m_f_s_x AS "mfsx",
              c.m_f_s_y AS "mfsy",
              c.svg_paths AS "path",
              c.cargo_type::TEXT AS "type"
            FROM compartment AS c
            INNER JOIN physical_frame AS pf1
            ON c.bound_x1 = pf1.frame_index AND c.ship_id = pf1.ship_id
            INNER JOIN physical_frame AS pf2
            ON c.bound_x2 = pf2.frame_index AND c.ship_id = pf2.ship_id
            INNER JOIN ship_parameters AS sp
            ON c.ship_id = sp.ship_id AND sp.key = 'X midship from Fr0'
            WHERE c.ship_id = 1 AND c.bound_type = 'frame')
            ORDER BY name;
            """,
      ),
      entryBuilder: (row) => JsonCargo(json: {
        'shipId': row['shipId'] as int,
        'projectId': row['projectId'] as int?,
        'id': row['id'] as int?,
        'name': row['name'] as String?,
        'mass': row['mass'] as double?,
        'bound_x1': row['bound_x1'] as double?,
        'bound_x2': row['bound_x2'] as double?,
        // TODO: add y and z bounds to database
        'bound_y1': 0.0,
        'bound_y2': 0.0,
        'bound_z1': 0.0,
        'bound_z2': 0.0,
        'vcg': row['vcg'] as double?,
        'lcg': row['lcg'] as double?,
        'tcg': row['tcg'] as double?,
        'm_f_s_x': row['mfsx'] as double?,
        'm_f_s_y': row['mfsy'] as double?,
        'path': row['path'] as String?,
        'type': row['type'] as String,
      }),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<Cargo>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final cargos) => Ok(cargos),
            Err(:final error) => Err(
                Failure(
                  message: '$error',
                  stackTrace: StackTrace.current,
                ),
              ),
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
