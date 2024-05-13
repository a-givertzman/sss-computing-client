import 'dart:async';
import 'dart:convert';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/frames/frame.dart';
/// Interface for controlling collection of [Frames].
abstract interface class Frames {
  /// Get all [Frame] in [Frames] collection.
  Future<ResultF<List<Frame>>> fetchAll();
}
/// [Frames] collection stored in postgres DB.
class PgFrames implements Frames {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  /// Creates [Frames] collection stored in DB.
  const PgFrames({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<ResultF<List<Frame>>> fetchAll() async {
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
  ResultF<List<Frame>> _mapReplyToValue(List<Map<String, dynamic>> rows) {
    try {
      return Ok(rows.map((row) {
        final Map<String, dynamic> json = jsonDecode(row['parameters'])
          ..['index'] = row['index']
          ..['ship_id'] = row['ship_id']
          ..['project_id'] = row['project_id'];
        Log('$runtimeType').debug(JsonFrame(json: json));
        return JsonFrame(json: json);
      }).toList());
    } catch (err) {
      return Err(Failure(message: err, stackTrace: StackTrace.current));
    }
  }
}
