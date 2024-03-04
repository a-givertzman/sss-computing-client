import 'package:hmi_core/hmi_core_result_new.dart';

class FieldStored {
  String _data;
  FieldStored({required String data}) : _data = data;

  Future<ResultF<String>> persist(String value) {
    _data = value;
    return fetch();
  }

  Future<ResultF<String>> fetch() {
    return Future.value(Ok(_data));
  }
}
