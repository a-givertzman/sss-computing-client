import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargos.dart';
import 'package:sss_computing_client/core/models/cargo/compartment_cargos_sql_access.dart';
///
/// Stores tanks [Cargos] collection stored in postgres DB.
class PgStoresTanks implements Cargos {
  final String _dbName;
  final ApiAddress _apiAddress;
  final String? _authToken;
  ///
  /// Creates stores tanks [Cargos] collection stored in DB.
  const PgStoresTanks({
    required String dbName,
    required ApiAddress apiAddress,
    String? authToken,
  })  : _dbName = dbName,
        _apiAddress = apiAddress,
        _authToken = authToken;
  //
  @override
  Future<Result<List<Cargo>, Failure<String>>> fetchAll() async {
    return CompartmentCargosSqlAccess(
      dbName: _dbName,
      apiAddress: _apiAddress,
      authToken: _authToken,
      filter: {
        'cgc.key': 'stores',
        'cc.matter_type': 'liquid',
      },
    )
        .fetch()
        .then<Result<List<Cargo>, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final cargos) => Ok(cargos),
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
  //
  @override
  Future<Result<Cargo, Failure<String>>> fetchById(int id) async {
    return CompartmentCargosSqlAccess(
      dbName: _dbName,
      apiAddress: _apiAddress,
      authToken: _authToken,
      filter: {'c.id': id},
    )
        .fetch()
        .then<Result<Cargo, Failure<String>>>(
          (result) => switch (result) {
            Ok(value: final cargos) => Ok(cargos.first),
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
