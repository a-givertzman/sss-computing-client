import 'package:hmi_core/hmi_core.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class FieldRecord<T> {
  final String _tableName;
  final String _field;
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  final T Function(String) _parseValue;
  ///
  const FieldRecord({
    required String tableName,
    required String field,
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
    required T Function(String value) parseValue,
  })  : _field = field,
        _tableName = tableName,
        _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken,
        _parseValue = parseValue;
  ///
  Future<ResultF<T>> fetch() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: 'SELECT "$_field" FROM "$_tableName" LIMIT 1;',
      ),
      entryBuilder: (row) => '${row[_field]}',
    );
    return sqlAccess
        .fetch()
        .then<ResultF<T>>(
          (result) => switch (result) {
            Ok(:final value) => Ok(_parseValue(value.first)),
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
