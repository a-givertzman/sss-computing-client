import 'package:hmi_core/hmi_core.dart';

class FieldStored {
  String _data;
  FieldStored({required String data}) : _data = data;

  Future<Result<String>> persist(String value) {
    _data = value;
    return fetch();
  }

  Future<Result<String>> fetch() {
    return Future.value(Result(data: _data));
  }
}
