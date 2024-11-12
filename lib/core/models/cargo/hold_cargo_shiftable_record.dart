import 'package:hmi_core/hmi_core.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
///
/// Gives access to field of hold cargo shiftable record stored in database.
final class HoldCargoShiftableRecord implements ValueRecord<bool> {
  final ApiAddress _apiAddress;
  final String? _authToken;
  final String _dbName;
  final int? _id;
  final bool Function(String) _toValue;
  ///
  /// Create [HoldCargoShiftableRecord] that giving access
  /// to field of hold cargo shiftable record stored in database.
  ///
  /// Value can be obtained using:
  ///   - [dbName] – name of the database;
  ///   - [apiAddress] – [ApiAddress] of server that interact with database;
  ///   - [authToken] – string  authentication token for accessing server;
  ///   - [toValue] – function for parsing string representation of
  /// field into value of desired type.
  const HoldCargoShiftableRecord({
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
            CASE
                WHEN cc.matter_type = 'bulk' THEN 'true'
                ELSE 'false'
            END AS "shiftable"
        FROM hold_compartment AS hc
        JOIN cargo_category AS cc ON
            hc.category_id = cc.id
        WHERE
            hc.id = $_id
        LIMIT 1;
        """,
      ),
      entryBuilder: (row) => '${row['shiftable']}',
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
          UPDATE hold_compartment
          SET category_id = ${switch (_toValue(value)) {
          true => 12,
          false => 11,
        }}
          WHERE id = $_id;
        """,
      ),
    );
    return sqlAccess
        .fetch()
        .then<ResultF<bool>>(
          (result) => switch (result) {
            Ok() => Ok(_toValue(value)),
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
