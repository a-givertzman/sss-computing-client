import 'package:hmi_core/hmi_core.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/models/persistable/persistable.dart';

class ValueRecord implements Persistable<String> {
  final String _key;
  final String _tableName;
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  final String Function(String text)? _onFetch;

  const ValueRecord({
    required String key,
    required String tableName,
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
    String Function(String text)? onFetch,
  })  : _key = key,
        _tableName = tableName,
        _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken,
        _onFetch = onFetch;

  @override
  Future<ResultF<void>> persist(String value) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: 'UPDATE "$_tableName" SET value=\'$value\' WHERE key=\'$_key\';',
      ),
      entryBuilder: (row) => row,
    );
    return switch (await sqlAccess.fetch()) {
      Ok() => const Ok(null),
      Err(:final error) => Err(error),
    };
  }

  @override
  Future<ResultF<String>> fetch() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: 'SELECT value FROM "$_tableName" WHERE key=\'$_key\' LIMIT 1;',
      ),
      entryBuilder: (row) => row,
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final rows) => _mapReplyToValue(rows),
      Err(:final error) => Err(error),
    };
  }

  ResultF<String> _mapReplyToValue(List<Map<String, dynamic>> rows) {
    try {
      final reply = rows.first['value'].toString();
      final value = _onFetch?.call(reply) ?? reply;
      return Ok(value);
    } catch (err) {
      return Err(Failure(message: err, stackTrace: StackTrace.current));
    }
  }
}
