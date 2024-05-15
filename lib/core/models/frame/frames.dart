import 'dart:async';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/frame/frame.dart';
///
/// Interface for controlling collection of [Frames].
abstract interface class Frames {
  /// Get all [Frame] in [Frames] collection.
  Future<Result<List<Frame>, Failure<String>>> fetchAll();
  /// Get [Frame] by it's index;
  Future<Result<Frame, Failure<String>>> fetchByIndex(int index);
}
///
/// Theoretical [Frames] collection stored in postgres DB.
class PgFramesTheoretical implements Frames {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates [Frames] collection stored in DB.
  const PgFramesTheoretical({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<Frame>, Failure<String>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              project_id AS "projectId",
              ship_id AS "shipId",
              index AS "index",
              value AS "x"
            FROM computed_frame
            WHERE
              key = 'start_x'
            UNION
            SELECT
              project_id AS "projectId",
              ship_id AS "shipId",
              index + 1 AS "index",
              value AS "x"
            FROM computed_frame
            WHERE
              key = 'end_x'
            ORDER BY index;
            """,
      ),
      entryBuilder: (row) => JsonFrame(json: row),
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final frames) => Ok(frames),
      Err(:final error) => Err(Failure(
          message: '$error',
          stackTrace: StackTrace.current,
        )),
    };
  }
  //
  @override
  Future<Result<Frame, Failure<String>>> fetchByIndex(int index) async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              project_id AS "projectId",
              ship_id AS "shipId",
              index AS "index",
              value AS "x"
            FROM computed_frame
            WHERE
              key = 'start_x'
              AND index = $index
            UNION
            SELECT
              project_id AS "projectId",
              ship_id AS "shipId",
              index + 1 AS "index",
              value AS "x"
            FROM computed_frame
            WHERE
              key = 'end_x'
              AND index = ${index - 1}
            ;
            """,
      ),
      entryBuilder: (row) => JsonFrame(json: row),
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final frames) => frames.isNotEmpty
          ? Ok(frames.first)
          : Err(Failure(
              message: 'Frame not found',
              stackTrace: StackTrace.current,
            )),
      Err(:final error) => Err(Failure(
          message: '$error',
          stackTrace: StackTrace.current,
        )),
    };
  }
}
