import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
///
class CompartmentCargosSqlAccess {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  final Map<String, dynamic>? _filter;
  ///
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
  Future<ResultF<List<Cargo>>> fetch() {
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
        sql: """
            SELECT
              c.project_id AS "projectId",
              c.ship_id AS "shipId",
              c.id AS "id",
              c.name AS "name",
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
              c.m_f_s_x AS "mfsx",
              c.m_f_s_y AS "mfsy",
              c.svg_paths AS "path",
              cc.key::TEXT AS "type",
              CASE
                  WHEN cc.matter_type = 'bulk' THEN TRUE
                  ELSE FALSE
              END AS "shiftable"
            FROM
              compartment AS c
              JOIN cargo_category AS cc ON c.category_id = cc.id
              JOIN cargo_general_category AS cgc ON cc.general_category_id = cgc.id
            WHERE
              ship_id = 1
              ${filterQuery == null ? '' : 'AND ($filterQuery)'}
            ORDER BY
              name;
            """,
      ),
      entryBuilder: (row) => JsonCargo(json: {
        'shipId': row['shipId'] as int,
        'projectId': row['projectId'] as int?,
        'id': row['id'] as int?,
        'name': row['name'] as String?,
        'weight': row['mass'] as double?,
        'volume': row['volume'] as double?,
        'density': row['density'] as double?,
        'level': row['level'] as double?,
        'x1': row['x1'] as double?,
        'x2': row['x2'] as double?,
        'y1': row['y1'] as double?,
        'y2': row['y2'] as double?,
        'z1': row['z1'] as double?,
        'z2': row['z2'] as double?,
        'vcg': row['vcg'] as double?,
        'lcg': row['lcg'] as double?,
        'tcg': row['tcg'] as double?,
        'mfsx': row['mfsx'] as double?,
        'mfsy': row['mfsy'] as double?,
        'type': row['type'] as String,
        'shiftable': row['shiftable'] as bool,
        'path': row['path'] as String?,
      }),
    ).fetch();
  }
}
