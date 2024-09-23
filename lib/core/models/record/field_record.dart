import 'package:hmi_core/hmi_core.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
/// Gives access to field of record stored in database.
final class FieldRecord<T> implements ValueRecord<T> {
  final String _dbName;
  final String _tableName;
  final String _fieldName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  final T Function(String) _toValue;
  final Map<String, dynamic> _filter;
  ///
  /// Create [FieldRecord] that giving access
  /// to field of record stored in database.
  ///
  /// Value can be obtained using:
  ///   - [dbName] – name of the database;
  ///   - [tableName] – name of database table;
  ///   - [fieldName] – name of table field (column);
  ///   - [apiAddress] – [ApiAddress] of server that interact with database;
  ///   - [authToken] – string  authentication token for accessing server;
  ///   - [toValue] – function for parsing string representation of
  /// field into value of desired type.
  ///   - [filter] – Map with field name as key and field value as value
  /// for filtering records of table based on its fields values.
  const FieldRecord({
    required String dbName,
    required String tableName,
    required String fieldName,
    required ApiAddress apiAddress,
    String? authToken,
    required T Function(String value) toValue,
    required Map<String, dynamic> filter,
  })  : _fieldName = fieldName,
        _tableName = tableName,
        _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken,
        _toValue = toValue,
        _filter = filter;
  ///
  /// Returns result of field fetching.
  @override
  Future<ResultF<T>> fetch() async {
    final filterQuery = _filter.entries
        .map(
          (entry) => switch (entry.value) {
            num _ => '${entry.key} = ${entry.value}',
            _ => "${entry.key} = '${entry.value}'"
          },
        )
        .join(' AND ');
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
          SELECT "$_fieldName" FROM "$_tableName"
          WHERE $filterQuery
          LIMIT 1;
        """,
      ),
      entryBuilder: (row) => '${row[_fieldName]}',
    );
    return sqlAccess
        .fetch()
        .then<ResultF<T>>(
          (result) => switch (result) {
            Ok(:final value) => Ok(_toValue(value.first)),
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
  ///
  /// Returns result of field persisting.
  @override
  Future<ResultF<T>> persist(String value) async {
    final filterQuery = _filter.entries
        .map(
          (entry) => switch (entry.value) {
            num _ => '${entry.key} = ${entry.value}',
            _ => "${entry.key} = '${entry.value}'"
          },
        )
        .join(' AND ');
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
          UPDATE "$_tableName"
          SET "$_fieldName"='$value'
          WHERE $filterQuery
          RETURNING "$_fieldName";
        """,
      ),
      entryBuilder: (row) => '${row[_fieldName]}',
    );
    return sqlAccess
        .fetch()
        .then<ResultF<T>>(
          (result) => switch (result) {
            Ok(:final value) => Ok(_toValue(value.first)),
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
