import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart' hide Curve;
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/stability_curve/curve.dart';
///
/// Static stabilty [Curve] stored in Postgres DB.
final class PgStaticStabilityCurve implements Curve {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates static stabilty [Curve] that stored in Postgres DB.
  ///   - [apiAddress] – [ApiAddress] of server that interact with database;
  ///   - [dbName] – name of the database;
  ///   - [authToken] – string  authentication token for accessing server;
  const PgStaticStabilityCurve({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Future<Result<List<Offset>, Failure<String>>> points() {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
          SELECT
            project_id AS "projectId",
            ship_id AS "shipId",
            angle AS "x",
            value_dso AS "y"
          FROM stability_diagram
          WHERE ship_id = 1 AND angle >= 0.0
          ORDER BY angle ASC;
        """,
      ),
      entryBuilder: (row) => Offset(
        row['x'] as double,
        row['y'] as double,
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<Offset>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final curve) => Ok(curve),
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
