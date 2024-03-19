import 'dart:async';
import 'dart:convert';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/models/cargo/cargo.dart';

abstract interface class Cargos {
  Future<ResultF<List<Cargo>>> fetchAll();
}

class DbCargos implements Cargos {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
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
              json_object_agg(
                key,
                json_build_object('value', value, 'type', type, 'id', id)
              )::text as parameters
            FROM cargo_parameters
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
}
