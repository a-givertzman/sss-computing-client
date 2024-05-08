import 'dart:async';
import 'dart:convert';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/frames/frame_space.dart';
/// Interface for controlling collection of [FrameSpaces].
abstract interface class FrameSpaces {
  /// Get all [FrameSpace] in [FrameSpaces] collection.
  Future<ResultF<List<FrameSpace>>> fetchAll();
}
/// [FrameSpaces] collection stored in postgres DB.
class PgFrameSpaces implements FrameSpaces {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  /// Creates [FrameSpaces] collection stored in DB.
  const PgFrameSpaces({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<ResultF<List<FrameSpace>>> fetchAll() async {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
            SELECT
              index,
              ship_id,
              project_id,
              json_object_agg(
                key,
                json_build_object('value', value)
              )::text as parameters
            FROM theoretical_frame
            GROUP BY index, ship_id, project_id
            ORDER BY index ASC;
            """,
      ),
      entryBuilder: (row) => row,
    );
    return switch (await sqlAccess.fetch()) {
      Ok(value: final rows) => _mapReplyToValue(rows),
      Err(:final error) => Err(error),
    };
  }
  ///
  ResultF<List<FrameSpace>> _mapReplyToValue(List<Map<String, dynamic>> rows) {
    try {
      return Ok(rows.map((row) {
        final Map<String, dynamic> json = jsonDecode(row['parameters'])
          ..['index'] = row['index']
          ..['ship_id'] = row['ship_id']
          ..['project_id'] = row['project_id'];
        Log('$runtimeType').debug(JsonFrameSpace(json: json));
        return JsonFrameSpace(json: json);
      }).toList());
    } catch (err) {
      return Err(Failure(message: err, stackTrace: StackTrace.current));
    }
  }
}
