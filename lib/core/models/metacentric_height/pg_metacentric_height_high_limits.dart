import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/metacentric_height/json_metacentric_height_limit.dart';
import 'package:sss_computing_client/core/models/metacentric_height/metacentric_height_limits.dart';
import 'package:sss_computing_client/core/models/metacentric_height/metacentric_height_limit.dart';
///
/// Collection of [MetacentricHeightLimit] stored in Postgres DB
class PgMetacentricHeightHighLimits implements MetacentricHeightLimits {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates object with access to [List] of [MetacentricHeightLimit] stored in Postgres DB
  const PgMetacentricHeightHighLimits({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Future<Result<List<MetacentricHeightLimit>, Failure<String>>>
      fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(sql: """
        SELECT
          project_id AS "projectId",
          ship_id AS "shipId",
          low_limit AS "low",
          high_limit AS "high",
          displacement AS "dependentValue"
        FROM metacentric_height_high_limit;
      """),
      entryBuilder: (row) => JsonMetacentricHeightLimit(json: row),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<MetacentricHeightLimit>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final limits) => Ok(limits),
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
