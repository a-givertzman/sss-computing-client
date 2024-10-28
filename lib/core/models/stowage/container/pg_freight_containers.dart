import 'dart:async';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_containers.dart';
/// TODO:
class PgFreightContainers implements FreightContainers {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const PgFreightContainers({
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  @override
  Future<Result<List<FreightContainer>, Failure<String>>> fetchAll() {
    final sqlAccess = SqlAccess(
      address: _apiAddress,
      database: _dbName,
      authToken: _authToken ?? '',
      sqlBuilder: (_, __) => Sql(sql: '''
        SELECT
          c.id AS "id",
          c.mass AS "mass",
          c.iso_code AS "isoCode",
          c.pol_code AS "polCode",
          c.pod_code AS "podCode"
        FROM container AS c
        ORDER BY id;
      '''),
      entryBuilder: (row) => FreightContainer.fromSizeCode(
        row['isoCode'] as String,
        id: row['id'] as int,
        serial: row['id'] as int,
        cargoWeight: row['mass'] as double,
        polCode: row['polCode'] as String?,
        podCode: row['podCode'] as String?,
      ),
    );
    return sqlAccess
        .fetch()
        .then<Result<List<FreightContainer>, Failure<String>>>(
          (result) => switch (result) {
            Ok(:final value) => Ok(value),
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
