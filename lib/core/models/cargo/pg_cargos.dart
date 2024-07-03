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
            SELECT
              project_id AS "projectId",
              ship_id AS "shipId",
              space_id AS "id",
              name AS "name",
              mass AS "mass",
              bound_x1 AS "bound_x1",
              bound_x2 AS "bound_x2",
              bound_y1 AS "bound_y1",
              bound_y2 AS "bound_y2",
              bound_z1 AS "bound_z1",
              bound_z2 AS "bound_z2",
              mass_shift_x AS "lcg",
              mass_shift_y AS "tcg",
              mass_shift_z AS "vcg",
              m_f_s_x AS "mfsx",
              m_f_s_y AS "mfsy",
              svg_paths AS "path",
              cargo_type::TEXT AS "type"
            FROM compartment
            WHERE ship_id = 1
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
