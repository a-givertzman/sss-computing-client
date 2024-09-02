import 'package:hmi_core/hmi_core.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
/// TODO: rewrite doc
///
/// Gives access to field of record stored in database.
final class CargoLevelRecord implements ValueRecord<double?> {
  final ApiAddress _apiAddress;
  final String? _authToken;
  final String _dbName;
  final String _tableName;
  final double? Function(String) _toValue;
  final Map<String, dynamic> _filter;
  ///
  /// Create [CargoLevelRecord] that giving access
  /// to field of record stored in database.
  ///
  /// Value can be obtained using:
  ///   - `dbName` - name of the database;
  ///   - `apiAddress` - [ApiAddress] of server that interact with database;
  ///   - `authToken` - string  authentication token for accessing server;
  ///   - `toValue` - function for parsing string representation of
  /// field into value of desired type.
  const CargoLevelRecord({
    required ApiAddress apiAddress,
    required String dbName,
    required String tableName,
    String? authToken,
    required double? Function(String value) toValue,
    required Map<String, dynamic> filter,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _tableName = tableName,
        _authToken = authToken,
        _toValue = toValue,
        _filter = filter;
  ///
  /// Returns result of field fetching.
  ///
  /// `filter` - Map with field name as key and field value as value
  /// for filtering records of table based on its fields values.
  @override
  Future<ResultF<double?>> fetch() async {
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
          SELECT (volume / volume_max) * 100.0 AS level FROM $_tableName
          WHERE $filterQuery
          LIMIT 1;
        """,
      ),
      entryBuilder: (row) => '${row['level']}',
    );
    return sqlAccess
        .fetch()
        .then<ResultF<double?>>(
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
  ///
  /// `filter` - Map with field name as key and field value as value
  /// for filtering records of table based on its fields values.
  @override
  Future<ResultF<double?>> persist(String value) async {
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
          UPDATE $_tableName
          SET volume=volume_max * ($value / 100.0)
          WHERE $filterQuery
          RETURNING (volume / volume_max) * 100.0 AS level;
        """,
      ),
      entryBuilder: (row) => '${row['level']}',
    );
    return sqlAccess
        .fetch()
        .then<ResultF<double?>>(
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
