import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/heel_trim/heel_trim.dart';
import 'package:sss_computing_client/core/models/heel_trim/json_heel_trim.dart';
///
/// Interface for instance of [HeelTrim] stored in postgres DB.
class PgHeelTrim {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates interface for instance of [HeelTrim] stored in postgres DB.
  const PgHeelTrim({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  ///
  /// Fetch and return [HeelTrim] from postgres DB.
  Future<Result<HeelTrim, Failure<String>>> fetch() {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      authToken: _authToken ?? '',
      database: _dbName,
      sqlBuilder: (_, __) => Sql(
        sql: """
          SELECT
            ship_id AS "shipId",
            draft_fp_value AS "draftFPValue",
            draft_fp_shift AS "draftFPShift",
            draft_avg_value AS "draftAvgValue",
            draft_avg_shift AS "draftAvgShift",
            draft_ap_value AS "draftAPValue",
            draft_ap_shift AS "draftAPShift",
            heel AS "heel",
            trim AS "trim"
          FROM
            heel_trim_general
          WHERE
            ship_id = $shipId AND
            project_id IS NOT DISTINCT FROM ${projectId ?? 'NULL'}
          LIMIT 1;
        """,
      ),
      entryBuilder: (row) => JsonHeelTrim(json: {
        'projectId': null,
        'shipId': row['shipId'] as int,
        'heel': row['heel'] as double,
        'trim': row['trim'] as double,
        'draftAP': (
          offset: row['draftAPShift'] as double,
          value: row['draftAPValue'] as double,
        ),
        'draftAvg': (
          offset: row['draftAvgShift'] as double,
          value: row['draftAvgValue'] as double,
        ),
        'draftFP': (
          offset: row['draftFPShift'] as double,
          value: row['draftFPValue'] as double,
        ),
      }),
    );
    return sqlAccess
        .fetch()
        .then<Result<HeelTrim, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final result) => Ok(result.first),
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
