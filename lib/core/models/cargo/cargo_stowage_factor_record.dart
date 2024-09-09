import 'package:hmi_core/hmi_core.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
/// Gives access to field of cargo stowage factor record stored in database.
final class CargoStowageFactorRecord implements ValueRecord<double?> {
  final ApiAddress _apiAddress;
  final String? _authToken;
  final String _dbName;
  final String _tableName;
  final int? _id;
  final double? Function(String) _toValue;
  ///
  /// Create [CargoStowageFactorRecord] that giving access
  /// to field of cargo stowage factor record stored in database.
  ///
  /// Value can be obtained using:
  ///   - `dbName` - name of database;
  ///   - `tableName` - name of database table;
  ///   - `apiAddress` - [ApiAddress] of server that interact with database;
  ///   - `authToken` - string  authentication token for accessing server;
  ///   - `toValue` - function for parsing string representation of
  /// field into value of desired type.
  const CargoStowageFactorRecord({
    required ApiAddress apiAddress,
    required String dbName,
    required String tableName,
    String? authToken,
    int? id,
    required double? Function(String value) toValue,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _tableName = tableName,
        _authToken = authToken,
        _id = id,
        _toValue = toValue;
  ///
  /// Returns result of field fetching.
  @override
  Future<ResultF<double?>> fetch() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
          SELECT (1.0 / density) AS "stowageFactor" FROM $_tableName
          WHERE id = $_id
          LIMIT 1;
        """,
      ),
      entryBuilder: (row) => '${row['stowageFactor']}',
    );
    return sqlAccess
        .fetch()
        .then<ResultF<double?>>(
          (result) => switch (result) {
            Ok(:final value) => Ok(_toValue(value.first)),
            Err(:final error) => Err(Failure(
                message: '$error',
                stackTrace: StackTrace.current,
              )),
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
  Future<ResultF<double?>> persist(String value) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
          UPDATE $_tableName
          SET density=(1.0 / $value)
          WHERE id = $_id
          RETURNING (1.0 / density) AS "stowageFactor";
        """,
      ),
      entryBuilder: (row) => '${row['stowageFactor']}',
    );
    return sqlAccess
        .fetch()
        .then<ResultF<double?>>(
          (result) => switch (result) {
            Ok(:final value) => Ok(_toValue(value.first)),
            Err(:final error) => Err(Failure(
                message: '$error',
                stackTrace: StackTrace.current,
              )),
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
