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
  // ignore: long-method
  Future<Result<List<Cargo>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              c.project_id AS "projectId",
              c.ship_id AS "shipId",
              c.space_id AS "id",
              c.name AS "name",
              c.mass AS "mass",
              c.volume AS "volume",
              c.density AS "density",
              (c.volume / c.volume_max)*100.0 AS "level",
              c.bound_x1 AS "bound_x1",
              c.bound_x2 AS "bound_x2",
              c.bound_y1 AS "bound_y1",
              c.bound_y2 AS "bound_y2",
              c.bound_z1 AS "bound_z1",
              c.bound_z2 AS "bound_z2",
              c.mass_shift_x AS "lcg",
              c.mass_shift_y AS "tcg",
              c.mass_shift_z AS "vcg",
              c.m_f_s_x AS "mfsx",
              c.m_f_s_y AS "mfsy",
              c.svg_paths AS "path",
              cc.key::TEXT AS "type"
            FROM
              compartment AS c
              JOIN cargo_category AS cc ON c.category_id = cc.id
              JOIN cargo_general_category AS cgc ON cc.general_category_id = cgc.id
            WHERE
              ship_id = 1
            ORDER BY
              name;
            """,
      ),
      entryBuilder: (row) => JsonCargo(json: {
        'shipId': row['shipId'] as int,
        'projectId': row['projectId'] as int?,
        'id': row['id'] as int?,
        'name': row['name'] as String?,
        'mass': row['mass'] as double?,
        'volume': row['volume'] as double?,
        'density': row['density'] as double?,
        'level': row['level'] as double?,
        'bound_x1': row['bound_x1'] as double?,
        'bound_x2': row['bound_x2'] as double?,
        'bound_y1': row['bound_y1'] as double?,
        'bound_y2': row['bound_y2'] as double?,
        'bound_z1': row['bound_z1'] as double?,
        'bound_z2': row['bound_z2'] as double?,
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
