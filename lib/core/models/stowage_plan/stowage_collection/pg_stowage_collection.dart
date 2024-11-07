import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/future_result_extension.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/standard_slot.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_collection.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_collection/stowage_map.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/put_container_operation.dart';
import 'package:sss_computing_client/core/models/stowage_plan/stowage_operation/remove_container_operation.dart';
///
/// [StowageCollection] stored in Postgres DB.
class PgStowageCollection {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  final StowageCollection _stowageCollection;
  ///
  /// Creates [StowageCollection] stored in Postgres DB.
  ///
  /// * [dbName] - name of Postgres DB.
  /// * [apiAddress] - address of api-server.
  /// * [authToken] - authentication token for api-server.
  PgStowageCollection({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken,
        _stowageCollection = StowageMap.empty();
  ///
  /// Free up resources associated with this [PgStowageCollection] instance.
  void dispose() {
    _stowageCollection.removeAllSlots();
  }
  ///
  /// Fetches and returns [StowageCollection].
  Future<ResultF<StowageCollection>> fetch() {
    final sqlAccess = SqlAccess(
      database: _dbName,
      address: _apiAddress,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        SELECT
          cs.container_id AS "containerId",
          cs.bay_number AS "bay",
          cs.row_number AS "row",
          cs.tier_number AS "tier",
          cs.bound_x1 AS "leftX",
          cs.bound_x2 AS "rightX",
          cs.bound_y1 AS "leftY",
          cs.bound_y2 AS "rightY",
          cs.bound_z1 AS "leftZ",
          cs.bound_z2 AS "rightZ",
          cs.min_vertical_separation AS "minVerticalSeparation",
          cs.min_height AS "minHeight",
          cs.max_height AS "maxHeight",
          cs.is_active AS "isActive"
        FROM container_slot AS cs
        ORDER BY id;
        '''),
      entryBuilder: (row) => StandardSlot.fromRow(row),
    );
    return sqlAccess.fetch().then(
          (result) => result.map(
            (slots) {
              _stowageCollection.removeAllSlots();
              _stowageCollection.addAllSlots(slots);
              return _stowageCollection;
            },
          ),
        );
  }
  ///
  /// Puts [container] to slot at specified position in [StowageCollection].
  ///
  /// Position is specified by [bay], [row], and [tier] numbers.
  Future<ResultF<void>> putContainer({
    required FreightContainer container,
    required int bay,
    required int row,
    required int tier,
  }) async {
    final backup = _stowageCollection.copy();
    final putResult = PutContainerOperation(
      container: container,
      bay: bay,
      row: row,
      tier: tier,
    ).execute(_stowageCollection);
    final alreadyOccupiedSlot = backup
        .toFilteredSlotList(
          shouldIncludeSlot: (s) => s.containerId == container.id,
        )
        .firstOrNull;
    final delResult = switch (alreadyOccupiedSlot) {
      null => const Ok<void, Failure>(null),
      Slot(:final bay, :final row, :final tier) => RemoveContainerOperation(
          bay: bay,
          row: row,
          tier: tier,
        ).execute(_stowageCollection),
    };
    final saveResult = switch (putResult.and(delResult)) {
      Ok() => await _save(),
      Err(:final error) => Err(error),
    };
    return saveResult.inspectErr(
      (_) => _restoreFrom(backup),
    );
  }
  ///
  /// Removes container from specified slot in [StowageCollection].
  ///
  /// Position is specified by [bay], [row], and [tier] numbers.
  Future<ResultF<void>> removeContainer({
    required int bay,
    required int row,
    required int tier,
  }) async {
    final backup = _stowageCollection.copy();
    final removeResult = RemoveContainerOperation(
      bay: bay,
      row: row,
      tier: tier,
    ).execute(_stowageCollection);
    final saveResult = switch (removeResult) {
      Ok() => await _save(),
      Err(:final error) => Err(error),
    };
    return saveResult.inspectErr(
      (_) => _restoreFrom(backup),
    );
  }
  ///
  /// Saves current [StowageCollection] state to Postgres DB.
  Future<ResultF<void>> _save() {
    final sql = """
      DO \$\$ BEGIN
      DELETE FROM container_slot;
      INSERT INTO
        container_slot (
          container_id,
          bay_number,
          row_number,
          tier_number,
          bound_x1,
          bound_x2,
          bound_y1,
          bound_y2,
          bound_z1,
          bound_z2,
          min_vertical_separation,
          min_height,
          max_height,
          is_active
        )
      VALUES
        ${_stowageCollection.toFilteredSlotList().map((slot) => '(${[
              '${slot.containerId ?? 'NULL'}',
              '${slot.bay}',
              '${slot.row}',
              '${slot.tier}',
              slot.leftX.toStringAsFixed(5),
              slot.rightX.toStringAsFixed(5),
              slot.leftY.toStringAsFixed(5),
              slot.rightY.toStringAsFixed(5),
              slot.leftZ.toStringAsFixed(5),
              slot.rightZ.toStringAsFixed(5),
              slot.minVerticalSeparation.toStringAsFixed(5),
              slot.minHeight.toStringAsFixed(5),
              slot.maxHeight.toStringAsFixed(5),
              slot.isActive ? 'TRUE' : 'FALSE',
            ].join(', ')})').join(',')};
      END \$\$;
    """;
    return SqlAccess(
      database: _dbName,
      address: _apiAddress,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: sql),
    ).fetch().convertFailure();
  }
  ///
  /// Restores current [StowageCollection] state from [other] state.
  void _restoreFrom(StowageCollection other) {
    _stowageCollection.removeAllSlots();
    _stowageCollection.addAllSlots(
      other.toFilteredSlotList().map((s) => s.copy()).toList(),
    );
  }
}