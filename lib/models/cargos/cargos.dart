import 'dart:async';
import 'dart:convert';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/models/cargo/cargo.dart';

///
abstract interface class Cargos {
  ///
  Future<ResultF<List<Cargo>>> fetchAll();

  ///
  Future<ResultF<void>> remove(Cargo cargo);

  ///
  Future<ResultF<void>> add(Cargo cargo, {Cargo? next});
}

///
class DbCargos implements Cargos {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;

  ///
  const DbCargos({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;

  @override
  Future<ResultF<List<Cargo>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              cargo_id,
              ROW_NUMBER() OVER (ORDER BY 1) AS cargo_idx,
              json_object_agg(
                key,
                json_build_object('value', value, 'type', type, 'id', id)
              )::text as parameters
            FROM cargo_parameters
            GROUP BY cargo_id
            ORDER BY cargo_idx ASC;
            """,
      ),
      entryBuilder: (row) => row,
    );
    // await Future.delayed(
    //   const Duration(seconds: 3),
    // ); // TODO: remove after debugging
    return switch (await sqlAccess.fetch()) {
      Ok(value: final rows) => _mapReplyToValue(rows),
      Err(:final error) => Err(error),
    };
  }

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
        )
          ..['id'] = row['cargo_id']
          ..['idx'] = row['cargo_idx'];
        return JsonCargo(json: json);
      }).toList());
    } catch (err) {
      return Err(Failure(message: err, stackTrace: StackTrace.current));
    }
  }

  @override
  Future<ResultF<void>> remove(Cargo cargo) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            DELETE FROM cargo_parameters
            WHERE cargo_id=${cargo.id};
            """,
      ),
    );
    return switch (await sqlAccess.fetch()) {
      Ok() => const Ok(null),
      Err(:final error) => Err(error),
    };
  }

  // TODO: implements add before [next]
  @override
  Future<ResultF<void>> add(Cargo cargo, {Cargo? next}) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            WITH next_id AS
              (SELECT max(cargo_id)+1 AS value FROM cargo_parameters)
            INSERT INTO cargo_parameters
              (ship_id, cargo_id, key, value, type)
            VALUES
              (1, (SELECT value FROM next_id), 'name', '${cargo.asMap()['name']}', 'string'),
              (1, (SELECT value FROM next_id), 'weight', '${cargo.asMap()['weight']}', 'real'),
              (1, (SELECT value FROM next_id), 'vcg', '${cargo.asMap()['vcg']}', 'real'),
              (1, (SELECT value FROM next_id), 'tcg', '${cargo.asMap()['tcg']}', 'real'),
              (1, (SELECT value FROM next_id), 'lcg', '${cargo.asMap()['lcg']}', 'real'),
              (1, (SELECT value FROM next_id), 'x_1', '${cargo.asMap()['x_1']}', 'real'),
              (1, (SELECT value FROM next_id), 'x_2', '${cargo.asMap()['x_2']}', 'real');
            """,
      ),
    );
    return switch (await sqlAccess.fetch()) {
      Ok() => const Ok(null),
      Err(:final error) => Err(error),
    };
  }
}
