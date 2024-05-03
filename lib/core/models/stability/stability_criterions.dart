import 'dart:async';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/criterion/criterion.dart';
/// Interface for controlling collection of [Criterion].
abstract interface class StabilityCriterions {
  /// Get all [Criterion] in [StabilityCriterions] collection.
  Future<ResultF<List<Criterion>>> fetchAll();
}
/// [StabilityCriterions] collection stored in DB.
class DBStabilityCriterions implements StabilityCriterions {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  /// Creates [StabilityCriterions] collection that stored in DB.
  const DBStabilityCriterions({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  ///
  get apiAddress => _apiAddress;
  ///
  get dbName => _dbName;
  //
  @override
  Future<ResultF<List<Criterion>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              title AS name,
              value1 AS value,
              value2 AS limit,
              relation,
              unit,
              description
            FROM result_stability;
            """,
      ),
      entryBuilder: (row) => row,
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final rows) => _mapReplyToValue(rows),
      Err(:final error) => Err(Failure<String>(
          message: '${error.message}',
          stackTrace: StackTrace.current,
        )),
    };
  }
  ///
  ResultF<List<Criterion>> _mapReplyToValue(List<Map<String, dynamic>> rows) {
    try {
      return Ok(rows.map((row) => JsonCriterion(json: row)).toList());
    } catch (err) {
      return Err(Failure<String>(
        message: '$err',
        stackTrace: StackTrace.current,
      ));
    }
  }
}
