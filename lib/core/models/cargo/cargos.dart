import 'dart:async';
import 'dart:convert';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';

/// Interface for controlling collection of [Cargo].
abstract interface class Cargos {
  /// Get all [Cargo] in [Cargos] collection.
  Future<ResultF<List<Cargo>>> fetchAll();

  /// Remove [Cargo] from [Cargos] collection.
  Future<ResultF<void>> remove(Cargo cargo);

  /// Add new [Cargo] in [Cargos] collection.
  Future<ResultF<int>> add(Cargo cargo);
}

/// [Cargos] collection stored in DB.
class DbCargos implements Cargos {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;

  /// Creates [Cargos] collection stored in DB.
  const DbCargos({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;

  ///
  @override
  Future<ResultF<List<Cargo>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              space_id AS cargo_id,
              json_object_agg(
                key,
                json_build_object('value', value, 'type', value_type, 'id', id)
              )::text as parameters
            FROM load_space
            GROUP BY cargo_id
            ORDER BY cargo_id ASC;
            """,
      ),
      entryBuilder: (row) => row,
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final rows) => _mapReplyToValue(rows),
      Err(:final error) => Err(error),
    };
  }

  ///
  ResultF<List<Cargo>> _mapReplyToValue(List<Map<String, dynamic>> rows) {
    try {
      return Ok(rows.map((row) {
        final Map<String, dynamic> rawJson = jsonDecode(row['parameters']);
        final Map<String, dynamic> json = rawJson.map(
          (key, value) => MapEntry(
            key,
            switch (value['type']) {
              'real' => double.parse(value['value']),
              'int' => int.parse(value['value']),
              _ => value['value'],
            },
          ),
        )..['id'] = row['cargo_id'];
        return JsonCargo(json: json);
      }).toList());
    } catch (err) {
      return Err(Failure(message: err, stackTrace: StackTrace.current));
    }
  }

  ///
  @override
  Future<ResultF<void>> remove(Cargo cargo) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            DELETE FROM load_space
            WHERE space_id=${cargo.id};
            """,
      ),
    );
    return switch (await sqlAccess.fetch()) {
      Ok() => const Ok(null),
      Err(:final error) => Err(error),
    };
  }

  ///
  @override
  Future<ResultF<int>> add(Cargo cargo) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      entryBuilder: (row) => row,
      sqlBuilder: (_, __) => Sql(
        sql: """
            WITH next_id AS
              (SELECT max(space_id)+1 AS value FROM load_space)
            INSERT INTO load_space
              (ship_id, space_id, key, value, value_type)
            VALUES
              (1, (SELECT value FROM next_id), 'name', '${cargo.asMap()['name']}', 'text'),
              (1, (SELECT value FROM next_id), 'mass', '${cargo.asMap()['mass']}', 'real'),
              (1, (SELECT value FROM next_id), 'center_x', '${cargo.asMap()['center_x']}', 'real'),
              (1, (SELECT value FROM next_id), 'center_z', '${cargo.asMap()['center_z']}', 'real'),
              (1, (SELECT value FROM next_id), 'center_y', '${cargo.asMap()['center_y']}', 'real'),
              (1, (SELECT value FROM next_id), 'bound_x1', '${cargo.asMap()['bound_x1']}', 'real'),
              (1, (SELECT value FROM next_id), 'bound_x2', '${cargo.asMap()['bound_x2']}', 'real')
            RETURNING (SELECT value FROM next_id) AS cargo_id;
            """,
      ),
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final rows) => Ok(rows.first['cargo_id']),
      Err(:final error) => Err(error),
    };
  }
}
