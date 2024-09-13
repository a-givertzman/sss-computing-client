import 'package:hmi_core/hmi_core.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
/// Gives access to field of cargo useMaxMfs record stored in database.
final class CargoUseMaxMfsRecord implements ValueRecord<bool> {
  final ApiAddress _apiAddress;
  final String? _authToken;
  final String _dbName;
  final int? _id;
  final bool Function(String) _toValue;
  ///
  /// Create [CargoUseMaxMfsRecord] that giving access
  /// to field of cargo useMaxMfs record stored in database.
  ///
  /// Value can be obtained using:
  ///   - `dbName` - name of the database;
  ///   - `apiAddress` - [ApiAddress] of server that interact with database;
  ///   - `authToken` - string  authentication token for accessing server;
  ///   - `toValue` - function for parsing string representation of
  /// field into value of desired type.
  const CargoUseMaxMfsRecord({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
    int? id,
    required bool Function(String value) toValue,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _id = id,
        _authToken = authToken,
        _toValue = toValue;
  ///
  /// Returns result of field fetching.
  @override
  Future<ResultF<bool>> fetch() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
        SELECT
            c.use_max_m_f_s AS "useMaxMfs"
        FROM compartment AS c
        WHERE
            c.id = $_id
        LIMIT 1;
        """,
      ),
      entryBuilder: (row) => '${row['useMaxMfs']}',
    );
    return sqlAccess
        .fetch()
        .then<ResultF<bool>>(
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
  Future<ResultF<bool>> persist(String value) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
          UPDATE compartment AS c
          SET
              use_max_m_f_s = '${_toValue(value)}'
          WHERE
              c.id = $_id
          RETURNING
              c.use_max_m_f_s AS "useMaxMfs";
        """,
      ),
      entryBuilder: (row) => row['useMaxMfs'],
    );
    return sqlAccess
        .fetch()
        .then<ResultF<bool>>(
          (result) => switch (result) {
            Ok(:final value) => Ok(value.first),
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
