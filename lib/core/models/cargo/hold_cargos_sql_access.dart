import 'dart:convert';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/future_result_extension.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
import 'package:sss_computing_client/core/models/figure/json_svg_path_projections.dart';
///
/// Object that provides [SqlAccess] to hold compartment cargos.
class HoldCargosSqlAccess {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  final Map<String, dynamic>? _filter;
  ///
  /// Creates object that provides [SqlAccess] to hold compartment cargos.
  ///
  ///   - [dbName] – name of the database;
  ///   - [apiAddress] – [ApiAddress] of server that interact with database;
  ///   - [authToken] – string  authentication token for accessing server;
  ///   - [filter] – Map with field name as key and field value as value
  /// for filtering records of table based on its fields values.
  const HoldCargosSqlAccess({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
    Map<String, dynamic>? filter,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken,
        _filter = filter;
  ///
  /// Retrieves and returns list of hold compartment [Cargo].
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
        sql: """
            WITH hold_svg_paths AS (
                SELECT
                    hc.id AS hold_compartment_id,
                    hc.ship_id AS ship_id,
                    hc.project_id AS project_id,
                    json_agg(hp.svg_paths) AS svg_paths
                FROM hold_compartment AS hc
                JOIN hold_part AS hp ON
                    hp.group_index >= hc.group_start_index
                    AND hp.group_index <= hc.group_end_index
                    AND hc.group_id = hp.group_id
                    AND hc.ship_id = hp.ship_id
                    AND hc.project_id IS NOT DISTINCT FROM hp.project_id
                GROUP BY
                    hc.id
            ) SELECT
                hc.id AS "id",
                hc.ship_id AS "shipId",
                hc.project_id AS "projectId",
                hc.name_rus AS "name",
                hc.mass AS "mass",
                hc.density AS "density",
                hc.stowage_factor AS "stowageFactor",
                hc.volume AS "volume",
                (hc.volume / hc.volume_max) * 100.0 AS "level",
                hc.bound_x1 AS "x1",
                hc.bound_x2 AS "x2",
                hc.mass_shift_x AS "lcg",
                hc.mass_shift_y AS "tcg",
                hc.mass_shift_z AS "vcg",
                cc.key AS "type",
                hsp.svg_paths::TEXT AS "pathList",
                CASE
                    WHEN cc.matter_type = 'bulk' THEN TRUE
                    ELSE FALSE
                END AS "shiftable"
            FROM hold_compartment AS hc
            JOIN hold_svg_paths AS hsp ON
                hc.id = hsp.hold_compartment_id
                AND hc.ship_id = hsp.ship_id
                AND hc.project_id IS NOT DISTINCT FROM hsp.project_id
            JOIN cargo_category AS cc ON
                hc.category_id = cc.id
            JOIN cargo_general_category AS cgc ON
                cc.general_category_id = cgc.id
            WHERE
                hc.ship_id = $shipId AND
                hc.project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
                ${filterQuery == null ? '' : 'AND ($filterQuery)'}
            ORDER BY
                hc.id ASC;
            """,
      ),
      entryBuilder: (row) => JsonCargo.fromRow(row
        ..['path'] = switch (row['pathList']) {
          String pathList => _formatPathList(pathList),
          _ => null,
        }),
    ).fetch().convertFailure();
  }
  //
  String _formatPathList(String pathList) => json
      .decode(pathList)
      .map(
        (path) => JsonSvgPathProjections(json: json.decode(path)),
      )
      .reduce((prev, value) => JsonSvgPathProjections(json: {
            'xy': '${prev.toJson()['xy']} ${value.toJson()['xy']}',
            'yz': '${prev.toJson()['yz']} ${value.toJson()['yz']}',
            'xz': '${prev.toJson()['xz']} ${value.toJson()['xz']}',
          }))
      .toString();
}
