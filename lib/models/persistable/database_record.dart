import 'package:hmi_core/hmi_core.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

class DatabaseRecord {
  static final _log = const Log('SqlRecord')..level = LogLevel.debug;
  final String _id;
  final String _tableName;
  final String _dbName;
  final ApiAddress _apiAddress;

  const DatabaseRecord({
    required String id,
    required String tableName,
    required String dbName,
    required ApiAddress apiAddress,
  })  : _id = id,
        _tableName = tableName,
        _dbName = dbName,
        _apiAddress = apiAddress;

  Future<ResultF<String>> fetch() {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  Future<ResultF<String>> persist(String value) {
    // TODO: implement persist
    throw UnimplementedError();
  }
}
