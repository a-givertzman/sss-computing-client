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
                cfs.project_id AS "projectId",
                cfs.ship_id AS "shipId",
                cfs.index AS "index",
                cfs.start_x - sp.value::REAL AS "x"
              FROM computed_frame_space AS cfs
              INNER JOIN ship_parameters AS sp
              ON cfs.ship_id = sp.ship_id AND sp.key = 'X midship from Fr0'
              UNION
              SELECT
                cfs.project_id AS "projectId",
                cfs.ship_id AS "shipId",
                cfs.index + 1 AS "index",
                cfs.end_x - sp.value::REAL AS "x"
              FROM computed_frame_space AS cfs
              INNER JOIN ship_parameters AS sp
              ON cfs.ship_id = sp.ship_id AND sp.key = 'X midship from Fr0'
              WHERE cfs.ship_id = 1
              ORDER BY "index";
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
}
///
/// Real [Frames] collection stored in postgres DB.
class PgFramesReal implements Frames {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates [Frames] collection stored in DB.
  const PgFramesReal({
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
              pf.project_id AS "projectId",
              pf.ship_id AS "shipId",
              pf.frame_index AS "index",
              pf.pos_x - sp.value::REAL AS "x"
            FROM physical_frame AS pf
            INNER JOIN ship_parameters AS sp
            ON pf.ship_id = sp.ship_id AND sp.key = 'X midship from Fr0'
            ORDER BY "index";
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
}
